# terraform-oci-db

Terraform module that creates an OCI Database with PostgreSQL system, optionally with a dedicated private subnet, backup policy and point-in-time recovery.

## Usage

```hcl
module "db" {
  source  = "blissflow-tech/db/oci"
  version = "~> 1.0"

  compartment_id                                       = "ocid1.compartment.oc1..example"
  db_system_display_name                               = "app-db"
  db_system_credentials_username                       = "dbadmin"
  db_system_credentials_password_details_password_type = "VAULT"
  vault_secret_id                                      = "ocid1.vaultsecret.oc1..example"

  db_subnet = {
    vcn_id             = "ocid1.vcn.oc1..example"
    nat_route_table_id = "ocid1.routetable.oc1..example"
    cidr_block         = "10.0.10.0/24"
  }

  management_policy = {
    maintenance_window_start = "sun 02:00"
    backup_policy = {
      kind           = "DAILY"
      retention_days = "7"
      backup_start   = "01:00"
    }
    pitr_policy = {
      kind = "ENABLED"
    }
  }
}
```

## Notes

* Set either `subnet_id` (an existing subnet) or `db_subnet` (a private subnet the module creates).
* The admin password comes from `db_system_credentials_password_details_password` with `PLAIN_TEXT`, or from `vault_secret_id` with `VAULT`.
* With `db_system_storage_details_is_regionally_durable = false` the storage is placed in the first availability domain of the compartment.
* Backups and maintenance are configured through `management_policy`.
* `restore_from_backup_id` creates the DB system from an existing backup. `db_system_source_source_type = "BACKUP"` instead takes an on-demand backup described by `psql_backup`.
* `connection_details` exposes the primary and reader endpoints and the CA certificate.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.3 |
| oci | >= 8.0, < 10.0 |

## Providers

