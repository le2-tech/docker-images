FROM node:latest AS builder

RUN npm install -g @vue/cli --loglevel verbose

RUN npx degit dcloudio/uni-preset-vue#vite /app

WORKDIR /app

RUN set -eux; \
    npm update --loglevel verbose; \
    npm i vue@latest pinia@^2.3.1 decimal.js@latest; \
    npm i -D sass@latest vite@latest;
