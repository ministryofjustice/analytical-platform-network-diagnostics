---
description: "Update the Ubuntu base image digest and pinned APT package versions in the Dockerfile as a single pull request"
tools: ["search/codebase", "search", "edit/editFiles", "execute/runInTerminal", "execute/getTerminalOutput"]
---

# Maintenance

Perform maintenance on the `Dockerfile`. Update the Ubuntu base image digest and the pinned APT package versions together, and deliver them as a single pull request.

## Objective

In one pull request:

1. Update the pinned digest for `public.ecr.aws/ubuntu/ubuntu:24.04` to the latest published digest for `linux/amd64`.
2. Refresh the pinned APT package versions to the latest available for Ubuntu 24.04, preserving the current package list.

## Required Outcome

1. Create a single maintenance branch.
2. Update the Ubuntu base image digest in the `FROM` line.
3. Update the pinned APT package versions.
4. Prepare one PR-ready change summary covering both updates.

## Execution Steps

1. Create a maintenance branch.

```bash
git checkout -b chore/maintenance-dockerfile-<yyyymmdd>
```

2. Update the Ubuntu base image digest.

- Pull the target image for `linux/amd64`.

```bash
docker pull --platform linux/amd64 public.ecr.aws/ubuntu/ubuntu:24.04
```

- Retrieve the current repo digest.

```bash
docker image inspect --format='{{ index .RepoDigests 0 }}' public.ecr.aws/ubuntu/ubuntu:24.04
```

- Extract the `sha256:...` value and update the `FROM` line in `Dockerfile`.

3. Update the pinned APT package versions.

- Start a temporary Ubuntu 24.04 container using the same base image.

```bash
docker run -it --rm --platform linux/amd64 public.ecr.aws/ubuntu/ubuntu:24.04
```

- In the container, check package candidates.

```bash
apt-get update
apt-cache policy curl gpgv iputils-ping netcat-openbsd traceroute
```

- Update the pinned versions in `Dockerfile` for:

  - `curl`
  - `gpgv`
  - `iputils-ping`
  - `netcat-openbsd`
  - `traceroute`

4. Exit the container.

5. Prepare a single PR summarising both updates:

- Old digest and new digest (confirm tag remains `24.04`).
- Package versions before and after.
- Any package that could not be upgraded and why.

Building and testing the image is handled by CI/CD, so it is not required as part of this runbook.

## Guardrails

- Keep the base image repository and tag unchanged (`public.ecr.aws/ubuntu/ubuntu:24.04`).
- Keep platform assumption aligned to `linux/amd64`.
- Do not add or remove packages unless explicitly requested.
- Keep all package installs pinned to explicit versions.
- Deliver both updates in the same branch and pull request.
