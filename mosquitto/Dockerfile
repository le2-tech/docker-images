# syntax=docker/dockerfile:1
FROM debian:trixie AS build

ENV MOSQUITTO_VERSION=2.1.2
ENV MOSQUITTO_DOWNLOAD_SHA256=fd905380691ac65ea5a93779e8214941829e3d6e038d5edff9eac5fd74cbed02

ARG APP_ENV=prod

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
	--mount=type=cache,target=/var/lib/apt,sharing=locked \
	set -eux; \
	if [ "${APP_ENV:-}" = "dev" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
		sed -i "s|http://deb.debian.org|http://mirrors.aliyun.com|g" /etc/apt/sources.list.d/debian.sources; \
	fi; \
	rm -f /etc/apt/apt.conf.d/docker-clean; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		build-essential \
		ca-certificates \
		libargon2-dev \
		libcjson-dev \
		libedit-dev \
		libmicrohttpd-dev \
		libsqlite3-dev \
		libssl-dev \
		libwebsockets-dev \
		wget \
	;

RUN set -eux; \
	wget "https://mosquitto.org/files/source/mosquitto-${MOSQUITTO_VERSION}.tar.gz" -O /tmp/mosq.tar.gz; \
	echo "${MOSQUITTO_DOWNLOAD_SHA256}  /tmp/mosq.tar.gz" | sha256sum -c -; \
	mkdir -p /build/mosq; \
	tar --strip=1 -xf /tmp/mosq.tar.gz -C /build/mosq; \
	rm /tmp/mosq.tar.gz

RUN set -eux; \
	mkdir -p /opt/mosquitto/share/mosquitto; \
	make -C /build/mosq -j"$(nproc)" \
		WITH_ADNS=no \
		WITH_DOCS=no \
		WITH_SHARED_LIBRARIES=yes \
		WITH_SRV=no \
		WITH_STRIP=yes \
		WITH_WEBSOCKETS=yes \
		CFLAGS="-Wall -O2 -I/build -DHTTP_API_DIR=\\\"/opt/mosquitto/share/mosquitto/dashboard\\\"" \
		prefix=/opt/mosquitto \
		install \
	; \
	cp -r /build/mosq/dashboard/src /opt/mosquitto/share/mosquitto/dashboard

FROM debian:trixie AS runtime

ARG APP_ENV=prod

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
	--mount=type=cache,target=/var/lib/apt,sharing=locked \
	set -eux; \
	if [ "${APP_ENV:-}" = "dev" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
		sed -i "s|http://deb.debian.org|http://mirrors.aliyun.com|g" /etc/apt/sources.list.d/debian.sources; \
	fi; \
	rm -f /etc/apt/apt.conf.d/docker-clean; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		ca-certificates \
		tzdata \
		libargon2-1 \
		libcjson1 \
		libedit2 \
		libmicrohttpd12t64 \
		libsqlite3-0 \
		libssl3t64 \
		libwebsockets19t64

RUN set -eux; \
	getent group mosquitto >/dev/null || groupadd -r -g 1883 mosquitto; \
	id -u mosquitto >/dev/null 2>&1 || useradd -r -u 1883 -g mosquitto -d /var/empty -s /usr/sbin/nologin -c "mosquitto" mosquitto; \
	mkdir -p /app/data /mosquitto/data /mosquitto/log /mosquitto/plugins; \
	chown -R mosquitto:mosquitto /app /mosquitto

ENV PATH=/opt/mosquitto/bin:/opt/mosquitto/sbin:${PATH}
ENV LD_LIBRARY_PATH=/opt/mosquitto/lib

WORKDIR /mosquitto

COPY --from=build /opt/mosquitto/ /opt/mosquitto/
COPY --chmod=755 entrypoint.sh /docker-entrypoint.sh

USER 1883:1883

VOLUME ["/mosquitto/data", "/mosquitto/log"]

EXPOSE 1883

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
