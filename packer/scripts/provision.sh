#!/usr/bin/env bash
set -xeuo pipefail

apt-get update && apt-get install -y \
    cloud-init

sed -i 's/name: debian/name: dnhrrs/' /etc/cloud/cloud.cfg
echo 'datasource_list: [ NoCloud, ConfigDrive ]' > /etc/cloud/cloud.cfg.d/99_pve.cfg
systemctl enable cloud-init

passwd -l packer
