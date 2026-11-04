data "oci_identity_availability_domains" "this" {
  compartment_id = var.compartment_id
}

resource "oci_psql_db_system" "this" {
  compartment_id = var.compartment_id

  credentials {
    password_details {
      password_type = var.db_system_credentials_password_details_password_type

      password       = var.db_system_credentials_password_details_password
      secret_id      = var.vault_secret_id
      secret_version = var.db_system_credentials_password_details_secret_version
    }
    username = var.db_system_credentials_username
  }
  db_version   = var.db_system_db_version
  display_name = var.db_system_display_name
  network_details {
    subnet_id = var.subnet_id == null && var.db_subnet != null ? oci_core_subnet.db_subnet[0].id : var.subnet_id

    is_reader_endpoint_enabled     = var.db_system_network_details_is_reader_endpoint_enabled
    nsg_ids                        = var.db_system_network_details_nsg_ids
    primary_db_endpoint_private_ip = var.db_system_network_details_primary_db_endpoint_private_ip
  }
  shape = var.db_system_shape
  storage_details {
    is_regionally_durable = var.db_system_storage_details_is_regionally_durable
    system_type           = var.db_system_storage_details_system_type

    availability_domain = var.db_system_storage_details_is_regionally_durable == false ? data.oci_identity_availability_domains.this.availability_domains[0].name : var.db_system_storage_details_system_type
    iops                = var.db_system_storage_details_iops
  }

  config_id                   = var.apm_config
  defined_tags                = var.defined_tags
  description                 = var.db_system_description
  freeform_tags               = var.freeform_tags
  instance_count              = var.db_system_instance_count
  instance_memory_size_in_gbs = var.db_system_instance_memory_size_in_gbs
  instance_ocpu_count         = var.db_system_instance_ocpu_count
  instances_details {
    description  = var.db_system_instances_details_description
    display_name = var.db_system_instances_details_display_name
    private_ip   = var.db_system_instances_details_private_ip
  }
  dynamic "management_policy" {
    for_each = var.management_policy != null ? [var.management_policy] : []

    content {
      maintenance_window_start = management_policy.value.maintenance_window_start

      dynamic "backup_policy" {
        for_each = management_policy.value.backup_policy != null ? [management_policy.value.backup_policy] : []

        content {
          days_of_the_month = backup_policy.value.days_of_the_month
          days_of_the_week  = backup_policy.value.days_of_the_week
          kind              = backup_policy.value.kind
          retention_days    = backup_policy.value.retention_days
          backup_start      = backup_policy.value.backup_start

          dynamic "copy_policy" {
            for_each = (lookup(backup_policy.value, "copy_policy", null) != null &&
            length(lookup(backup_policy.value.copy_policy, "regions", [])) > 0) ? [backup_policy.value.copy_policy] : []

            content {
              compartment_id   = var.compartment_id
              regions          = copy_policy.value.regions
              retention_period = copy_policy.value.retention_period
            }
          }
        }
      }

      dynamic "pitr_policy" {
        for_each = management_policy.value.pitr_policy != null ? [management_policy.value.pitr_policy] : []

        content {
          kind         = pitr_policy.value.kind
          restore_days = pitr_policy.value.restore_days
        }
      }
    }
  }
  dynamic "source" {
    for_each = var.restore_from_backup_id != null ? [1] : []
    content {
      source_type                        = "BACKUP"
      backup_id                          = var.restore_from_backup_id
      is_having_restore_config_overrides = var.db_system_source_is_having_restore_config_overrides
    }
  }

  system_type  = var.db_system_system_type
  apply_config = var.apply_config

  dynamic "patch_operations" {
    for_each = var.db_system_patch_operations_operation != null ? [1] : []
    content {
      operation = var.db_system_patch_operations_operation
      selection = var.db_system_patch_operations_selection
      value     = var.db_system_patch_operations_value
    }
  }
}

resource "oci_psql_backup" "this" {
  depends_on     = [oci_psql_db_system.this]
  count          = var.db_system_source_source_type == "BACKUP" ? 1 : 0
  compartment_id = var.compartment_id
  db_system_id   = oci_psql_db_system.this.id
  display_name   = var.psql_backup.display_name

  defined_tags     = merge(var.defined_tags, var.psql_backup.defined_tags)
  description      = var.psql_backup.description
  freeform_tags    = merge(var.freeform_tags, var.psql_backup.freeform_tags)
  retention_period = var.psql_backup.retention_period
}

resource "oci_core_subnet" "db_subnet" {
  count                      = var.db_subnet != null ? 1 : 0
  compartment_id             = var.compartment_id
  vcn_id                     = var.db_subnet.vcn_id
  display_name               = var.db_subnet.display_name
  dns_label                  = var.db_subnet.dns_label
  cidr_block                 = var.db_subnet.cidr_block
  route_table_id             = var.db_subnet.nat_route_table_id
  prohibit_public_ip_on_vnic = true
  security_list_ids          = var.db_subnet.security_list_ids
  defined_tags               = var.defined_tags
  freeform_tags              = var.freeform_tags
}

data "oci_psql_db_system_connection_detail" "this" {
  db_system_id = oci_psql_db_system.this.id
}
