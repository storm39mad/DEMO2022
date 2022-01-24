terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
    vsphere = {
        source = "hashicorp/vsphere"
    }
  }
}

variable "nsxt_password" {
  type = string
}

provider "nsxt" {
  host                  = "172.30.77.57"
  username              = "admin"
  password              = var.nsxt_password
  allow_unverified_ssl  = true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}

variable "vsphere_user" {
  type = string
  default = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_server" {
  type = string
  default = "vcsacluster.ouiit.local"
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  # If you have a self-signed cert
  allow_unverified_ssl = true
}