variable "proxmox_url" {
    type = string
}
variable "proxmox_username" {
    type = string
}
variable "proxmox_password" {
    type = string
}
variable "proxmox_node" {
    type = string
}

source "proxmox-iso" "proxmox" {
    proxmox_url = var.proxmox_url
    insecure_skip_tls_verify = true
    username = var.proxmox_username
    password = var.proxmox_password

    node = var.proxmox_node
    memory = 1024
    os = "l26"
    qemu_agent = true
    cloud_init = true
    cloud_init_storage_pool = "local-lvm"
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        vlan_tag = "20"
        firewall = true
    }
    disks {
        type = "scsi"
        disk_size = "10G"
        storage_pool = "local-lvm"
        storage_pool_type = "lvm-thin"
        format = "raw"
    }

    unmount_iso = true
    http_directory = "http"
    boot_wait = "10s"
    boot_command = [
        "<esc><wait>",
        "auto <wait>",
        "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
        "<enter><wait>",
    ]

    ssh_username = "packer"
    ssh_password = "packer"
    ssh_timeout  = "15m"
}

build {
    name = "debian"

    source "proxmox-iso.proxmox" {
        name = "buster"

        iso_file = "local:iso/debian-10.9.0-amd64-netinst.iso"
        template_name = "debian10"
        template_description = "Debian 10, generated by Packer"
        vm_id = 1000
    }

    source "proxmox-iso.proxmox" {
        name = "bullseye"

        iso_file = "local:iso/debian-11.0.0-amd64-netinst.iso"
        template_name = "debian11"
        template_description = "Debian 11, generated by Packer"
        vm_id = 1001
    }

    provisioner "shell" {
        script = "scripts/provision.sh"
        execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    }
}
