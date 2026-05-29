ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}node:alpine

ARG ALPINE_MIRROR
ARG NPM_MIRROR

RUN set -eux; \
    if [ -n "${ALPINE_MIRROR:-}" ]; then \
      sed -i "s|dl-cdn.alpinelinux.org|${ALPINE_MIRROR}|g" /etc/apk/repositories; \
    fi; \
    apk add --no-cache git ca-certificates

RUN set -eux; \
    if [ -n "${NPM_MIRROR:-}" ]; then \
      npm config set registry "${NPM_MIRROR}"; \
    fi; \
    npm install -g @vue/cli --loglevel verbose; \
    # https://github.com/dcloudio/uni-preset-vue/tree/vite
    npx degit dcloudio/uni-preset-vue#vite /app

WORKDIR /app

RUN set -eux; \
    npm update --loglevel verbose; \
    npm i vue@latest pinia@latest; \
    npm i -D sass@latest; \
    npm cache clean --force

# RUN set -eux; \
#     npm i -D vite@latest;
