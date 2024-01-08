data "azurerm_resources" "agent_networks_prd_local" {
  type = "Microsoft.Network/virtualNetworks"
  required_tags = {
    A_REGION      = var.disaster_recovery ? "FRANCE" : "EUROPE" # Deprecated - Uses Azure Storage cross-region service endpoints
    A_PROJECT     = "DEV"
    A_ENVIRONMENT = "PRD"
  }
}

data "azurerm_resources" "agent_networks_int_local" {
  type = "Microsoft.Network/virtualNetworks"
  required_tags = {
    A_REGION      = var.disaster_recovery ? "FRANCE" : "EUROPE" # Deprecated - Uses Azure Storage cross-region service endpoints
    A_PROJECT     = "DEV"
    A_ENVIRONMENT = "INT"
  }
}

data "azurerm_virtual_network" "agent_networks_local" {
  for_each = { for v in concat(local.vnet_prd_local, local.vnet_int_local) : v.id => v }

  name                = each.value.name
  resource_group_name = split("/", each.value.id)[4]
}

data "azurerm_subnet" "agents_local" {
  for_each = merge([for v in data.azurerm_virtual_network.agent_networks_local : { for s in v.subnets : "${v.name}.${s}" => {
    name                = s,
    resource_group_name = v.resource_group_name,
    vnet_name           = v.name
  } }]...)

  name                 = each.value.name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

locals {
  agents_subnets_id_local = [for k, v in data.azurerm_subnet.agents_local : v.id]
  vnet_prd_local          = flatten(data.azurerm_resources.agent_networks_prd_local[*].resources)
  vnet_int_local          = flatten(data.azurerm_resources.agent_networks_int_local[*].resources)
}
