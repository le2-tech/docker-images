#!/usr/bin/env bash
set -euo pipefail

# ========= 配置 =========
# GitHub 命名空间（用户名或组织名），用于 ghcr.io/<owner>/*
: "${GHCR_OWNER:?请先 export GHCR_OWNER=你的GitHub用户名或组织名}"
GHCR_NS="ghcr.io/${GHCR_OWNER}"

# 迁移的镜像数组（可扩展）
IMAGES=(
  # "alpine:latest"
  # "debian:latest"
  # "ubuntu:latest"
  # "neilpang/acme.sh:latest"
  # "nginx:latest"
  # "node:latest"
  # "redis:latest"
  # "fluent/fluent-bit:latest"
  # "golang:latest"
  # "timescale/timescaledb:latest-pg18"
  # "emqx/emqx:5.8.8"
  "emqx/mqttx-web:latest"
  "emqx/mqttx-cli:latest"
  "emqx/emqtt-bench:latest"
)

# 需要合并的架构
PLATFORMS=("linux/amd64" "linux/arm64")
# ========================

command -v docker >/dev/null || { echo "需要安装 docker"; exit 1; }

for image in "${IMAGES[@]}"; do
  # 直接使用用户给的引用，不做 docker.io 强制前缀
  src_ref="${image}"

  # 拆 name 和 tag（若未显式写 tag，默认 latest）
  if [[ "$image" == *:* ]]; then
    name_part="${image%%:*}"
    tag_part="${image##*:}"
  else
    name_part="${image}"
    tag_part="latest"
    src_ref="${image}:latest"
  fi

  # 目标仓库名沿用源名最后一段
  repo_base="${name_part##*/}"
  dest_repo="${GHCR_NS}/${repo_base}"
  dest_final="${dest_repo}:${tag_part}"

  echo
  echo "=============================================="
  echo "迁移 ${src_ref}  ->  ${dest_final}"
  echo "=============================================="

  per_arch_refs=()

  for platform in "${PLATFORMS[@]}"; do
    arch="${platform#*/}"  # amd64 / arm64
    echo "==> Pull ${src_ref} for ${platform}"
    if ! docker pull --platform "${platform}" "${src_ref}"; then
      echo "⚠️  ${src_ref} 不包含 ${platform}，跳过该架构。"
      continue
    fi

    # 立刻取本地镜像 ID 并打上 per-arch 目标标签，避免后续 pull 覆盖
    img_id="$(docker inspect --format='{{.Id}}' "${src_ref}")"
    arch_tag="${dest_repo}:${tag_part}-${arch}"

    echo "-- 标记本地镜像 ${img_id} -> ${arch_tag}"
    docker tag "${img_id}" "${arch_tag}"

    echo "-- Push ${arch_tag}"
    docker push "${arch_tag}"

    per_arch_refs+=("${arch_tag}")
  done

  if ((${#per_arch_refs[@]}==0)); then
    echo "❌ 未成功获取任何架构，跳过 ${dest_final}"
    continue
  fi

  echo "==> 创建多架构 manifest: ${dest_final}"
  docker manifest create "${dest_final}" "${per_arch_refs[@]}"

  for platform in "${PLATFORMS[@]}"; do
    arch="${platform#*/}"
    arch_tag="${dest_repo}:${tag_part}-${arch}"
    if docker manifest inspect "${arch_tag}" >/dev/null 2>&1; then
      docker manifest annotate "${dest_final}" "${arch_tag}" --os linux --arch "${arch}"
    fi
  done

  echo "==> Push 多架构 manifest: ${dest_final}"
  docker manifest push --purge "${dest_final}"

  # （可选）清理本地中间镜像
  # for platform in "${PLATFORMS[@]}"; do
  #   arch="${platform#*/}"
  #   docker image rm -f "${dest_repo}:${tag_part}-${arch}" || true
  # done
done

echo "✅ 全部完成。"
