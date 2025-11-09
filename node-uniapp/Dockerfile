# FROM node:latest
# FROM node:trixie-slim
FROM node:alpine

RUN apk add --no-cache git ca-certificates;

RUN npm install -g @vue/cli --loglevel verbose

# https://github.com/dcloudio/uni-preset-vue/tree/vite
RUN npx degit dcloudio/uni-preset-vue#vite /app

WORKDIR /app

RUN set -eux; \
    npm update --loglevel verbose; \
    npm i vue@latest vue-router@latest pinia@latest decimal.js@latest; \
    npm i -D sass@latest;

# RUN set -eux; \
#     npm i -D vite@latest;
