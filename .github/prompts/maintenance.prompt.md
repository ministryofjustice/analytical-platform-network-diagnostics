---
description: "Update the Ubuntu base image digest and pinned APT package versions in the Dockerfile and open a pull request"
tools: ["search/codebase", "search", "edit/editFiles", "execute/runInTerminal", "execute/getTerminalOutput"]
---

# Maintenance

Perform maintenance on the `Dockerfile`. Update the Ubuntu base image digest and the pinned APT package versions together, and open a single pull request.

## Objective

In one pull request:

1. Update the pinned digest for `public.ecr.aws/ubuntu/ubuntu:24.04` to the latest published digest for `linux/amd64`.
2. Refresh the pinned APT package versions to the latest available for Ubuntu 24.04, preserving the current package list.

## Required Outcome

1. Create a single maintenance branch.
2. Update the Ubuntu base image digest in the `FROM` line.
3. Update the pinned APT package versions.
4. Commit the changes using Conventional Commits.
5. Push the branch and open a pull request with a clear title and description.

## Execution Steps

1. Create a maintenance branch.

```bash
git checkout -b "chore/maintenance-dockerfile-$(date +%Y%m%d-%H%M%S)"
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

5. Commit the change to `Dockerfile` using [Conventional Commits](https://www.conventionalcommits.org/) (`build` type).

6. Push the branch and open the pull request with the GitHub CLI.

- The `git commit`, `git push`, and `gh` steps need the local Git/GitHub credentials and network access. When the terminal is sandboxed these are hidden, so run these steps with the required access (outside the sandbox) rather than stopping. A sandboxed `gh auth status` may report "not logged in" even when the terminal is authenticated; do not treat that as a blocker.
- Set an explicit PR title: a [Conventional Commits](https://www.conventionalcommits.org/) `build:` summary that matches the commit (for example, `build: update ubuntu base image digest and curl package version`). Do not use `gh pr create --fill`, which derives the title from the branch name.
- Write the PR description to a temporary file and pass it with `--body-file` to avoid shell-escaping issues. Use Markdown, for example:

  ```markdown
  ## Summary

  Updates the `Dockerfile` build dependencies.

  ### Ubuntu base image

  - Digest: `<old-sha256>` -> `<new-sha256>` (tag remains `24.04`)

  ### APT packages

  | Package | Before | After |
  | --- | --- | --- |
  | curl | `<old>` | `<new>` |

  Only list packages that changed. Note any that could not be upgraded and why.

  Building and testing is handled by CI/CD.
  ```

- Create the pull request:

  ```bash
  git push -u origin <branch>
  gh pr create --base main --head <branch> --title "<title>" --body-file <body-file>
  ```

- Report the URL of the created pull request.

Building and testing the image is handled by CI/CD, so it is not part of this runbook.

## Guardrails

- Keep the base image repository and tag unchanged (`public.ecr.aws/ubuntu/ubuntu:24.04`).
- Keep platform assumption aligned to `linux/amd64`.
- Do not add or remove packages unless explicitly requested.
- Keep all package installs pinned to explicit versions.
- Deliver both updates in the same branch and pull request.
- Use [Conventional Commits](https://www.conventionalcommits.org/) for both the commit message and the PR title (use the `build` type).
