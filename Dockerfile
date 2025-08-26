#checkov:skip=CKV_DOCKER_2: HEALTHCHECK not required - Health checks are implemented downstream of this image

FROM public.ecr.aws/ubuntu/ubuntu:25.04@sha256:7963d02ff1eb1151aaa61e34a13275d87f15ad477d2240b5dc380026728eb003

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
  "curl=8.5.0-2ubuntu10.6" \
  "iputils-ping=3:20240117-1ubuntu0.1" \
  "netcat-openbsd=1.226-1ubuntu2"

apt-get clean --yes
EOF

WORKDIR /home/${CONTAINER_USER}
USER ${CONTAINER_UID}:${CONTAINER_GID}
