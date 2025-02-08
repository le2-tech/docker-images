FROM node:latest AS builder

RUN npm install -g @vue/cli --loglevel verbose

RUN npx degit dcloudio/uni-preset-vue#vite /app

WORKDIR /app

RUN npm update --loglevel verbose \
    && npm i vue@latest pinia@latest decimal.js@latest \
    && npm i -D sass@latest \
    && npm ls