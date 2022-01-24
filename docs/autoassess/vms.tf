resource "vsphere_resource_pool" "tf_pool" {
  count                   = var.idx
  name                    = format("${var.prefix}DEMO2022-C%s", count.index)
  parent_resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  tags = ["${vsphere_tag.students[count.index].id}"]
}

resource "vsphere_folder" "folder" {
  count         = var.idx
  path          = format("${var.prefix}DEMO2022-C%s", count.index)
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
  tags = ["${vsphere_tag.students[count.index].id}"]
}

######

resource "vsphere_entity_permissions" "perms" {
  count       = var.idx
  entity_id   = vsphere_resource_pool.tf_pool[count.index].id
  entity_type = "ResourcePool"
  permissions {
    user_or_group = "${var.domain}\\${element(local.students, count.index)}"
    propagate = true
    is_group = false
    role_id = data.vsphere_role.role.id
  }
}

###################################################

data "vsphere_virtual_machine" "debian_template" {
  name          = "debian11-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "winsrv_template" {
  name          = "winsrv2019-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "win10_template" {
  name          = "win10-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "csr1000v_template" {
  name          = "csr1000v-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

###################################################

resource "vsphere_virtual_machine" "isp" {

    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_isp_cli,
      data.vsphere_network.network_isp_rtrl,
      data.vsphere_network.network_isp_rtrr
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-ISP-%s", count.index)
    folder           = vsphere_folder.folder[count.index].path
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.debian_template.guest_id
    scsi_type = data.vsphere_virtual_machine.debian_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_isp_cli[count.index].id
        adapter_type = data.vsphere_virtual_machine.debian_template.network_interface_types[0]
    }

    network_interface {
        network_id   = data.vsphere_network.network_isp_rtrl[count.index].id
        adapter_type = data.vsphere_virtual_machine.debian_template.network_interface_types[0]
    }

    network_interface {
        network_id   = data.vsphere_network.network_isp_rtrr[count.index].id
        adapter_type = data.vsphere_virtual_machine.debian_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.debian_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.debian_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.debian_template.disks.0.thin_provisioned
    }

    cdrom {
        datastore_id = "${data.vsphere_datastore.nfs.id}"
        path         = "demoex/debian-11.2.0-amd64-BD-1.iso"
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.debian_template.id
    }

    lifecycle {
      ignore_changes = [ cdrom, disk ]
    }

    tags = ["${vsphere_tag.debian11.id}", "${vsphere_tag.isp.id}", "${vsphere_tag.students[count.index].id}"]
}

############################################################################################

resource "vsphere_virtual_machine" "cli" {

    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_isp_cli
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-CLI-%s", count.index)
    folder           = vsphere_folder.folder[count.index].path
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    firmware = "efi"
    guest_id = data.vsphere_virtual_machine.win10_template.guest_id
    scsi_type = data.vsphere_virtual_machine.win10_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_isp_cli[count.index].id
        adapter_type = data.vsphere_virtual_machine.win10_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.win10_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.win10_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.win10_template.disks.0.thin_provisioned
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.win10_template.id
    }

    lifecycle {
      ignore_changes = [ cdrom, disk ]
    }

    tags = ["${vsphere_tag.win10.id}", "${vsphere_tag.cli.id}", "${vsphere_tag.students[count.index].id}"]
}

############################################################################################

resource "vsphere_virtual_machine" "rtrl" {

    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_isp_rtrl
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-RTR-L-%s", count.index)
    folder           = vsphere_folder.folder[count.index].path
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.csr1000v_template.guest_id
    scsi_type = data.vsphere_virtual_machine.csr1000v_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_isp_rtrl[count.index].id
        adapter_type = data.vsphere_virtual_machine.csr1000v_template.network_interface_types[0]
    }

    network_interface {
        network_id   = data.vsphere_network.network_rtrl[count.index].id
        adapter_type = data.vsphere_virtual_machine.csr1000v_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.csr1000v_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.csr1000v_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.csr1000v_template.disks.0.thin_provisioned
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.csr1000v_template.id
    }

    lifecycle {
      ignore_changes = [ cdrom, disk ]
    }

    tags = ["${vsphere_tag.csr1000v.id}", "${vsphere_tag.rtr-l.id}", "${vsphere_tag.students[count.index].id}"]
}

############################################################################################

