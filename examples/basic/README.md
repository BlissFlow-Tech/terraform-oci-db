# Basic example

Creates an OCI Database with PostgreSQL system in a new dedicated private subnet, with the admin password read from OCI Vault and daily backups.

```sh
terraform init
terraform apply \
  -var compartment_id=<compartment-ocid> \
  -var vcn_id=<vcn-ocid> \
  -var route_table_id=<route-table-ocid> \
  -var admin_password_secret_id=<vault-secret-ocid> \
  -var admin_password_secret_version=<secret-version>
```
