variable "sql_server_name" {}
variable "sql_db_name" {}
variable "location" {}
variable "resource_group" {}



resource "azurerm_sql_server" "test" {
  name                         = "${var.sql_server_name}"
  resource_group_name          = "${var.resource_group}"
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "test" {
  name                = "${var.sql_server_name}"
  resource_group_name = "${var.resource_group}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.test.name}"

  tags = {
    environment = "Dev"
  }
}