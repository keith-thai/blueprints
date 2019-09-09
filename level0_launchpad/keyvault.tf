data "azurerm_client_config" "current" {}

resource "random_string" "kv_name" {
  length  = 4
  special = false
  upper   = false
  number  = true
}

resource "random_string" "kv_middle" {
  length  = 1
  special = false
  upper   = false
  number  = false
}

locals {
    kv_name = "${random_string.prefix.result}${random_string.kv_middle.result}${random_string.kv_name.result}"
}


resource "azurerm_key_vault" "tfstate" {
    name                = local.kv_name
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    tenant_id           = data.azurerm_client_config.current.tenant_id

    sku_name = "standard"

    tags = {
      kvtfstate="level0"
    }

    # Must be set as bellow to force the permissions to be re-applied by TF if changed outside of TF (portal, powershell...)
    access_policy {
      tenant_id       = data.azurerm_client_config.current.tenant_id
      object_id       = azuread_service_principal.tfstate.object_id

      key_permissions = []

      secret_permissions = [
          "set",
          "get",
          "list",
          "delete",
      ]
    }

    # Must be set as bellow to force the permissions to be re-applied by TF if changed outside of TF (portal, powershell...)
    access_policy {
      tenant_id       = data.azurerm_client_config.current.tenant_id
      object_id       = azuread_service_principal.devops.object_id

      key_permissions = []

      secret_permissions = [
          "get",
          "list",
      ]
    }

    # Must be set as bellow to force the permissions to be re-applied by TF if changed outside of TF (portal, powershell...)
    access_policy {
      tenant_id       = data.azurerm_client_config.current.tenant_id
      object_id       = azurerm_user_assigned_identity.tfstate.principal_id

      key_permissions = []

      secret_permissions = [
          "get",
      ]
    }

}

# To allow deployment from developer machine
# Todo: add a condition
resource "azurerm_key_vault_access_policy" "developer" {
  key_vault_id = azurerm_key_vault.tfstate.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = var.logged_user_objectId

  key_permissions = []

  secret_permissions = [
    "get",
  ]
}




