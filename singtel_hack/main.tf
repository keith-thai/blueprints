
data "azurerm_client_config" "current" {
}

provider "azurerm" {
  version = "<= 1.33.1"
}

provider "azuread" {
    version = "<=0.6.0"
}

terraform {
    backend "azurerm" {
    }
}
module "network_infra" {
    source                    = "./network_infra"
    vnet_name                 = var.vnet_name
    subnets                   = var.subnets
    security_groups           = var.security_groups
    core_rg                   = module.resource_group_hub.names["HUB-CORE-SEC"]
    operations_rg             = module.resource_group_hub.names["HUB-OPERATIONS"]
    location                  = var.location_map["region1"]
    tags                      = var.tags_resources
}

module "workload_infra" {
    source                    = "./workload_infra"
    vnet_name                 = var.vnet_name
    sg_map                    = module.network_infra.sg_map
    security_groups           = var.security_groups
    resource_group            = module.resource_group_hub.names["HUB-CORE-SEC"]
    location                  = var.location_map["region1"]
    tags                      = var.tags_resources
}