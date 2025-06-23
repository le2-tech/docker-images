

FROM postgres:latest

# 1. 安装 postgis
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      postgis \
      postgresql-postgis \
    && rm -rf /var/lib/apt/lists/*
