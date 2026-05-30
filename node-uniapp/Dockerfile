ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}node:alpine

ARG ALPINE_MIRROR
ARG NPM_MIRROR

# 替换为国内镜像源并安装基础依赖
RUN set -eux; \
    if [ -n "${ALPINE_MIRROR:-}" ]; then \
      sed -i "s|https://dl-cdn.alpinelinux.org|${ALPINE_MIRROR}|g" /etc/apk/repositories; \
    fi; \
    apk add --no-cache git ca-certificates

# 安装 @vue/cli（全局）
RUN set -eux; \
    if [ -n "${NPM_MIRROR:-}" ]; then \
      npm config set registry "${NPM_MIRROR}"; \
    fi; \
    npm install -g @vue/cli --loglevel verbose; \
    npm cache clean --force

# 使用 degit 从模板创建 uni-app 项目
# https://github.com/dcloudio/uni-preset-vue/tree/vite
RUN set -eux; \
    if [ -n "${NPM_MIRROR:-}" ]; then \
      npm config set registry "${NPM_MIRROR}"; \
    fi; \
    npx degit dcloudio/uni-preset-vue#vite /app

WORKDIR /app

# 安装模板依赖并更新关键包
RUN set -eux; \
    if [ -n "${NPM_MIRROR:-}" ]; then \
      npm config set registry "${NPM_MIRROR}"; \
    fi; \
    npm update --loglevel verbose; \
    npm i vue@latest pinia@latest; \
    npm i -D sass@latest; \
    npm cache clean --force
