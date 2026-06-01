# Dockerfile 格式规范

## 指令行

所有指令从第 0 列开始，不加缩进。

```dockerfile
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest
```

## 注释

注释从第 0 列开始。注释前留一个空行（与上方块分隔），注释紧贴被说明的指令（中间不插空行）。

```dockerfile
# 替换为国内镜像源加速下载
RUN set -eux; \
    ...
```

## 空行

文件不以空行开头。指令块、注释块之间空一行分隔。

## 缩进

续行使用 4 空格缩进，不用 tab。

嵌套（if/then、case/in、apt-get install 包列表、rm -rf 清理列表）在基准 4 空格基础上额外缩进 2 空格（共 6 空格）。

## ARG 声明顺序

`ARG IMAGE_MIRROR` 紧贴 `FROM` 之前（顶格）。其他 `ARG`（如 `APT_REPOSITORY`、`ALPINE_MIRROR`、`NPM_MIRROR`）放在 `FROM` 之后。

```dockerfile
# Debian 系
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest

ARG APT_REPOSITORY

# Alpine 系
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}node:alpine

ARG ALPINE_MIRROR
ARG NPM_MIRROR
```

## 多阶段构建

每个阶段之间空一行。`FROM` 前声明本阶段需要的 `ARG IMAGE_MIRROR`。

```dockerfile
# 第一阶段
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}golang:latest AS builder
...

# 最终阶段
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest
```

## apt 镜像源替换

替换 `deb.debian.org` 为 `${APT_REPOSITORY}`，统一写在 `RUN` 块内第一段。

```dockerfile
RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
        sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi
```

## Alpine 镜像源替换

替换 `dl-cdn.alpinelinux.org` 为 `${ALPINE_MIRROR}`。

```dockerfile
RUN set -eux; \
    if [ -n "${ALPINE_MIRROR:-}" ]; then \
        sed -i "s|https://dl-cdn.alpinelinux.org|${ALPINE_MIRROR}|g" /etc/apk/repositories; \
    fi
```

## npm 镜像源替换

```dockerfile
RUN set -eux; \
    if [ -n "${NPM_MIRROR:-}" ]; then \
        npm config set registry "${NPM_MIRROR}"; \
    fi
```

## apt-get install

统一使用：`DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends`。包名前不写版本号。

```dockerfile
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    ; \
    next_command
```

## BuildKit 缓存挂载

apt 相关操作使用以下缓存挂载：

```dockerfile
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked
```

## hadolint 忽略

忽略规则写在对应 `RUN` 前的注释中：

```dockerfile
# hadolint ignore=DL3008,DL3009
```

## rm -rf 清理列表

```dockerfile
RUN ... \
    rm -rf \
        /usr/share/doc/* \
        /usr/share/man/* \
        /usr/share/info/*
```

## 续行

RUN 指令内的续行基准缩进为 4 空格。

```dockerfile
RUN set -eux; \
    command1; \
    command2
```

### if / then 块

`; then \` 后的代码体额外缩进 2 空格（共 6 空格）。`fi` 回到 4 空格。

```dockerfile
RUN set -eux; \
    if [ -n "${VAR:-}" ]; then \
        sed -i ...; \
    fi; \
    next_command
```

### case / in 块

` in \` 后的分支额外缩进 2 空格（共 6 空格）。`esac` 回到 4 空格。

```dockerfile
RUN set -eux; \
    case "$arch" in \
        amd64) ... ;; \
        arm64) ... ;; \
    esac; \
    next_command
```

### apt-get install 包列表

`apt-get install` 行后的包名额外缩进 2 空格（共 6 空格）。列表以 `;` 结束，回到 4 空格。

```dockerfile
RUN --mount=... \
    --mount=... \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        unzip \
    ; \
    next_command
```

### rm -rf 清理列表

`rm -rf` 行后的路径额外缩进 2 空格（共 6 空格）。列表结束时回到 4 空格。

```dockerfile
RUN ... \
    rm -rf \
        /usr/share/doc/* \
        /usr/share/man/* \
        /usr/share/info/*
```

## 外部工具下载

二进制/源码下载使用 `curl` 或 `wget`，加 `--retry` 参数。版本号通过 `ARG` 声明。

```dockerfile
ARG OSSUTIL_VERSION=2.3.0
RUN set -eux; \
    curl -fsSL --retry 5 --retry-delay 3 --retry-all-errors --connect-timeout 20 \
        -o /tmp/ossutil.zip \
        "https://gosspublic.alicdn.com/ossutil/v2/${OSSUTIL_VERSION}/ossutil-${OSSUTIL_VERSION}-linux-amd64.zip"
```

## 完整示例

参考 `backup-debian/Dockerfile`。
