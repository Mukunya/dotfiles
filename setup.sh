#!/usr/bin/env bash
cd "$(dirname "$0")"
./setup/preflight-arch.sh
stow dotfiles
./setup/post-arch.sh
