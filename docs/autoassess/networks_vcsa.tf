resource "null_resource" "wait" {
  triggers = {
    isp_cli  = length(nsxt_policy_segment.tf_isp_cli),
    isp_rtrl = length(nsxt_policy_segment.tf_isp_rtrl),
    isp_rtrr = length(nsxt_policy_segment.tf_isp_rtrr),
    rtrl     = length(nsxt_policy_segment.tf_rtrl),
    rtrr     = length(nsxt_policy_segment.tf_rtrr)
  }

  provisioner "local-exec" {
      environment = {
        networks = "${
          join(",", concat(nsxt_policy_segment.tf_isp_cli[*].display_name,
                           nsxt_policy_segment.tf_isp_rtrl[*].display_name,
                           nsxt_policy_segment.tf_isp_rtrr[*].display_name,
                           nsxt_policy_segment.tf_rtrl[*].display_name,
                           nsxt_policy_segment.tf_rtrr[*].display_name)
          )
        }"
       }
      command = "pwsh ./helpers/getnets.ps1"
      when = create
  }
}

###################################################

data "vsphere_network" "network_isp_cli" {
    count      = var.idx
    depends_on = [ null_resource.wait ]
    name       = format("${var.prefix}ISP_CLI_%s", count.index)
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_isp_rtrl" {
    depends_on = [ null_resource.wait ]
    count      = var.idx
    name       = format("${var.prefix}ISP_RTR-L_%s", count.index)
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_isp_rtrr" {
    depends_on = [ null_resource.wait ]
    count      = var.idx
    name       = format("${var.prefix}ISP_RTR-R_%s", count.index)
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_rtrl" {
    depends_on = [ null_resource.wait ]
    count      = var.idx
    name       = format("${var.prefix}RTR-L_%s", count.index)
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network_rtrr" {
    depends_on = [ null_resource.wait ]
    count      = var.idx
    name       = format("${var.prefix}RTR-R_%s", count.index)
    datacenter_id = data.vsphere_datacenter.dc.id
}

resource "null_resource" "setperms" {
   triggers = {
     isp_cli  = length(data.vsphere_network.network_isp_cli),
     isp_rtrl = length(data.vsphere_network.network_isp_rtrl),
     isp_rtrr = length(data.vsphere_network.network_isp_rtrr),
     rtrl     = length(data.vsphere_network.network_rtrl),
     rtrr     = length(data.vsphere_network.network_rtrr)
   }
   provisioner "local-exec" {
     command = "pwsh ./helpers/setperms.ps1 -regex '${var.prefix}*_' "
     when = create
   }
}