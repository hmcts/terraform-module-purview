module "logworkspace" {
  #checkov:skip=CKV_TF_1
  #checkov:skip=CKV_TF_2
  source      = "git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env

}

resource "azurerm_monitor_diagnostic_setting" "purview_account" {
  name                       = "${local.name}-${var.env}"
  target_resource_id         = azurerm_purview_account.this.id
  log_analytics_workspace_id = module.logworkspace.workspace_id

  enabled_log {
    category = "ScanStatusLogEvent"
  }

  enabled_log {
    category = "DataSensitivityLogEvent"
  }

  enabled_log {
    category = "Security"
  }

  lifecycle {
    ignore_changes = [
      metric,
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "${local.name}-kv-${var.env}"
  target_resource_id         = module.key_vault.key_vault_id
  log_analytics_workspace_id = module.logworkspace.workspace_id

  # Explicit retention_policy matches Azure API read; omitting it causes perpetual drift each plan.
  enabled_log {
    category = "AuditEvent"
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  lifecycle {
    ignore_changes = [
      metric,
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "network_security_group" {
  name                       = "${local.name}-nsg-${var.env}"
  target_resource_id         = module.networking.network_security_groups_ids["nsg"]
  log_analytics_workspace_id = module.logworkspace.workspace_id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }

  lifecycle {
    ignore_changes = [
      metric,
    ]
  }
}

data "azurerm_network_watcher" "main" {
  count = var.nsg_flow_log_storage_account_id != null ? 1 : 0

  name                = "NetworkWatcher_${replace(lower(var.location), " ", "")}"
  resource_group_name = "NetworkWatcherRG"
}

resource "azurerm_network_watcher_flow_log" "nsg" {
  count = var.nsg_flow_log_storage_account_id != null ? 1 : 0

  network_watcher_name = data.azurerm_network_watcher.main[0].name
  resource_group_name  = data.azurerm_network_watcher.main[0].resource_group_name
  name                 = "${local.name}-nsg-flow-${var.env}"
  location             = var.location
  target_resource_id   = module.networking.network_security_groups_ids["nsg"]
  storage_account_id   = var.nsg_flow_log_storage_account_id
  enabled              = true

  retention_policy {
    enabled = true
    days    = var.nsg_flow_log_retention_days
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.hmcts.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.hmcts.location
    workspace_resource_id = module.logworkspace.workspace_id
    interval_in_minutes   = 10
  }
}
