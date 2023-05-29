ARG UBUNTU_VER=22.04

FROM ghcr.io/by275/base:ubuntu AS prebuilt
FROM ghcr.io/by275/base:ubuntu${UBUNTU_VER} AS base

# 
# BUILD
# 
FROM base AS rclone

ARG RCLONE_TYPE="latest"
ARG DEBIAN_FRONTEND="noninteractive"
ARG APT_MIRROR="archive.ubuntu.com"

RUN \
    echo "**** apt source change for local build ****" && \
    sed -i "s/archive.ubuntu.com/$APT_MIRROR/g" /etc/apt/sources.list && \
    echo "**** add rclone ****" && \
    apt-get update -qq && \
    apt-get install -yq --no-install-recommends \
        unzip && \
    if [ "${RCLONE_TYPE}" = "latest" ]; then \
        rclone_install_script_url="https://rclone.org/install.sh"; \
    elif [ "${RCLONE_TYPE}" = "mod" ]; then \
        rclone_install_script_url="https://raw.githubusercontent.com/wiserain/rclone/mod/install.sh"; fi && \
    curl -fsSL $rclone_install_script_url | bash
    
# environment settings
ENV \
    UMASK=002 \
    RCLONE_CONFIG=/config/rclone.conf \
    KEEP_EMPTY_DIRS=0 \
    DATE_FORMAT="+%4Y/%m/%d %H:%M:%S"

VOLUME /config /.cache /data

ADD entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]
