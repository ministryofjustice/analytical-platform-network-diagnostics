# Analytical Platform Network Diagnostics

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/analytical-platform-network-diagnostics/badge)](https://github-community.service.justice.gov.uk/repository-standards/analytical-platform-network-diagnostics)

[![Open in Dev Container](https://raw.githubusercontent.com/ministryofjustice/.devcontainer/refs/heads/main/contrib/badge.svg)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/ministryofjustice/analytical-platform-network-diagnostics)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ministryofjustice/analytical-platform-network-diagnostics)

This repository contains the code for building a minimal network diagnostics image for use in the Analytical Platform Kubernetes clusters. This image can be used across the Ministry of Justice and beyond however!

## Running Locally

### Build

```bash
make build
```

### Test

```bash
make test
```

### Run

```bash
make run
```

## Managing Software Versions

### Ubuntu

Dependabot is configured to do this in [`.github/dependabot.yml`](.github/dependabot.yml), but if you need to get the digest, do the following

```bash
docker pull --platform linux/amd64 public.ecr.aws/ubuntu/ubuntu:24.04

docker image inspect --format='{{ index .RepoDigests 0 }}' public.ecr.aws/ubuntu/ubuntu:24.04
```

### Base APT Packages

The latest versions of the APT packages are managed by [Renovate](https://docs.renovatebot.com/) via the [Renovate `deb` data source](https://docs.renovatebot.com/modules/datasource/deb/) which matches packages through `regex` (regular expression) matching the `# renovate` comments in the [Dockerfile](./Dockerfile).
The [Renovate config](./.github/renovate.json) also disables organisation-level settings for Renovate, so it can compliment rather than conflict with Dependabot.

If you need to manually get latest versions of the APT packages, they can be obtained by running the following

```bash
docker run -it --rm --platform linux/amd64 public.ecr.aws/ubuntu/ubuntu:24.04

apt-get update

apt-cache policy curl iputils-ping netcat-openbsd
```
