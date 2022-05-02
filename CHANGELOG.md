## v0.4 [2022-05-02]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#13](https://github.com/turbot/steampipe-mod-azure-tags/pull/13))

## v0.3 [2022-03-29]

_What's new?_

- Added default values to all variables (set to the same values in `steampipe.spvars.example`)
- Added `*.spvars` and `*.auto.spvars` files to `.gitignore`
- Renamed `steampipe.spvars` to `steampipe.spvars.example`, so the variable default values will be used initially. To use this example file instead, copy `steampipe.spvars.example` as a new file `steampipe.spvars`, and then modify the variable values in it. For more information on how to set variable values, please see [Input Variable Configuration](https://hub.steampipe.io/mods/turbot/azure_tags#configuration).

## v0.2 [2021-11-15]

_Enhancements_

- `README.md` and `docs/index.md` files now include the console output image

## v0.1 [2021-09-09]

_What's new?_

New control types:
- Untagged: Find resources with no tag.
- Prohibited: Find prohibited tag names.
- Mandatory: Ensure mandatory tags are set.
- Limit: Detect when the tag limit is nearly met.

For 57 resource types:
- api_management
- app_service_environment
- app_service_function_app
- app_service_plan
- app_service_web_app
- application_security_group
- batch_account
- compute_availability_set
- compute_disk
- compute_disk_encryption_set
- compute_image
- compute_snapshot
- compute_virtual_machine
- compute_virtual_machine_scale_set
- container_registry
- cosmosdb_account
- cosmosdb_mongo_database
- cosmosdb_sql_database
- data_factory
- data_lake_analytics_account
- data_lake_store
- eventhub_namespace
- express_route_circuit
- firewall
- iothub
- key_vault
- key_vault_deleted_vault
- key_vault_key
- key_vault_managed_hardware_security_module
- key_vault_secret
- kubernetes_cluster
- lb
- log_alert
- log_profile
- logic_app_workflow
- mariadb_server
- mssql_elasticpool
- mssql_managed_instance
- mysql_server
- network_interface
- network_security_group
- network_watcher
- network_watcher_flow_log
- postgresql_server
- public_ip
- recovery_services_vault
- redis_cache
- resource_group
- route_table
- search_service
- servicebus_namespace
- sql_database
- sql_server
- storage_account
- stream_analytics_job
- virtual_network
- virtual_network_gateway
