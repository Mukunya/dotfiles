#!/usr/bin/env bash
cd "$(dirname "$0")"
./setup/preflight-arch.sh
stow dotfiles --adopt
./setup/post-arch.sh
