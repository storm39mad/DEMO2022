resource "vsphere_tag_category" "demoex" {
  name        = "demoex2022"
  cardinality = "SINGLE"
  description = "Managed by Terraform"

  associable_types = [
    "VirtualMachine",
    "Datastore",
    "Networks"
  ]
}

resource "vsphere_tag_category" "os_type" {
  name        = "os_type"
  cardinality = "SINGLE"
  description = "Managed by Terraform"

  associable_types = [
    "VirtualMachine"
  ]
}

resource "vsphere_tag_category" "students" {
  name        = "students"
  cardinality = "SINGLE"
  description = "Managed by Terraform"

  associable_types = [
    "VirtualMachine",
    "Datastore",
    "Networks",
    "ResourcePool",
    "Folder"
  ]
}

##########################

resource "vsphere_tag" "debian11" {
  name        = "debian11"
  category_id = "${vsphere_tag_category.os_type.id}"
  description = "Managed by Terraform"
}

resource "vsphere_tag" "csr1000v" {
  name        = "csr1000v"
  category_id = "${vsphere_tag_category.os_type.id}"
  description = "Managed by Terraform"
}

resource "vsphere_tag" "win10" {
  name        = "win10"
  category_id = "${vsphere_tag_category.os_type.id}"
  description = "Managed by Terraform"
}

resource "vsphere_tag" "winsrv2019" {
  name        = "winsrv2019"
  category_id = "${vsphere_tag_category.os_type.id}"
  description = "Managed by Terraform"
}

##########################

resource "vsphere_tag" "isp" {
  name        = "isp"
  category_id = "${vsphere_tag_category.demoex.id}"
  description = "Managed by Terraform"
}

resource "vsphere_tag" "rtr-l" {
  name        = "rtr-l"
  category_id = "${vsphere_tag_category.demoex.id}"
  description = "Managed by Terraform"
}

resource "vsphere_tag" "rtr-r" {
  name        = "rtr-r"
  category_id = "${vsphere_tag_category.demoex.id}"
  description = "Managed by Terraform"
}

resource "vsphere_tag" "srv" {
  name        = "srv"
  category_id = "${vsphere_tag_category.demoex.id}"
  description = "Managed by Terraform"
}

resource "vsphere_tag" "cli" {
  name        = "cli"
  category_id = "${vsphere_tag_category.demoex.id}"
  description = "Managed by Terraform"
}

resource "vsphere_tag" "web-l" {
  name        = "web-l"
  category_id = "${vsphere_tag_category.demoex.id}"
  description = "Managed by Terraform"
}

resource "vsphere_tag" "web-r" {
  name        = "web-r"
  category_id = "${vsphere_tag_category.demoex.id}"
  description = "Managed by Terraform"
}

##########################

resource "vsphere_tag" "students" {
  count       = var.idx
  name        = "${element(local.students, count.index)}"
  category_id = "${vsphere_tag_category.students.id}"
  description = "Managed by Terraform"
}