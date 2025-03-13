#!/bin/bash
# docker_task2.sh
set -eu

# 加载上级目录 .env 文件
if [ -f ../.env ]; then
  source ../.env
else
  echo "../.env 文件不存在."
  exit 1
fi

# 检查 Docker 登录所需环境变量
if [ -z "${MIGRATE_USERNAME:-}" ] || [ -z "${MIGRATE_PASSWORD:-}" ]; then
  echo "请设置环境变量 MIGRATE_USERNAME 和 MIGRATE_PASSWORD"
  exit 1
fi

docker login -u "$MIGRATE_USERNAME" -p "$MIGRATE_PASSWORD" "${MIGRATE_HOST:-}"

# 定义任务，只写源镜像
MIGRATIONS=(
  # nginx:latest
  # node:latest
  # axllent/mailpit:latest
  # adminer
  # mysql:8.4
  # redis:latest
  # redislabs/redisinsight:latest
  # minio/minio:latest
  # cdle2/awscli
  # cdle2/node-uniapp:3
  # fluent/fluent-bit:latest
  # cdle2/php:8.3-cli
  # cdle2/php:8.3-fpm
  # cdle2/rabbitmq:3-management
)
# 默认平台及目标镜像前缀
DEFAULT_PLATFORMS=("linux/amd64:le2-amd64" "linux/arm64/v8:le2-arm64")

for task in "${MIGRATIONS[@]}"; do
  read -ra parts <<< "$task"
  if [ ${#parts[@]} -ne 1 ]; then
    echo "错误：任务格式不正确: $task"
    exit 1
  fi
  for mapping in "${DEFAULT_PLATFORMS[@]}"; do
    IFS=":" read -r PLATFORM PREFIX <<< "$mapping"
    TARGET_IMAGE="${PREFIX}/${parts[0]##*/}"
    echo "------------------------------------------"
    echo "开始迁移镜像："
    echo "  源镜像      : ${parts[0]}"
    echo "  平台        : ${PLATFORM}"
    echo "  目标镜像    : ${TARGET_IMAGE}"
    ./docker_migrate.sh "${parts[0]}" "$PLATFORM" "$TARGET_IMAGE"
  done
done

echo "所有镜像迁移任务已完成。"
