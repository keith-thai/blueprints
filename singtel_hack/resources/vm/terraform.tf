variable "vm_prefix" {}
variable "location" {}
variable "resource_group" {}
variable "network_interface_id" {}
variable "vm_size" {}
variable "subnet_id" {}


resource "azurerm_network_interface" "main" {
  name                          = "${var.vm_prefix}-nic"
  location                      = "${var.location}"
  resource_group_name           = "${var.resource_group}"

  ip_configuration {
    name                          = "TestConfiguration"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.vm_prefix}-vm"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "${var.vm_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk-${var.vm_prefix}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "Dev"
  }
}

output "vm_ids" {
  description = "Virtual machine ids created."
  value       = "${azurerm_virtual_machine.main.id}"
}
output "network_ids" {
  description = "Virtual machine ids created."
  value       = "${azurerm_network_interface.main.id}"
}