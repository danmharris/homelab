#!/usr/bin/env bash
set -xeuo pipefail

apt-get update && apt-get install -y \
    cloud-init

sed -i 's/name: debian/name: dnhrrs/' /etc/cloud/cloud.cfg
echo 'datasource_list: [ NoCloud, ConfigDrive ]' > /etc/cloud/cloud.cfg.d/99_pve.cfg
systemctl enable cloud-init

groupadd -g 5000 ansible
useradd -r -m -d /var/lib/ansible/ -u 5000 -g ansible ansible
mkdir /var/lib/ansible/.ssh/
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRLUzMqpXJdtlTFiyosSOcjZxVqvd1g1E4fNEkjPTjH ansible' > /var/lib/ansible/.ssh/authorized_keys
chmod 0700 /var/lib/ansible/.ssh/
chmod 0600 /var/lib/ansible/.ssh/authorized_keys
chown -R ansible:ansible /var/lib/ansible/.ssh/
echo 'ansible ALL=(root) NOPASSWD: ALL' > /etc/sudoers.d/ansible

passwd -l packer
