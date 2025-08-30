

FROM postgres:17-bookworm

# 1. 安装 postgis
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      postgis \
      postgresql-$PG_MAJOR-postgis-3 \
    && rm -rf /var/lib/apt/lists/*

# https://docs.tigerdata.com/self-hosted/latest/install/installation-linux/

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends gnupg postgresql-common apt-transport-https lsb-release wget curl ca-certificates

# RUN set -eux; \
#     curl -fsSL https://packagecloud.io/timescale/timescaledb/gpgkey | gpg --dearmor -o /etc/apt/trusted.gpg.d/timescaledb.gpg; \
#     echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" > /etc/apt/sources.list.d/timescaledb.list; \
#     apt-get update; \
#     # 2) 安装 TimescaleDB（包名包含 PG 主版本号）
#     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#           timescaledb-2-postgresql-$PG_MAJOR ; \
#     rm -rf /var/lib/apt/lists/*

# 统一处理：添加 TimescaleDB 源 + 安装 PostGIS / TimescaleDB
# RUN set -eux; \
#     apt-get update; \
#     # 仅安装构建期需要的工具（保留 ca-certificates 以便 TLS）
#     apt-get install -y --no-install-recommends curl ca-certificates gnupg; \
#     mkdir -p /etc/apt/keyrings; \
#     curl -fsSL https://packagecloud.io/timescale/timescaledb/gpgkey \
#       | gpg --dearmor -o /etc/apt/keyrings/timescaledb.gpg; \
#     echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/timescaledb.gpg] \
# https://packagecloud.io/timescale/timescaledb/debian \
# $(. /etc/os-release && echo $VERSION_CODENAME) main" \
#       > /etc/apt/sources.list.d/timescaledb.list; \
#     apt-get update; \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#       timescaledb-2-postgresql-$PG_MAJOR; \
#     # 可选：移除构建期工具，减小镜像体积（保留 ca-certificates）
#     apt-get purge -y --auto-remove gnupg curl; \
#     rm -rf /var/lib/apt/lists/*

# RUN for f in /var/lib/postgresql/data/postgresql.conf; do \
#       if [ -f "$f" ]; then \
#         sed -ri "s|^#?shared_preload_libraries *=.*|shared_preload_libraries = 'timescaledb'|;" "$f"; \
#       fi; \
#     done

# 4) 初始化脚本：首次启动时为目标数据库创建扩展
# COPY initdb/ /docker-entrypoint-initdb.d/