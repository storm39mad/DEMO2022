data "nsxt_policy_transport_zone" "overlay_tz" {
    display_name = "NSX-OV"
}

data "nsxt_policy_ip_discovery_profile" "ipd_profile" {
  display_name = "allow-dhcp-ipdiscover"
}

data "nsxt_policy_segment_security_profile" "ssec_profile" {
  display_name = "allow-dhcp-security"
}

resource "nsxt_policy_segment" "tf_isp_cli" {
    count               = var.idx
    display_name        = format("TF_ISP_CLI_%s", count.index)
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    security_profile {
        security_profile_path      = data.nsxt_policy_segment_security_profile.ssec_profile.path
    }
    discovery_profile {
        ip_discovery_profile_path  = data.nsxt_policy_ip_discovery_profile.ipd_profile.path
    }
}

resource "nsxt_policy_segment" "tf_isp_rtrl" {
    count               = var.idx
    display_name        = format("TF_ISP_RTR-L_%s", count.index)
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    security_profile {
        security_profile_path      = data.nsxt_policy_segment_security_profile.ssec_profile.path
    }
    discovery_profile {
        ip_discovery_profile_path  = data.nsxt_policy_ip_discovery_profile.ipd_profile.path
    }
}

resource "nsxt_policy_segment" "tf_isp_rtrr" {
    count               = var.idx
    display_name        = format("TF_ISP_RTR-R_%s", count.index)
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    security_profile {
        security_profile_path      = data.nsxt_policy_segment_security_profile.ssec_profile.path
    }
    discovery_profile {
        ip_discovery_profile_path  = data.nsxt_policy_ip_discovery_profile.ipd_profile.path
    }
}

resource "nsxt_policy_segment" "tf_rtrl" {
    count               = var.idx
    display_name        = format("TF_RTR-L_%s", count.index)
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    security_profile {
        security_profile_path      = data.nsxt_policy_segment_security_profile.ssec_profile.path
    }
    discovery_profile {
        ip_discovery_profile_path  = data.nsxt_policy_ip_discovery_profile.ipd_profile.path
    }
}

resource "nsxt_policy_segment" "tf_rtrr" {
    count               = var.idx
    display_name        = format("TF_RTR-R_%s", count.index)
    transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
    security_profile {
        security_profile_path      = data.nsxt_policy_segment_security_profile.ssec_profile.path
    }
    discovery_profile {
        ip_discovery_profile_path  = data.nsxt_policy_ip_discovery_profile.ipd_profile.path
    }
}