resource "azurerm_api_management" "this" {
  name                 = var.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  sku_name             = join("_", [var.sku, format("%d", var.capacity)])
  virtual_network_type = var.virtual_network_type
  dynamic "virtual_network_configuration" {
    for_each = var.virtual_network_type == "External" || var.virtual_network_type == "Internal" ? [0] : []
    content {
      subnet_id = var.subnet_id
    }
  }
  identity {
    type         = length(var.identity_ids) == 0 ? "SystemAssigned" : "UserAssigned"
    identity_ids = var.identity_ids
  }
  tags = merge(
    var.additional_tags,
    {
      created-by = "iac-tf"
    },
  )
}

# resource "azurerm_private_dns_a_record" "this" {
#   name                = var.name
#   zone_name           = var.private_dns_info.zone_name
#   resource_group_name = var.private_dns_info.resource_group_name
#   ttl                 = 30
#   records             = azurerm_api_management.this.private_ip_addresses
# }

# resource "azurerm_key_vault_access_policy" "this" {
#   key_vault_id = var.key_vault_id
#   tenant_id    = azurerm_api_management.this.identity[0].tenant_id
#   object_id    = azurerm_api_management.this.identity[0].principal_id

#   certificate_permissions = [
#     "Get", "GetIssuers", "List", "ListIssuers"
#   ]

#   key_permissions = [
#     "Get", "List"
#   ]

#   secret_permissions = [
#     "Get", "List"
#   ]

#   storage_permissions = [
#     "Get", "List"
#   ]
# }

# resource "azurerm_api_management_custom_domain" "this" {
#   depends_on        = [azurerm_key_vault_access_policy.this]
#   api_management_id = azurerm_api_management.this.id
#   proxy {
#     host_name    = "apim.${var.private_dns_info.zone_name}"
#     key_vault_id = var.secret_id
#   }
# }

# # https://docs.microsoft.com/de-de/azure/azure-monitor/essentials/resource-manager-diagnostic-settings
# resource "azurerm_monitor_diagnostic_setting" "this_eventhub" {
#   count                          = var.elk_eventhub_name != null ? 1 : 0
#   name                           = "logs-2-eh"
#   target_resource_id             = azurerm_api_management.this.id
#   eventhub_name                  = var.elk_eventhub_name
#   eventhub_authorization_rule_id = var.elk_eventhub_namespace_auth_rule_id

#   log {
#     category = "GatewayLogs"
#     enabled  = true

#     retention_policy {
#       enabled = true
#     }
#   }

#   metric {
#     category = "AllMetrics"
#     enabled  = true

#     retention_policy {
#       enabled = true
#     }
#   }
# }

# resource "azurerm_monitor_diagnostic_setting" "this_law" {
#   count                      = var.log_analytics_workspace_id != null ? 1 : 0
#   name                       = "logs-2-law"
#   target_resource_id         = azurerm_api_management.this.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   log {
#     category = "GatewayLogs"
#     enabled  = true

#     retention_policy {
#       enabled = true
#     }
#   }

#   log {
#     category = "WebSocketConnectionLogs"
#     enabled  = true

#     retention_policy {
#       enabled = true
#     }
#   }
# }

