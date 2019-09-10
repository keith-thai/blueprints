variable "operations_rg" {} 

variable "core_rg" {}

variable "location" {}

variable "vnet_name" {}

variable "security_groups" {type = "map"}

variable "subnets" {type = "map"}


resource "azurerm_network_security_group" "sg" {
  for_each            = var.security_groups
  
  name                = "${each.value}"
  location            = var.location
  resource_group_name = var.core_rg
}

resource "azurerm_network_security_rule" "mgmnt-in" {
  for_each                    = var.security_groups

  name                        = "mgmnt-in"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "22"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.4.0/24"
  destination_address_prefix  = "*"

  resource_group_name         = "${var.core_rg}"
  network_security_group_name = "${each.value}"
}

locals { 
  sg_map = {
    for group in keys(azurerm_network_security_group.sg):
      group => azurerm_network_security_group.sg[group].id
  }  
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.core_rg
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = var.subnets["sn1"]
    address_prefix = "10.0.1.0/24"
    security_group = local.sg_map["web"]
  }

  subnet {
    name           = var.subnets["sn2"]
    address_prefix = "10.0.2.0/24"
    security_group = local.sg_map["app"]
  }

  subnet {
    name           = var.subnets["sn3"]
    address_prefix = "10.0.3.0/24"
    security_group = local.sg_map["db"]
  }

  subnet {
    name           = var.subnets["sn4"]
    address_prefix = "10.0.4.0/24"
    #security_group = local.sg_map["mgmt"]
  }

  tags = {
    environment = "DEV"
  }
}

output "sg_map" {
  depends_on = [azurerm_network_security_group.sg]
  value = {
    for group in keys(azurerm_network_security_group.sg):
     group => azurerm_network_security_group.sg[group].id
}
}

output "vnet" {
  value = azurerm_virtual_network.vnet.name
}
