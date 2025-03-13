#!/bin/bash
# docker_migrate.sh
# 功能：从 Docker Hub 拉取镜像（必须指定平台），打标签后推送到新的仓库
# 用法：
#   ./docker_migrate.sh <source_image> <platform> <target_image> 
#
# 示例：
#   ./docker_migrate.sh nginx:latest linux/amd64 registry.cn-chengdu.aliyuncs.com/le2/nginx:latest

set -eux

usage() {
  echo "Usage: $0 <source_image> <target_image> <platform>"
  exit 1
}

if [ "$#" -ne 3 ]; then
  usage
fi

# 加载 .env 文件中的环境变量
if [ -f ../.env ]; then
  echo "加载 ../.env 文件中的环境变量..."
  source ../.env
else
  echo "../.env 文件不存在."
  exit 1
fi

export $host_proxy

SOURCE_IMAGE=$1
PLATFORM=$2
TARGET_IMAGE=${MIGRATE_HOST}/$3


echo "拉取指定平台 ${PLATFORM} 的镜像：${SOURCE_IMAGE} ..."
# docker pull --platform ${PLATFORM} ${SOURCE_IMAGE}

max_attempts=5
attempt_num=1

while [ $attempt_num -le $max_attempts ]; do
    echo "第 $attempt_num 次尝试拉取镜像..."
    # 使用 env 传递 host_proxy 环境变量
    if docker pull --platform ${PLATFORM} ${SOURCE_IMAGE}; then
        echo "镜像拉取成功。"
        break
    fi
    echo "拉取失败。"
    if [ $attempt_num -eq $max_attempts ]; then
        echo "已达到最大重试次数，退出。"
        exit 1
    fi
    sleep_time=$(( attempt_num * 2 ))
    echo "等待 $sleep_time 秒后重试..."
    sleep $sleep_time
    attempt_num=$(( attempt_num + 1 ))
done


echo "打标签：${SOURCE_IMAGE} -> ${TARGET_IMAGE} ..."
docker tag ${SOURCE_IMAGE} ${TARGET_IMAGE}

echo "推送镜像：${TARGET_IMAGE} ..."
docker push ${TARGET_IMAGE}

echo "镜像迁移完成。"
