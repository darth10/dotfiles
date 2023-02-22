#!/bin/bash
set -xeuo pipefail

# Install Lima.
sudo pamac install --no-confirm \
    lima-bin docker-cli-bin qemu-desktop virt-manager \
    qemu-system-aarch64 qemu-system-arm
sudo systemctl start libvirtd
limactl completion zsh | sudo tee /usr/share/zsh/site-functions/_limactl
