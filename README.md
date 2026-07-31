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

This repository includes a Copilot prompt for maintenance in [`.github/prompts/`](.github/prompts/). To run it, open Copilot Chat in VS Code and type `/maintenance`. The prompt updates the Ubuntu base image digest and the pinned APT package versions in the [Dockerfile](./Dockerfile) and prepares a single pull request.

### Ubuntu

Dependabot is configured to do this in [`.github/dependabot.yml`](.github/dependabot.yml), but if you need to get the digest, do the following

```bash
docker pull --platform linux/amd64 public.ecr.aws/ubuntu/ubuntu:26.04

docker image inspect --format='{{ index .RepoDigests 0 }}' public.ecr.aws/ubuntu/ubuntu:26.04
```

### Base APT Packages

To get the latest available versions of the APT packages, run the following

```bash
docker run -it --rm --platform linux/amd64 public.ecr.aws/ubuntu/ubuntu:24.04

apt-get update

apt-cache policy curl gpgv iputils-ping netcat-openbsd traceroute
```
