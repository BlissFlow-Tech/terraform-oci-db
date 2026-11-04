output "admin_username" {
  description = "The database system administrator username."
  value       = oci_psql_db_system.this.admin_username
}

output "credentials" {
  description = "Database credentials"
  value       = oci_psql_db_system.this.credentials
  sensitive   = true
}

output "compartment_id" {
  description = "The OCID of the compartment that contains the database system."
  value       = oci_psql_db_system.this.compartment_id
}

output "config_id" {
  description = "The OCID of the configuration associated with the database system."
  value       = oci_psql_db_system.this.config_id
}

output "db_version" {
  description = "The major and minor versions of the database system software."
  value       = oci_psql_db_system.this.db_version
}

output "description" {
  description = "A description of the database system."
  value       = oci_psql_db_system.this.description
}

output "display_name" {
  description = "A user-friendly display name for the database system."
  value       = oci_psql_db_system.this.display_name
}

output "id" {
  description = "A unique identifier for the database system. Immutable on creation."
  value       = oci_psql_db_system.this.id
}

output "instance_count" {
  description = "Count of instances, or nodes, in the database system."
  value       = oci_psql_db_system.this.instance_count
}

output "instance_memory_size_in_gbs" {
  description = "The total amount of memory available to each database instance node, in gigabytes."
  value       = oci_psql_db_system.this.instance_memory_size_in_gbs
}

output "instance_ocpu_count" {
  description = "The total number of OCPUs available to each database instance node."
  value       = oci_psql_db_system.this.instance_ocpu_count
}

output "lifecycle_details" {
  description = "A message describing the current state in more detail."
  value       = oci_psql_db_system.this.lifecycle_details
}

output "state" {
  description = "The current state of the database system."
  value       = oci_psql_db_system.this.state
}

output "system_type" {
  description = "Type of the database system."
  value       = oci_psql_db_system.this.system_type
}

output "shape" {
  description = "The name of the shape for the database instance. Example: VM.Standard.E4.Flex"
  value       = oci_psql_db_system.this.shape
}

output "time_created" {
  description = "The date and time that the database system was created."
  value       = oci_psql_db_system.this.time_created
}

output "time_updated" {
  description = "The date and time that the database system was updated."
  value       = oci_psql_db_system.this.time_updated
}

output "instances" {
  description = "The list of instances, or nodes, in the database system with their full internal details."
  value       = oci_psql_db_system.this.instances
}

output "management_policy" {
  description = "PostgreSQL database system management policy (Backup and Maintenance details)."
  value       = oci_psql_db_system.this.management_policy
}

output "network_details" {
  description = "Network configuration details including Subnet and NSGs."
  value       = oci_psql_db_system.this.network_details
}

output "connection_details" {
  description = "DB connection details"
  value = {
    ca_certificate      = sensitive(data.oci_psql_db_system_connection_detail.this.ca_certificate)
    instance_endpoints  = data.oci_psql_db_system_connection_detail.this.instance_endpoints
    primary_db_endpoint = one(data.oci_psql_db_system_connection_detail.this.primary_db_endpoint)
    reader_endpoint     = data.oci_psql_db_system_connection_detail.this.reader_endpoint
  }
}

output "storage_details" {
  description = "Storage details including durability, IOPS, and availability domain."
  value       = oci_psql_db_system.this.storage_details
}

output "source" {
  description = "The source of the database system (Backup details)."
  value       = oci_psql_db_system.this.source
}

output "defined_tags" {
  description = "Defined tags for this resource."
  value       = oci_psql_db_system.this.defined_tags
}

output "freeform_tags" {
  description = "Simple key-value pair tags."
  value       = oci_psql_db_system.this.freeform_tags
}

output "system_tags" {
  description = "System tags for this resource."
  value       = oci_psql_db_system.this.system_tags
}

output "backup" {
  description = "The full set of attributes for the OCI PostgreSQL backup."
  value = {
    id               = oci_psql_backup.this[*].id
    display_name     = oci_psql_backup.this[*].display_name
    description      = oci_psql_backup.this[*].description
    compartment_id   = oci_psql_backup.this[*].compartment_id
    backup_size      = oci_psql_backup.this[*].backup_size
    db_system_id     = oci_psql_backup.this[*].db_system_id
    retention_period = oci_psql_backup.this[*].retention_period
    source_type      = oci_psql_backup.this[*].source_type

    state                        = oci_psql_backup.this[*].state
    lifecycle_details            = oci_psql_backup.this[*].lifecycle_details
    last_accepted_request_token  = oci_psql_backup.this[*].last_accepted_request_token
    last_completed_request_token = oci_psql_backup.this[*].last_completed_request_token

    time_created         = oci_psql_backup.this[*].time_created
    time_created_precise = oci_psql_backup.this[*].time_created_precise
    time_updated         = oci_psql_backup.this[*].time_updated

    copy_status = oci_psql_backup.this[*].copy_status

    db_system_details = {
      config_id   = oci_psql_backup.this[*].db_system_details.config_id
      db_version  = oci_psql_backup.this[*].db_system_details.db_version
      system_type = oci_psql_backup.this[*].db_system_details.system_type
    }

    source_backup_details = {
      source_backup_id = oci_psql_backup.this[*].source_backup_details.source_backup_id
      source_region    = oci_psql_backup.this[*].source_backup_details.source_region
    }

    defined_tags  = oci_psql_backup.this[*].defined_tags
    freeform_tags = oci_psql_backup.this[*].freeform_tags
    system_tags   = oci_psql_backup.this[*].system_tags
  }
}

output "db_subnet" {
  description = "The dedicated subnet created from db_subnet, or null"
  value = var.db_subnet != null ? {
    id                         = one(oci_core_subnet.db_subnet[*].id)
    cidr_block                 = one(oci_core_subnet.db_subnet[*].cidr_block)
    dns_label                  = one(oci_core_subnet.db_subnet[*].dns_label)
    display_name               = one(oci_core_subnet.db_subnet[*].display_name)
    vcn_id                     = one(oci_core_subnet.db_subnet[*].vcn_id)
    time_created               = one(oci_core_subnet.db_subnet[*].time_created)
    defined_tags               = one(oci_core_subnet.db_subnet[*].defined_tags)
    freeform_tags              = one(oci_core_subnet.db_subnet[*].freeform_tags)
    compartment_id             = one(oci_core_subnet.db_subnet[*].compartment_id)
    state                      = one(oci_core_subnet.db_subnet[*].state)
    availability_domain        = one(oci_core_subnet.db_subnet[*].availability_domain)
    dhcp_options_id            = one(oci_core_subnet.db_subnet[*].dhcp_options_id)
    ipv4cidr_blocks            = one(oci_core_subnet.db_subnet[*].ipv4cidr_blocks)
    ipv6cidr_block             = one(oci_core_subnet.db_subnet[*].ipv6cidr_block)
    ipv6virtual_router_ip      = one(oci_core_subnet.db_subnet[*].ipv6virtual_router_ip)
    prohibit_internet_ingress  = one(oci_core_subnet.db_subnet[*].prohibit_internet_ingress)
    prohibit_public_ip_on_vnic = one(oci_core_subnet.db_subnet[*].prohibit_public_ip_on_vnic)
    route_table_id             = one(oci_core_subnet.db_subnet[*].route_table_id)
    virtual_router_mac         = one(oci_core_subnet.db_subnet[*].virtual_router_mac)
    security_list_ids          = one(oci_core_subnet.db_subnet[*].security_list_ids)
    subnet_domain_name         = one(oci_core_subnet.db_subnet[*].subnet_domain_name)
  } : null
}
