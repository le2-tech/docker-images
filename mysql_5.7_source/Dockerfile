# 第一阶段：编译和打包MySQL
FROM debian:bookworm-slim as builder

# 设置工作目录
WORKDIR /usr/src/mysql

# 使用 curl 下载 MySQL 源码包
RUN set -eux; \
	apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*; \
	curl -O https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-boost-5.7.44.tar.gz; \
	tar -xzf mysql-boost-5.7.44.tar.gz --strip-components=1 ; \
	rm mysql-boost-5.7.44.tar.gz

RUN apt-get update && apt-get install -y \
	build-essential git \
	bison chrpath cmake debhelper dh-apparmor dpkg-dev libaio-dev libedit-dev libevent-dev libjson-perl liblz4-dev libncurses5-dev libnuma-dev  libssl-dev  libwrap0-dev lsb-release perl pkg-config po-debconf psmisc zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*


RUN \
	CC=gcc \
	CXX=g++ \
	cmake . \
	-DCMAKE_BUILD_TYPE=MinSizeRel \
	-DBUILD_CONFIG=mysql_release \
	-DWITH_BOOST=boost \
	-DWITH_EMBEDDED_SERVER=OFF \
	-DENABLED_LOCAL_INFILE=OFF \
	-DENABLE_DTRACE=OFF \
	-DWITH_SSL=system \
	-DWITH_ZLIB=system \
	-DWITH_LIBWRAP=OFF \
	-DWITH_LZ4=system \
	-DWITH_EDITLINE=system \
	-DWITH_LIBEVENT=system \
	-DINSTALL_LAYOUT=STANDALONE \
	-DWITH_ARCHIVE_STORAGE_ENGINE=ON \
	-DWITH_BLACKHOLE_STORAGE_ENGINE=ON \
	-DWITH_FEDERATED_STORAGE_ENGINE=ON \
	-DWITH_EXTRA_CHARSETS=all \
	-DDEFAULT_CHARSET=utf8mb4 \
	-DDEFAULT_COLLATION=utf8mb4_unicode_ci

# -DWITH_LIBWRAP=ON \
# -DWITH_INNODB_MEMCACHED=1 \

RUN make

RUN make install && rm -fr /usr/local/mysql/mysql-test

#------------

FROM debian:bookworm-slim

# # add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y --no-install-recommends gnupg && rm -rf /var/lib/apt/lists/*

# add gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
# https://github.com/tianon/gosu/blob/master/INSTALL.md
ENV GOSU_VERSION=1.17
RUN set -eux; \
# save list of currently installed packages for later so we can clean up
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates wget; \
	rm -rf /var/lib/apt/lists/*; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
# clean up fetch dependencies
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	\
	chmod +x /usr/local/bin/gosu; \
# verify that the binary works
	gosu --version; \
	gosu nobody true

RUN mkdir /docker-entrypoint-initdb.d

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		bzip2 \
		openssl \
# FATAL ERROR: please install the following Perl modules before executing /usr/local/mysql/scripts/mysql_install_db:
# File::Basename
# File::Copy
# Sys::Hostname
# Data::Dumper
		perl \
		xz-utils \
		zstd \
		# mysqld: error while loading shared libraries: libaio.so.1: cannot open shared object file: No such file or directory
    	libaio-dev \
		libwrap0-dev \
		libedit-dev \
		#  libssl-dev \
		#  mysqld: error while loading shared libraries: libnuma.so.1: cannot open shared object file: No such file or directory
		libnuma-dev \
		krb5-locales \
		libmecab2 \
	; \
	rm -rf /var/lib/apt/lists/*

# RUN set -eux; \
# # pub   rsa4096 2023-10-23 [SC] [expires: 2025-10-22]
# #       BCA4 3417 C3B4 85DD 128E  C6D4 B7B3 B788 A8D3 785C
# # uid           [ unknown] MySQL Release Engineering <mysql-build@oss.oracle.com>
# # sub   rsa4096 2023-10-23 [E] [expires: 2025-10-22]
# 	key='BCA4 3417 C3B4 85DD 128E C6D4 B7B3 B788 A8D3 785C'; \
# 	export GNUPGHOME="$(mktemp -d)"; \
# 	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
# 	mkdir -p /etc/apt/keyrings; \
# 	gpg --batch --export "$key" > /etc/apt/keyrings/mysql.gpg; \
# 	gpgconf --kill all; \
# 	rm -rf "$GNUPGHOME"

ENV MYSQL_MAJOR=5.7
ENV MYSQL_VERSION=5.7.44-0debian12

# 将MySQL的.tar.gz安装包复制到容器中
# COPY mysql-5.7.44-linux-aarch64.tar.gz /usr/local/mysql/
# RUN cp /usr/src/mysql/mysql-5.7.44-linux-aarch64.tar.gz .
WORKDIR /usr/local/mysql/
COPY --from=builder /usr/local/mysql/ /usr/local/mysql/


# 配置环境变量以便能够直接在任何地方运行MySQL命令
ENV PATH=/usr/local/mysql/bin:$PATH

# RUN echo 'deb [ signed-by=/etc/apt/keyrings/mysql.gpg ] http://repo.mysql.com/apt/debian/ bookworm mysql-8.0' > /etc/apt/sources.list.d/mysql.list

# the "/var/lib/mysql" stuff here is because the mysql-server postinst doesn't have an explicit way to disable the mysql_install_db codepath besides having a database already "configured" (ie, stuff in /var/lib/mysql/mysql)
# also, we set debconf keys to make APT a little quieter
RUN rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	&& chmod 1777 /var/run/mysqld /var/lib/mysql

VOLUME /var/lib/mysql

# Config files
COPY config/ /etc/mysql/
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306 33060
CMD ["mysqld"]
