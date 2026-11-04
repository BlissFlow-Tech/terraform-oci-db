variable "compartment_id" {
  description = "OCID of the compartment that holds the DB system and its subnet"
  type        = string
}

variable "vcn_id" {
  description = "OCID of the VCN the dedicated database subnet is created in"
  type        = string
}

variable "route_table_id" {
  description = "OCID of the route table attached to the database subnet"
  type        = string
}

variable "admin_password_secret_id" {
  description = "OCID of the Vault secret holding the admin password"
  type        = string
}
