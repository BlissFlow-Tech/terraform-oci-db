variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment that contains the DB system."
}

variable "db_system_db_version" {
  type        = string
  description = "The PostgreSQL version of the DB system."
  default     = "16"
}

variable "db_system_display_name" {
  type        = string
  description = "User-friendly name of the DB system."
}

variable "db_system_shape" {
  type        = string
  description = "The name of the shape for the DB system nodes."
  default     = "VM.Standard.E5.Flex"
}

variable "db_system_system_type" {
  type        = string
  description = "Type of the DB system (e.g., OCI_OPTIMIZED_STORAGE)."
  default     = "OCI_OPTIMIZED_STORAGE"
}

variable "db_system_credentials_username" {
  type        = string
  description = "The username for the database admin."
}

variable "db_system_credentials_password_details_password_type" {
  type        = string
  description = "Type of password: PLAIN_TEXT or VAULT_SECRET"
  default     = "PLAIN_TEXT"
}

variable "vault_secret_id" {
  description = "OCID of the Vault secret holding the admin password, when password_type is VAULT_SECRET"
  type        = string
  default     = null
}

variable "db_system_credentials_password_details_password" {
  description = "Admin password, when password_type is PLAIN_TEXT"
  type        = string
  sensitive   = true
  default     = null
}

variable "db_system_credentials_password_details_secret_version" {
  description = "Version of the Vault secret holding the admin password, required when password_type is VAULT_SECRET"
  type        = number
  default     = null
}

variable "subnet_id" {
  description = "OCID of an existing subnet for the DB system; when null, the subnet created from db_subnet is used"
  type        = string
  default     = null
}
variable "db_system_network_details_is_reader_endpoint_enabled" {
  description = "Whether OCI creates a reader endpoint for the DB system"
  type        = bool
  default     = null
}

variable "db_system_network_details_nsg_ids" {
  description = "Network security group OCIDs attached to the DB system"
  type        = list(string)
  default     = null
}

variable "db_system_network_details_primary_db_endpoint_private_ip" {
  description = "Fixed private IP for the primary endpoint; null lets OCI assign one"
  type        = string
  default     = null
}

variable "db_system_storage_details_is_regionally_durable" {
  description = "Whether storage is replicated across availability domains. When false, the first availability domain of the compartment is used"
  type        = bool
  default     = false
}

variable "db_system_storage_details_system_type" {
  description = "Storage system type of the DB system"
  type        = string
  default     = "OCI_OPTIMIZED_STORAGE"
}

variable "db_system_storage_details_iops" {
  description = "Storage performance tier in IOPS"
  type        = number
  default     = 75000
}

variable "db_system_instance_count" {
  description = "Number of database nodes; null uses the OCI default"
  type        = number
  default     = null
}

variable "db_system_instance_memory_size_in_gbs" {
  description = "Memory per node in GB; null uses the shape default"
  type        = number
  default     = null
}

variable "db_system_instance_ocpu_count" {
  description = "OCPUs per node"
  type        = number
  default     = 2
}

variable "db_system_instances_details_description" {
  description = "Description of the database node set in instances_details"
  type        = string
  default     = null
}

variable "db_system_instances_details_display_name" {
  description = "Display name of the database node set in instances_details"
  type        = string
  default     = null
}

variable "db_system_instances_details_private_ip" {
  description = "Private IP of the database node set in instances_details"
  type        = string
  default     = null
}

variable "management_policy" {
  description = "Maintenance window, backup policy and point-in-time recovery policy of the DB system"
  type = object({
    maintenance_window_start = string
    backup_policy = optional(object({
      days_of_the_month = optional(list(string))
      days_of_the_week  = optional(list(string))
      kind              = string
      retention_days    = string
      backup_start      = optional(string)
      copy_policy = optional(object({
        regions          = list(string)
        retention_period = optional(string)
      }))
    }))
    pitr_policy = optional(object({
      kind         = string
      restore_days = optional(number)
    }))
  })
  default = null
}
variable "db_system_source_source_type" {
  description = "Set to BACKUP to take the on-demand backup described by psql_backup"
  type        = string
  default     = null
}

variable "db_system_source_is_having_restore_config_overrides" {
  description = "Whether a restore from restore_from_backup_id overrides the configuration stored in the backup"
  type        = bool
  default     = null
}

variable "apply_config" {
  description = "How a configuration change is applied to the DB system, e.g. RESTART or RELOAD"
  type        = string
  default     = null
}

variable "db_system_patch_operations_operation" {
  description = "Patch operation to run on the DB system; null skips patching"
  type        = string
  default     = null
}

variable "db_system_patch_operations_selection" {
  description = "Selection the patch operation applies to"
  type        = string
  default     = null
}

variable "db_system_patch_operations_value" {
  description = "Values for the patch operation"
  type        = map(string)
  default     = null
}

variable "db_system_description" {
  description = "Description of the DB system"
  type        = string
  default     = null
}

variable "defined_tags" {
  description = "Defined tags for the DB system, the backup and the dedicated subnet"
  type        = map(string)
  default     = null
}

variable "freeform_tags" {
  description = "Freeform tags for the DB system, the backup and the dedicated subnet"
  type        = map(string)
  default     = null
}

variable "psql_backup" {
  description = "On-demand backup taken when db_system_source_source_type is BACKUP"
  type = object({
    display_name     = string
    description      = optional(string)
    retention_period = optional(string)
    defined_tags     = optional(map(string))
    freeform_tags    = optional(map(string))
  })
  default = null
}

variable "restore_from_backup_id" {
  description = "OCID of a backup to restore the DB system from"
  type        = string
  default     = null
}

variable "apm_config" {
  description = "OCID of the PostgreSQL configuration applied to the DB system"
  type        = string
  default     = null
}

variable "db_subnet" {
  description = "Dedicated private subnet to create for the DB system when subnet_id is null"
  type = object({
    vcn_id             = string
    nat_route_table_id = string
    cidr_block         = optional(string)
    display_name       = optional(string, "db-subnet")
    dns_label          = optional(string, "psql")
    security_list_ids  = optional(list(string))
  })
  default = null
}
