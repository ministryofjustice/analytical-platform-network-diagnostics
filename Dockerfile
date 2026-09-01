#checkov:skip=CKV_DOCKER_2: HEALTHCHECK not required - Health checks are implemented downstream of this image

FROM public.ecr.aws/ubuntu/ubuntu:26.04@sha256:2260313b31c8c011cd2eebe728008efac1b3982be73eb71348ea2648d2c0e09b

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
  "libssl3t64=3.5.5-1ubuntu3.4" \
  "openssl-provider-legacy=3.5.5-1ubuntu3.4"
apt-get clean --yes
EOF

WORKDIR /home/${CONTAINER_USER}
USER ${CONTAINER_UID}:${CONTAINER_GID}
