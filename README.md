# Homelab

Configuration for tools used to manage my homelab.

> [!IMPORTANT]
> I am no longer actively updating this repository. My homelab is now managed with
> NixOS instead of Kubernetes.
>
> The configuration for this can be found at https://github.com/danmharris/nixfiles

## 🚢 Kubernetes

The majority of services in the homelab are hosted on a single Kubernetes
cluster. This is set up using [Talos](https://www.talos.dev) to provide a secure
and immutable operating environment for the nodes.

The cluster is managed using [Flux](https://fluxcd.io/) to perform GitOps from
the `kubernetes` directory of this repository. Any passwords/secrets are encrypted
using [Mozilla SOPS](https://github.com/mozilla/sops), committed to this
repository and then decrypted by Flux.

### Apps

* Authentik: Single Sign-On (SSO)
* Gitea: Hosts git repositories, OCI images and internal packages

### Infrastructure

* Flannel: Container network interface (CNI)
* Cert Manager: Automatically generates TLS certificates for ingress using LetsEncrypt
* k8s_gateway: Delegated DNS server which responds to lookups for services in the cluster
* Nginx: Ingress
* NFS CSI Driver: Automatically provisions persistent volumes on an NFS mount
* PostgreSQL: Databases

## 🏗 Ansible

[Ansible](https://www.ansible.com/) is used to configure anything that isn't
running in the Kubernetes cluster. This includes other physical hosts on the
network. This does common setup like configuring users, automatic updates, etc.
All the playbooks can be found in the `ansible` directory.

## See Also

### dns-config

Contains the DNS configuration for the network. This runs as a docker compose
stack on a Raspberry Pi 4.

Source: [dns-config](https://github.com/danmharris/dns-config)
