data "vsphere_datacenter" "dc" {
  name = "DatacenterDELL"
}

data "vsphere_datastore" "ds" {
  name          = "DELLvsanDatastore"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "nfs" {
  name          = "NFS"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "ClusterDELL/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_role" "role" {
  label = "DEMOEX2022"
}

###################################################

