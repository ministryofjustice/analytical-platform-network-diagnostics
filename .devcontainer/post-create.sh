#!/usr/bin/env bash

set -euo pipefail

sudo apt-get update
sudo apt-get install --yes bubblewrap socat

# Install agent package manager dependencies.
apm install --frozen