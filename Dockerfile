#checkov:skip=CKV_DOCKER_2: HEALTHCHECK not required - Health checks are implemented downstream of this image

FROM public.ecr.aws/ubuntu/ubuntu:24.04@sha256:b40d671bf589b6e5eaaceae32d7eb325a69182963519760571161df996d0d62a

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="Analytical Platform (analytical-platform@digital.justice.gov.uk)" \
      org.opencontainers.image.title="Analytical Platform Network Diagnostics" \
      org.opencontainers.image.description="Minimal Ubuntu image with networking diagnostic tools installed" \
      org.opencontainers.image.url="https://github.com/ministryofjustice/analytical-platform-network-diagnostics"


# Install networking diagnostic tools
RUN <<EOF
apt-get update --yes

apt-get install --yes \
  "curl=8.5.0-2ubuntu10.6" \
  "iputils-ping=3:20240117-1ubuntu0.1" \
  "netcat-openbsd=1.226-1ubuntu2"

apt-get clean --yes
EOF