resource "vsphere_virtual_machine" "rtrr" {

    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_isp_rtrr
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-RTR-R-%s", count.index)
    folder           = vsphere_folder.folder[count.index].path
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 8192
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.csr1000v_template.guest_id
    scsi_type = data.vsphere_virtual_machine.csr1000v_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_isp_rtrr[count.index].id
        adapter_type = data.vsphere_virtual_machine.csr1000v_template.network_interface_types[0]
    }

    network_interface {
        network_id   = data.vsphere_network.network_rtrr[count.index].id
        adapter_type = data.vsphere_virtual_machine.csr1000v_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.csr1000v_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.csr1000v_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.csr1000v_template.disks.0.thin_provisioned
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.csr1000v_template.id
    }

    lifecycle {
      ignore_changes = [ cdrom, disk ]
    }

    tags = ["${vsphere_tag.csr1000v.id}", "${vsphere_tag.rtr-r.id}", "${vsphere_tag.students[count.index].id}"]
}

############################################################################################

resource "vsphere_virtual_machine" "webl" {
    
    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_rtrl
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-WEB-L-%s", count.index)
    folder           = vsphere_folder.folder[count.index].path
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.debian_template.guest_id
    scsi_type = data.vsphere_virtual_machine.debian_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_rtrl[count.index].id
        adapter_type = data.vsphere_virtual_machine.debian_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.debian_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.debian_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.debian_template.disks.0.thin_provisioned
    }

    cdrom {
        datastore_id = "${data.vsphere_datastore.nfs.id}"
        path         = "demoex/debian-11.2.0-amd64-BD-1.iso"
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.debian_template.id
    }

    lifecycle {
      ignore_changes = [ cdrom, disk ]
    }

    tags = ["${vsphere_tag.debian11.id}", "${vsphere_tag.web-l.id}", "${vsphere_tag.students[count.index].id}"]
}

############################################################################################

resource "vsphere_virtual_machine" "webr" {
    
    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_rtrr
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-WEB-R-%s", count.index)
    folder           = vsphere_folder.folder[count.index].path
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    #firmware = "efi"
    guest_id = data.vsphere_virtual_machine.debian_template.guest_id
    scsi_type = data.vsphere_virtual_machine.debian_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_rtrr[count.index].id
        adapter_type = data.vsphere_virtual_machine.debian_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        size             = data.vsphere_virtual_machine.debian_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.debian_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.debian_template.disks.0.thin_provisioned
    }

    cdrom {
        datastore_id = "${data.vsphere_datastore.nfs.id}"
        path         = "demoex/debian-11.2.0-amd64-BD-1.iso"
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.debian_template.id
    }

    lifecycle {
      ignore_changes = [ cdrom, disk ]
    }

    tags = ["${vsphere_tag.debian11.id}", "${vsphere_tag.web-r.id}", "${vsphere_tag.students[count.index].id}"]
}

############################################################################################

resource "vsphere_virtual_machine" "srv" {
    
    depends_on = [
      vsphere_resource_pool.tf_pool,
      data.vsphere_network.network_rtrl
    ]

    wait_for_guest_ip_timeout = -1
    wait_for_guest_net_timeout = -1

    count            = var.idx
    name             = format("TF-SRV-%s", count.index)
    folder           = vsphere_folder.folder[count.index].path
    resource_pool_id = vsphere_resource_pool.tf_pool[count.index].id
    datastore_id     = data.vsphere_datastore.ds.id

    num_cpus = 4
    memory   = 4096
    firmware = "efi"
    guest_id = data.vsphere_virtual_machine.winsrv_template.guest_id
    scsi_type = data.vsphere_virtual_machine.winsrv_template.scsi_type

    network_interface {
        network_id   = data.vsphere_network.network_rtrl[count.index].id
        adapter_type = data.vsphere_virtual_machine.winsrv_template.network_interface_types[0]
    }

    disk {
        label            = "disk0"
        unit_number      = 0
        size             = data.vsphere_virtual_machine.winsrv_template.disks.0.size
        eagerly_scrub    = data.vsphere_virtual_machine.winsrv_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.winsrv_template.disks.0.thin_provisioned
    }

    disk {
        label            = "disk1"
        unit_number      = 1
        size             = "2"
        eagerly_scrub    = data.vsphere_virtual_machine.winsrv_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.winsrv_template.disks.0.thin_provisioned
    }

    disk {
        label            = "disk3"
        unit_number      = 2
        size             = "2"
        eagerly_scrub    = data.vsphere_virtual_machine.winsrv_template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.winsrv_template.disks.0.thin_provisioned
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.winsrv_template.id
    }

    lifecycle {
      ignore_changes = [ cdrom, disk ]
    }

    tags = ["${vsphere_tag.winsrv2019.id}", "${vsphere_tag.srv.id}", "${vsphere_tag.students[count.index].id}"]
}
