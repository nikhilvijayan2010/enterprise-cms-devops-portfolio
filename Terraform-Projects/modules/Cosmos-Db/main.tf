# resource "random_string" "random" {
#   length  = 6
#   special = false
#   upper   = false
# }
## create cosmosdb account
resource "azurerm_cosmosdb_account" "db" {
  ##name                = "${lower(var.base_name[count.index])}${random_string.random.result}"
  name                          = var.base_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  offer_type                    = "Standard"
  kind                          = "GlobalDocumentDB"
  public_network_access_enabled = true
  ip_range_filter               = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  capabilities {
    name = "EnableServerless"
  }

  ## where data should be replicated to or failover to. failover_priority = 0 means primary failover
  geo_location {
    location          = var.location
    failover_priority = 0
  }
}


## create cosmosdb sql database
resource "azurerm_cosmosdb_sql_database" "db" {
  name                = "severless-prime"
  resource_group_name = var.resource_group_name
  account_name        = var.base_name

  depends_on = [
    azurerm_cosmosdb_account.db
  ]
}


resource "azurerm_cosmosdb_sql_container" "example" {
  name                  = "severless-prime"
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.db.name
  database_name         = azurerm_cosmosdb_sql_database.db.name
  partition_key_path    = "/definition/id"
  partition_key_version = 1


  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}
