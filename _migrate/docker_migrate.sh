#!/bin/bash
set -eu

# 加载上级目录 .env 文件中的环境变量
env_type_file=./.env
if [ -f $env_type_file ]; then
  echo "加载 $env_type_file 文件中的环境变量..."
  source $env_type_file
else
  echo "$env_type_file 文件不存在."
  exit 1
fi

# 
env_file=./_env/${BASIC_ENV}.env
if [ -f $env_file ]; then
  echo "加载 $env_file 文件中的环境变量..."
  source $env_file
else
  echo "$env_file 文件不存在."
  exit 1
fi

# 如果 .env 中定义了 host_proxy，则导出（例如：host_proxy="https_proxy=... http_proxy=..."）
if [ -n "${host_proxy:-}" ]; then
  eval "export $host_proxy"
fi

# 检查 Docker 登录所需环境变量
if [ -z "${MIGRATE_USERNAME:-}" ] || [ -z "${MIGRATE_PASSWORD:-}" ]; then
  echo "请设置环境变量 MIGRATE_USERNAME 和 MIGRATE_PASSWORD"
  exit 1
fi

echo "正在登录 Docker Hub ..."
docker login -u "$MIGRATE_USERNAME" -p "$MIGRATE_PASSWORD" "${MIGRATE_HOST:-}"

REPO=coolcry

# 定义迁移任务（只写源镜像，格式例如： "axllent/mailpit:latest"）
MIGRATIONS=(
  "neilpang/acme.sh:latest"
  "linuxserver/libreoffice:latest"
  "nginx:latest"
  "node:latest"
  "axllent/mailpit:latest"
  "adminer"
  "mysql:8.4"
  "redis:latest"
  "redislabs/redisinsight:latest"
  "minio/minio:latest"
  "${REPO}/awscli"
  "${REPO}/node-uniapp:3"
  "fluent/fluent-bit:latest"
  "golang:latest"
  "${REPO}/php:8.3-cli"
  "${REPO}/php:8.3-fpm"
  "${REPO}/rabbitmq:3-management"
)
# 默认平台及目标镜像前缀映射，格式：platform:prefix
DEFAULT_PLATFORMS=("linux/amd64:le2-amd64" "linux/arm64/v8:le2-arm64")

# 定义一个函数完成单个镜像的迁移操作：拉取、打标签和推送
migrate_image() {
  local SOURCE_IMAGE="$1"
  local PLATFORM="$2"
  # 构造目标镜像：最终目标镜像为 "${MIGRATE_HOST}/${TARGET_PARAM}"
  local TARGET_PARAM="$3"
  local TARGET_IMAGE="${MIGRATE_HOST}/${TARGET_PARAM}"

  echo "拉取指定平台 ${PLATFORM} 的镜像：${SOURCE_IMAGE} ..."
  local max_attempts=5
  local attempt_num=1
  while [ $attempt_num -le $max_attempts ]; do
      echo "第 $attempt_num 次尝试拉取镜像..."
      if docker pull --platform "${PLATFORM}" "${SOURCE_IMAGE}"; then
          echo "镜像拉取成功。"
          break
      fi
      echo "拉取失败。"
      if [ $attempt_num -eq $max_attempts ]; then
          echo "已达到最大重试次数，退出。"
          exit 1
      fi
      local sleep_time=$(( attempt_num * 2 ))
      echo "等待 ${sleep_time} 秒后重试..."
      sleep "$sleep_time"
      attempt_num=$(( attempt_num + 1 ))
  done

  echo "打标签：${SOURCE_IMAGE} -> ${TARGET_IMAGE} ..."
  docker tag "${SOURCE_IMAGE}" "${TARGET_IMAGE}"

  echo "推送镜像：${TARGET_IMAGE} ..."
  docker push "${TARGET_IMAGE}"

  echo "镜像迁移完成。"
}

# 遍历每个任务，生成对应平台的目标镜像参数后调用迁移函数
for task in "${MIGRATIONS[@]}"; do
  read -ra parts <<< "$task"
  if [ ${#parts[@]} -ne 1 ]; then
    echo "错误：任务格式不正确: $task"
    exit 1
  fi
  # 遍历默认平台映射
  for mapping in "${DEFAULT_PLATFORMS[@]}"; do
    IFS=":" read -r PLATFORM PREFIX <<< "$mapping"
    # 对于类似 "axllent/mailpit:latest" 的镜像，取最后部分作为镜像名（例如 mailpit:latest）
    IMAGE_NAME="${parts[0]##*/}"
    TARGET_PARAM="${PREFIX}/${IMAGE_NAME}"
    echo "------------------------------------------"
    echo "开始迁移镜像："
    echo "  源镜像      : ${parts[0]}"
    echo "  平台        : ${PLATFORM}"
    echo "  目标镜像参数: ${TARGET_PARAM}"
    migrate_image "${parts[0]}" "${PLATFORM}" "${TARGET_PARAM}"
  done
done

echo "所有镜像迁移任务已完成。"
