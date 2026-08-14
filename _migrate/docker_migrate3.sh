#!/usr/bin/env bash
set -euo pipefail

: "${TARGET_NS:?请先 export TARGET_NS=目标仓库命名空间，例如 registry.cn-chengdu.aliyuncs.com/le2-tech}"

IMAGES=(
  "alpine:latest"
  "node:alpine"
  "debian:latest"
  "neilpang/acme.sh:latest"
  "nginx:latest"
  "golang:latest"
  "timescale/timescaledb:latest-pg18"
)

PLATFORMS=(
  "linux/amd64"
  "linux/arm64"
)

command -v docker >/dev/null || {
  echo "需要安装 docker"
  exit 1
}

for image in "${IMAGES[@]}"; do
  src_ref="${image}"

  if [[ "$image" == *:* ]]; then
    name_part="${image%%:*}"
    tag_part="${image##*:}"
  else
    name_part="${image}"
    tag_part="latest"
    src_ref="${image}:latest"
  fi

  repo_base="${name_part##*/}"
  dest_repo="${TARGET_NS}/${repo_base}"
  dest_final="${dest_repo}:${tag_part}"

  echo
  echo "=============================================="
  echo "迁移 ${src_ref} -> ${dest_final}"
  echo "=============================================="

  per_arch_refs=()
  per_arch_platforms=()

  for platform in "${PLATFORMS[@]}"; do
    arch="${platform#*/}"
    arch_tag="${dest_repo}:${tag_part}-${arch}"

    echo
    echo "==> Pull ${src_ref} for ${platform}"

    if ! docker pull --platform "${platform}" "${src_ref}"; then
      echo "⚠️ ${src_ref} 不包含 ${platform}，跳过。"
      continue
    fi

    img_id="$(docker inspect --format='{{.Id}}' "${src_ref}")"

    echo "-- Tag ${img_id} -> ${arch_tag}"
    docker tag "${img_id}" "${arch_tag}"

    echo "-- Push ${arch_tag} (${platform})"

    # 关键：
    # 强制只 push 当前架构 manifest，
    # 不允许把本地 image index / manifest list 推上去
    docker push \
      --platform "${platform}" \
      "${arch_tag}"

    per_arch_refs+=("${arch_tag}")
    per_arch_platforms+=("${platform}")
  done

  if ((${#per_arch_refs[@]} == 0)); then
    echo "❌ 未成功获取任何架构，跳过 ${dest_final}"
    continue
  fi

  echo
  echo "==> 创建 multi-arch manifest: ${dest_final}"

  # 防止 CI 重跑时存在本地旧 manifest
  docker manifest rm "${dest_final}" >/dev/null 2>&1 || true

  docker manifest create \
    "${dest_final}" \
    "${per_arch_refs[@]}"

  for i in "${!per_arch_refs[@]}"; do
    ref="${per_arch_refs[$i]}"
    platform="${per_arch_platforms[$i]}"

    os="${platform%%/*}"
    arch="${platform#*/}"

    echo "-- Annotate ${ref}: ${os}/${arch}"

    docker manifest annotate \
      "${dest_final}" \
      "${ref}" \
      --os "${os}" \
      --arch "${arch}"
  done

  echo
  echo "==> Push multi-arch manifest: ${dest_final}"

  docker manifest push --purge "${dest_final}"

  echo
  echo "==> Verify ${dest_final}"

  docker buildx imagetools inspect "${dest_final}"
done

echo
echo "✅ 全部完成。"