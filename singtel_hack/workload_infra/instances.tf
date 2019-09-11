variable "vnet_name" {}

variable "security_groups" {type = "map"}

variable "sg_map" {type = "map"}

variable "tags" {type = "map"}

variable "resource_group" {}

variable "location" {}

data "azurerm_subnet" "app" {
  name                 = "app-subnet"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.resource_group}"


}

data "azurerm_subnet" "web" {
  name                 = "web-subnet"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.resource_group}"
}
data "azurerm_subnet" "db" {
  name                 = "db-subnet"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.resource_group}"
}

data "azurerm_subnet" "mgmt" {
  name                 = "mgmt-subnet"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.resource_group}"
}

module "app-vm" {
    source                              = "../resources/vm"
    vm_prefix                           = "app"
    location                            = "${var.location}"
    resource_group                      = "${var.resource_group}"
    network_interface_id                = "${var.location}"
    subnet_id                           = "${data.azurerm_subnet.app.id}"
    vm_size                             = "Standard_DS1_v2"
    tags                                = "${var.tags}"
}

module "web-vm" {
    source                              = "../resources/vm"
    vm_prefix                           = "web"
    location                            = "${var.location}"
    resource_group                      = "${var.resource_group}"
    network_interface_id                = "${var.location}"
    subnet_id                           = "${data.azurerm_subnet.web.id}"  
    vm_size                             = "Standard_DS1_v2"
    tags                                = "${var.tags}"
}

module "mgmt-vm" {
    source                              = "../resources/jumphost"
    vm_prefix                           = "mgmt"
    location                            = "${var.location}"
    resource_group                      = "${var.resource_group}"
    network_interface_id                = "${var.location}"
    subnet_id                           = "${data.azurerm_subnet.mgmt.id}"  
    vm_size                             = "Standard_DS1_v2"
    tags                                = "${var.tags}"
}

module "db-vm" {
    source                              = "../resources/db"
    sql_server_name                     = "sgsqlserver"
    sql_db_name                         = "sgsqldatabase"
    location                            = "${var.location}"
    resource_group                      = "${var.resource_group}"
    tags                                = "${var.tags}"    
}

module "web-lb" {
    source                              = "../resources/lb"
    lb_prefix                           = "lb"
    location                            = "${var.location}"
    resource_group                      = "${var.resource_group}"
    network_interface_id                = "${var.location}"
    subnet_id                           = "${data.azurerm_subnet.web.id}"  
    vm_size                             = "Standard_DS1_v2"
    networkInterface                    = module.web-vm.network_ids
}