| Name | Version |
| ---- | ------- |
| oci | >= 8.0, < 10.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [oci_core_subnet.db_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_psql_backup.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/psql_backup) | resource |
| [oci_psql_db_system.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/psql_db_system) | resource |
| [oci_identity_availability_domains.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |
| [oci_psql_db_system_connection_detail.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/psql_db_system_connection_detail) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| compartment\_id | The OCID of the compartment that contains the DB system. | `string` | n/a | yes |
| db\_system\_credentials\_username | The username for the database admin. | `string` | n/a | yes |
| db\_system\_display\_name | User-friendly name of the DB system. | `string` | n/a | yes |
| apm\_config | OCID of the PostgreSQL configuration applied to the DB system | `string` | `null` | no |
| apply\_config | How a configuration change is applied to the DB system, e.g. RESTART or RELOAD | `string` | `null` | no |
| db\_subnet | Dedicated private subnet to create for the DB system when subnet\_id is null | <pre>object({<br/>    vcn_id             = string<br/>    nat_route_table_id = string<br/>    cidr_block         = optional(string)<br/>    display_name       = optional(string, "db-subnet")<br/>    dns_label          = optional(string, "psql")<br/>    security_list_ids  = optional(list(string))<br/>  })</pre> | `null` | no |
| db\_system\_credentials\_password\_details\_password | Admin password, when password\_type is PLAIN\_TEXT | `string` | `null` | no |
| db\_system\_credentials\_password\_details\_password\_type | Type of password (e.g., PLAIN\_TEXT or VAULT). | `string` | `"PLAIN_TEXT"` | no |
| db\_system\_credentials\_password\_details\_secret\_version | Version of the Vault secret holding the admin password, when password\_type is VAULT; null uses the latest | `number` | `null` | no |
| db\_system\_db\_version | The PostgreSQL version of the DB system. | `string` | `"16"` | no |
| db\_system\_description | Description of the DB system | `string` | `null` | no |
| db\_system\_instance\_count | Number of database nodes; null uses the OCI default | `number` | `null` | no |
| db\_system\_instance\_memory\_size\_in\_gbs | Memory per node in GB; null uses the shape default | `number` | `null` | no |
| db\_system\_instance\_ocpu\_count | OCPUs per node | `number` | `2` | no |
| db\_system\_instances\_details\_description | Description of the database node set in instances\_details | `string` | `null` | no |
| db\_system\_instances\_details\_display\_name | Display name of the database node set in instances\_details | `string` | `null` | no |
| db\_system\_instances\_details\_private\_ip | Private IP of the database node set in instances\_details | `string` | `null` | no |
| db\_system\_network\_details\_is\_reader\_endpoint\_enabled | Whether OCI creates a reader endpoint for the DB system | `bool` | `null` | no |
| db\_system\_network\_details\_nsg\_ids | Network security group OCIDs attached to the DB system | `list(string)` | `null` | no |
| db\_system\_network\_details\_primary\_db\_endpoint\_private\_ip | Fixed private IP for the primary endpoint; null lets OCI assign one | `string` | `null` | no |
| db\_system\_patch\_operations\_operation | Patch operation to run on the DB system; null skips patching | `string` | `null` | no |
| db\_system\_patch\_operations\_selection | Selection the patch operation applies to | `string` | `null` | no |
| db\_system\_patch\_operations\_value | Values for the patch operation | `map(string)` | `null` | no |
| db\_system\_shape | The name of the shape for the DB system nodes. | `string` | `"VM.Standard.E5.Flex"` | no |
| db\_system\_source\_is\_having\_restore\_config\_overrides | Whether a restore from restore\_from\_backup\_id overrides the configuration stored in the backup | `bool` | `null` | no |
| db\_system\_source\_source\_type | Set to BACKUP to take the on-demand backup described by psql\_backup | `string` | `null` | no |
| db\_system\_storage\_details\_iops | Storage performance tier in IOPS | `number` | `75000` | no |
| db\_system\_storage\_details\_is\_regionally\_durable | Whether storage is replicated across availability domains. When false, the first availability domain of the compartment is used | `bool` | `false` | no |
| db\_system\_storage\_details\_system\_type | Storage system type of the DB system | `string` | `"OCI_OPTIMIZED_STORAGE"` | no |
| db\_system\_system\_type | Type of the DB system (e.g., OCI\_OPTIMIZED\_STORAGE). | `string` | `"OCI_OPTIMIZED_STORAGE"` | no |
| defined\_tags | Defined tags for the DB system, the backup and the dedicated subnet | `map(string)` | `null` | no |
| freeform\_tags | Freeform tags for the DB system, the backup and the dedicated subnet | `map(string)` | `null` | no |
| management\_policy | Maintenance window, backup policy and point-in-time recovery policy of the DB system | <pre>object({<br/>    maintenance_window_start = string<br/>    backup_policy = optional(object({<br/>      days_of_the_month = optional(list(string))<br/>      days_of_the_week  = optional(list(string))<br/>      kind              = string<br/>      retention_days    = string<br/>      backup_start      = optional(string)<br/>      copy_policy = optional(object({<br/>        regions          = list(string)<br/>        retention_period = optional(string)<br/>      }))<br/>    }))<br/>    pitr_policy = optional(object({<br/>      kind         = string<br/>      restore_days = optional(number)<br/>    }))<br/>  })</pre> | `null` | no |
| psql\_backup | On-demand backup taken when db\_system\_source\_source\_type is BACKUP | <pre>object({<br/>    display_name     = string<br/>    description      = optional(string)<br/>    retention_period = optional(string)<br/>    defined_tags     = optional(map(string))<br/>    freeform_Tags = optional(map(string)<br/>    )<br/>  })</pre> | `null` | no |
| restore\_from\_backup\_id | OCID of a backup to restore the DB system from | `string` | `null` | no |
| subnet\_id | OCID of an existing subnet for the DB system; when null, the subnet created from db\_subnet is used | `string` | `null` | no |
| vault\_secret\_id | OCID of the Vault secret holding the admin password, when password\_type is VAULT | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| admin\_username | The database system administrator username. |
| backup | The full set of attributes for the OCI PostgreSQL backup. |
| compartment\_id | The OCID of the compartment that contains the database system. |
| config\_id | The OCID of the configuration associated with the database system. |
| connection\_details | DB connection details |
| credentials | Database credentials |
| db-subnet | The dedicated subnet created from db\_subnet, or null |
| db\_version | The major and minor versions of the database system software. |
| defined\_tags | Defined tags for this resource. |
| description | A description of the database system. |
| display\_name | A user-friendly display name for the database system. |
| freeform\_tags | Simple key-value pair tags. |
| id | A unique identifier for the database system. Immutable on creation. |
| instance\_count | Count of instances, or nodes, in the database system. |
| instance\_memory\_size\_in\_gbs | The total amount of memory available to each database instance node, in gigabytes. |
| instance\_ocpu\_count | The total number of OCPUs available to each database instance node. |
| instances | The list of instances, or nodes, in the database system with their full internal details. |
| lifecycle\_details | A message describing the current state in more detail. |
| management\_policy | PostgreSQL database system management policy (Backup and Maintenance details). |
| network\_details | Network configuration details including Subnet and NSGs. |
| shape | The name of the shape for the database instance. Example: VM.Standard.E4.Flex |
| source | The source of the database system (Backup details). |
| state | The current state of the database system. |
| storage\_details | Storage details including durability, IOPS, and availability domain. |
| system\_tags | System tags for this resource. |
| system\_type | Type of the database system. |
| time\_created | The date and time that the database system was created. |
| time\_updated | The date and time that the database system was updated. |
<!-- END_TF_DOCS -->

## License

Apache 2.0. See [LICENSE](LICENSE).
