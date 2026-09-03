#checkov:skip=CKV_DOCKER_2: HEALTHCHECK not required - Health checks are implemented downstream of this image

FROM public.ecr.aws/ubuntu/ubuntu:26.04@sha256:a8724cce691d74a71c42574d3c7e4ef59977b4c48f274cd8bc075e53339bae82

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="Analytical Platform (analytical-platform@digital.justice.gov.uk)" \
      org.opencontainers.image.title="Analytical Platform Network Diagnostics" \
      org.opencontainers.image.description="Minimal Ubuntu image with networking diagnostic tools installed" \
      org.opencontainers.image.url="https://github.com/ministryofjustice/analytical-platform-network-diagnostics"

ENV CONTAINER_GID="1000" \
    CONTAINER_UID="1000" \
    CONTAINER_USER="analyticalplatform" \
    CONTAINER_GROUP="analyticalplatform"

# User Configuration
RUN <<EOF
userdel --remove --force ubuntu

groupadd \
  --gid ${CONTAINER_GID} \
  ${CONTAINER_GROUP}

useradd \
  --uid ${CONTAINER_UID} \
  --gid ${CONTAINER_GROUP} \
  --create-home \
  --shell /bin/bash \
  ${CONTAINER_USER}
EOF

# Install networking diagnostic tools
RUN <<EOF
apt-get update --yes

apt-get install --yes \
  "curl=8.18.0-1ubuntu2.4" \
  "gpgv=2.4.8-4ubuntu3" \
  "gzip=1.14-1~exp2ubuntu1.1" \
  "iputils-ping=3:20250605-1ubuntu1" \
  "netcat-openbsd=1.234-1" \
  "traceroute=1:2.1.6-1build1" \
  "libc6=2.43-2ubuntu2.3" \
  "libc-bin=2.43-2ubuntu2.3" \
  "libc-gconv-modules-extra=2.43-2ubuntu2.3" \
  "libssl3t64=3.5.5-1ubuntu3.5" \
  "openssl-provider-legacy=3.5.5-1ubuntu3.5"
apt-get clean --yes
EOF

WORKDIR /home/${CONTAINER_USER}
USER ${CONTAINER_UID}:${CONTAINER_GID}
