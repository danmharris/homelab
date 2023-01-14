# Homelab

Configuration for tools used to manage my homelab.

## 🚢 Kubernetes

The majority of services in the homelab are hosted on a single Kubernetes
cluster. This is set up using [Talos](https://www.talos.dev) to provide a secure
and immutable operating environment for the nodes.

The cluster is managed using [Flux](https://fluxcd.io/) to perform GitOps from
the `flux` directory of this repository. Any passwords/secrets are encrypted
using [Mozilla SOPS](https://github.com/mozilla/sops), committed to this
repository and then decrypted by Flux.

### Apps

* Authentik: Single Sign-On (SSO)
* Gitea: Hosts git repositories, OCI images and internal packages
* Grafana: Dashboard and visualisations
* Jellyfin: TV and Movie library and streaming
* Photoprism: Photo management and organisation
* Woodpecker: Continuous Integration and pipelines

### Infrastructure

* Calico: Networking and provides BGP peering for inbound access
* Cert Manager: Automatically generates TLS certificates for ingress using LetsEncrypt
* External DNS: Automatically creates DNS records for ingress
* Nginx: Ingress
* Kube Prometheus Stack: Prometheus and associated exporters for nodes and the cluster
* NFS Subdir External Provisioner: Automatically provisions persistent volumes on an NFS mount
* PostgreSQL: Databases
* Renovate: Checks for updates of running apps and creates GitHub PRs. Runs on a cron.

## 🏗 Ansible

[Ansible](https://www.ansible.com/) is used to configure anything that isn't
running in the Kubernetes cluster. This includes PowerDNS and Unbound for DNS on
the network as well as the NFS server for the cluster. It also creates and
manages all Proxmox virtual machines.

All the playbooks can be found in the `ansible` directory.

## 📦 Packer

[Packer](https://www.packer.io) is used to create VM templates that can be used
as a base for VMs. I use it to bootstrap a minimal Debian install (using
[preseeding](https://www.debian.org/releases/stable/amd64/apb)) to get it into
a state ready to be managed by other tools.

The image templates can be found in the `packer` directory.

## 🚧 Terraform

⚠ Most resources are in the process of being migrated to Ansible.

[Terraform](https://terraform.io) is an infrastructure as code tool that manages
the main resources in the lab (e.g. VMs, DNS records etc.).

The modules and roots can be found in the `terraform` directory.
