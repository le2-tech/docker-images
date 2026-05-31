ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest

ARG APT_REPOSITORY

# 替换为国内镜像源加速下载
RUN set -eux; \
	if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
	sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
	fi

# 安装 poppler-utils（提供 pdftotext）
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	poppler-utils \
	;
