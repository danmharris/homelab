# Homelab

Configuration for tools used to manage my homelab.

## Tools

### Packer

This allows the creation of VM templates that can be used as a base for VMs. I
use it to bootstrap a minimal Debian install (using
[preseeding](https://www.debian.org/releases/stable/amd64/apb)) to get it into
a state ready to be managed by other tools.

Project link: https://www.packer.io/

### Terraform

This is an infrastructure as code tool that manages the main resources in the
lab (e.g. VMs, DNS records etc.).

Project link: https://terraform.io/
