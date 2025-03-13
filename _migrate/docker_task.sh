#!/bin/bash
# run_all_migrations.sh
# 功能：批量执行固定镜像迁移任务，每个任务调用 docker_migrate.sh 完成镜像拉取、打标签和推送
#
# 要求：
# 1. docker_migrate.sh 与本文件在同一目录下，并已赋予执行权限
# 2. 环境变量 MIGRATE_USERNAME 和 MIGRATE_PASSWORD 已设置，用于 docker login
# 3. 每个任务必须包含 platform 参数

set -eu

# 加载 .env 文件中的环境变量
if [ -f ../.env ]; then
  echo "加载 ../.env 文件中的环境变量..."
  source ../.env
else
  echo "../.env 文件不存在."
  exit 1
fi

# 检查 Docker 登录所需的环境变量是否存在
if [ -z "$MIGRATE_USERNAME" ] || [ -z "$MIGRATE_PASSWORD" ]; then
  echo "请设置环境变量 MIGRATE_USERNAME 和 MIGRATE_PASSWORD 用于 docker login"
  exit 1
fi

echo "正在登录 Docker Hub ..."
docker login -u "$MIGRATE_USERNAME" -p "$MIGRATE_PASSWORD" "$MIGRATE_HOST"

# 定义固定镜像任务，每个任务格式： "源镜像 平台 目标镜像"
MIGRATIONS=(
  "nginx:latest linux/amd64 le2-amd64/nginx:latest"
  "nginx:latest linux/arm64/v8 le2-arm64/nginx:latest"
)

# 循环处理每个任务
for task in "${MIGRATIONS[@]}"; do
  # 使用 read 分解任务内容
  read -r SRC_IMAGE PLATFORM TARGET_IMAGE  <<< "$task"
  echo "------------------------------------------"
  echo "开始迁移镜像："
  echo "  源镜像      : ${SRC_IMAGE}"
  echo "  平台        : ${PLATFORM}"
  echo "  原目标镜像  : ${TARGET_IMAGE}"

  ./docker_migrate.sh "$SRC_IMAGE" "$PLATFORM" "$TARGET_IMAGE" 
done

echo "所有镜像迁移任务已完成。"
