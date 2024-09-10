# 使用官方的 Alpine 基础镜像，体积非常小
FROM alpine:latest

# 设置镜像作者信息（可选）
LABEL maintainer="you@example.com"

# 更新软件包列表并安装 curl
RUN apk update && apk add --no-cache curl

# 设置容器启动时的命令，这里执行一个 curl 请求
CMD ["curl", "--version"]
