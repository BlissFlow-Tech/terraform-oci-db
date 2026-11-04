module "db" {
  source = "../.."

  compartment_id                                       = var.compartment_id
  db_system_display_name                               = "app-db"
  db_system_credentials_username                       = "dbadmin"
  db_system_credentials_password_details_password_type = "VAULT"
  vault_secret_id                                      = var.admin_password_secret_id

  db_subnet = {
    vcn_id             = var.vcn_id
    nat_route_table_id = var.route_table_id
    cidr_block         = "10.0.10.0/24"
  }

  management_policy = {
    maintenance_window_start = "sun 02:00"
    backup_policy = {
      kind           = "DAILY"
      retention_days = "7"
      backup_start   = "01:00"
    }
  }
}

output "connection_details" {
  value = module.db.connection_details
}
