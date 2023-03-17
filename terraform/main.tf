locals {
  rules_map        = yamldecode(var.yaml_content)
  team_config_map  = yamldecode(var.team_config_content)
  priority_start   = lookup(local.team_config_map, local.rules_map.team)[0]
  priority_end     = lookup(local.team_config_map, local.rules_map.team)[1]
  default_priority = local.priority_end
}

output "rules_map" {
  value = local.team_config_map
}

resource "google_compute_firewall" "firewall_rule" {
  for_each = { for rule in local.rules_map.rules : rule.name => rule }
  project  = var.project_id
  network  = var.vpc_network_name
  name     = each.value.name
  dynamic "allow" {
    for_each = each.value.action == "allow" ? [1] : []
    content {
      protocol = lookup(each.value, "protocol")
      ports    = lookup(each.value, "ports")
    }
  }
  dynamic "deny" {
    for_each = each.value.action == "deny" ? [1] : []
    content {
      protocol = lookup(each.value, "protocol")
      ports    = lookup(each.value, "ports")
    }
  }
  source_ranges           = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.ranges : null
  source_service_accounts = lookup(each.value, "source_service_accounts", null)
  source_tags             = lookup(each.value, "source_tags", null)
  target_service_accounts = lookup(each.value, "target_service_accounts", null)
  target_tags             = lookup(each.value, "target_tags", null)
  priority                = try(each.value.priority, local.default_priority)
}
