variable "lb_prefix" {}
variable "location" {}
variable "resource_group" {}
variable "network_interface_id" {}
variable "vm_size" {}
variable "subnet_id" {}
variable "networkInterface"{}



resource "azurerm_public_ip" "main-lbip" {
  name                = "${var.lb_prefix}-pip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  allocation_method   = "Static"
}

resource "azurerm_lb" "tierlb" {
  name                = "${var.lb_prefix}-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.main-lbip.id}"
  }
}

# Back End Address Pool
resource "azurerm_lb_backend_address_pool" "tierBpool" {
  //location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${var.resource_group}"
  loadbalancer_id     = "${azurerm_lb.tierlb.id}"
  name                = "BackEndAddressPool"
}

# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "lbIPassociation" {
#   backend_address_pool_id = azurerm_lb_backend_address_pool.tierBpool.id
#   ip_configuration_name = "TestConfiguration"
#   network_interface_id = var.networkInterface
# }
# Load Balancer Rule
resource "azurerm_lb_rule" "LBRule" {
  resource_group_name            = "${var.resource_group}"
  loadbalancer_id                = "${azurerm_lb.tierlb.id}"
  name                           = "HTTPRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.tierBpool.id}"
  probe_id                       = "${azurerm_lb_probe.tierLBProbe.id}"
  depends_on                     = ["azurerm_lb_probe.tierLBProbe"]
}

resource "azurerm_lb_probe" "tierLBProbe" {
  //location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${var.resource_group}"
  loadbalancer_id     = "${azurerm_lb.tierlb.id}"
  name                = "HTTP"
  port                = 80
}
