data "azurerm_resources" "agent_networks_prd_global" {
  type = "Microsoft.Network/virtualNetworks"
  required_tags = {
    A_PROJECT     = "DEV"
    A_ENVIRONMENT = "PRD"
  }
}

data "azurerm_resources" "agent_networks_int_global" {
  type = "Microsoft.Network/virtualNetworks"
  required_tags = {
    A_PROJECT     = "DEV"
    A_ENVIRONMENT = "INT"
  }
}

data "azurerm_virtual_network" "agent_networks_global" {
  for_each = { for v in concat(local.vnet_prd_global, local.vnet_int_global) : v.id => v }

  name                = each.value.name
  resource_group_name = split("/", each.value.id)[4]
}

data "azurerm_subnet" "agents_global" {
  for_each = merge([for v in data.azurerm_virtual_network.agent_networks_global : { for s in v.subnets : "${v.name}.${s}" => {
    name                = s,
    resource_group_name = v.resource_group_name,
    vnet_name           = v.name
  } }]...)

  name                 = each.value.name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

locals {
  agents_subnets_id_global = [for k, v in data.azurerm_subnet.agents_global : v.id]
  vnet_prd_global          = flatten(data.azurerm_resources.agent_networks_prd_global[*].resources)
  vnet_int_global          = flatten(data.azurerm_resources.agent_networks_int_global[*].resources)
}
