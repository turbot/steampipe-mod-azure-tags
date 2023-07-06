locals {
  untagged_sql = <<EOT
    select
      id as resource,
      case
        when tags is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when tags is not null then title || ' has tags.'
        else title || ' has no tags.'
      end as reason,
      __DIMENSIONS__
    from
      __TABLE_NAME__
  EOT
}

locals {
  untagged_sql_subscription   = replace(local.untagged_sql, "__DIMENSIONS__", "subscription_id")
  untagged_sql_resource_group = replace(local.untagged_sql, "__DIMENSIONS__", "resource_group, subscription_id")
}

benchmark "untagged" {
  title       = "Untagged"
  description = "Untagged resources are difficult to monitor and should be identified and remediated."
  children = [
    control.api_management_untagged,
    control.app_service_environment_untagged,
    control.app_service_function_app_untagged,
    control.app_service_plan_untagged,
    control.app_service_web_app_untagged,
    control.application_security_group_untagged,
    control.batch_account_untagged,
    control.compute_availability_set_untagged,
    control.compute_disk_encryption_set_untagged,
    control.compute_disk_untagged,
    control.compute_image_untagged,
    control.compute_snapshot_untagged,
    control.compute_virtual_machine_scale_set_untagged,
    control.compute_virtual_machine_untagged,
    control.container_registry_untagged,
    control.cosmosdb_account_untagged,
    control.cosmosdb_mongo_database_untagged,
    control.cosmosdb_sql_database_untagged,
    control.data_factory_untagged,
    control.data_lake_analytics_account_untagged,
    control.data_lake_store_untagged,
    control.eventhub_namespace_untagged,
    control.express_route_circuit_untagged,
    control.firewall_untagged,
    control.iothub_untagged,
    control.key_vault_deleted_vault_untagged,
    control.key_vault_key_untagged,
    control.key_vault_managed_hardware_security_module_untagged,
    control.key_vault_secret_untagged,
    control.key_vault_untagged,
    control.kubernetes_cluster_untagged,
    control.lb_untagged,
    control.log_alert_untagged,
    control.log_profile_untagged,
    control.logic_app_workflow_untagged,
    control.mariadb_server_untagged,
    control.mssql_elasticpool_untagged,
    control.mssql_managed_instance_untagged,
    control.mysql_server_untagged,
    control.network_interface_untagged,
    control.network_security_group_untagged,
    control.network_watcher_flow_log_untagged,
    control.network_watcher_untagged,
    control.postgresql_server_untagged,
    control.public_ip_untagged,
    control.recovery_services_vault_untagged,
    control.redis_cache_untagged,
    control.resource_group_untagged,
    control.route_table_untagged,
    control.search_service_untagged,
    control.servicebus_namespace_untagged,
    control.sql_database_untagged,
    control.sql_server_untagged,
    control.storage_account_untagged,
    control.stream_analytics_job_untagged,
    control.virtual_network_gateway_untagged,
    control.virtual_network_untagged
  ]
  
  tags = merge(local.azure_tags_common_tags, {
    type = "Benchmark"
  })
}

control "api_management_untagged" {
  title       = "API Management services should be tagged"
  description = "Check if API Management services have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_api_management")
}

control "app_service_environment_untagged" {
  title       = "App Service environments should be tagged"
  description = "Check if App Service environments have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_app_service_environment")
}

control "app_service_function_app_untagged" {
  title       = "App Service function apps should be tagged"
  description = "Check if App Service function apps have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_app_service_function_app")
}

control "app_service_plan_untagged" {
  title       = "App Service plans should be tagged"
  description = "Check if App Service plans have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_app_service_plan")
}

control "app_service_web_app_untagged" {
  title       = "App Service web apps should be tagged"
  description = "Check if App Service web apps have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_app_service_web_app")
}

control "application_security_group_untagged" {
  title       = "Application security groups should be tagged"
  description = "Check if Application security groups have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_application_security_group")
}

control "batch_account_untagged" {
  title       = "Batch accounts should be tagged"
  description = "Check if Batch accounts have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_batch_account")
}

control "compute_availability_set_untagged" {
  title       = "Compute availability sets should be tagged"
  description = "Check if Compute availability sets have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_compute_availability_set")
}

control "compute_disk_untagged" {
  title       = "Compute disks should be tagged"
  description = "Check if Compute disks have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_compute_disk")
}

control "compute_disk_encryption_set_untagged" {
  title       = "Compute disk encryption sets should be tagged"
  description = "Check if Compute disk encryption sets have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_compute_disk_encryption_set")
}

control "compute_image_untagged" {
  title       = "Compute images should be tagged"
  description = "Check if Compute images have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_compute_image")
}

control "compute_snapshot_untagged" {
  title       = "Compute snapshots should be tagged"
  description = "Check if Compute snapshots have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_compute_snapshot")
}

control "compute_virtual_machine_untagged" {
  title       = "Compute virtual machines should be tagged"
  description = "Check if Compute virtual machines have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_compute_virtual_machine")
}

control "compute_virtual_machine_scale_set_untagged" {
  title       = "Compute virtual machine scale sets should be tagged"
  description = "Check if Compute virtual machine scale sets have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_compute_virtual_machine_scale_set")
}

control "container_registry_untagged" {
  title       = "Container registries should be tagged"
  description = "Check if Container registries have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_container_registry")
}

control "cosmosdb_account_untagged" {
  title       = "CosmosDB accounts should be tagged"
  description = "Check if CosmosDB accounts have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_cosmosdb_account")
}

control "cosmosdb_mongo_database_untagged" {
  title       = "CosmosDB mongo databases should be tagged"
  description = "Check if CosmosDB mongo databases have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_cosmosdb_mongo_database")
}

control "cosmosdb_sql_database_untagged" {
  title       = "CosmosDB sql databases should be tagged"
  description = "Check if CosmosDB sql databases have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_cosmosdb_sql_database")
}

control "data_factory_untagged" {
  title       = "Data factories should be tagged"
  description = "Check if Data factories have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_data_factory")
}

control "data_lake_analytics_account_untagged" {
  title       = "Data lake analytics accounts should be tagged"
  description = "Check if Data lake analytics accounts have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_data_lake_analytics_account")
}

control "data_lake_store_untagged" {
  title       = "Data lake stores should be tagged"
  description = "Check if Data lake stores have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_data_lake_store")
}

control "eventhub_namespace_untagged" {
  title       = "Event Hub namespaces should be tagged"
  description = "Check if Event Hub namespaces have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_eventhub_namespace")
}

control "express_route_circuit_untagged" {
  title       = "ExpressRoute circuits should be tagged"
  description = "Check if ExpressRoute circuits have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_express_route_circuit")
}

control "firewall_untagged" {
  title       = "Firewalls should be tagged"
  description = "Check if Firewalls have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_firewall")
}

control "iothub_untagged" {
  title       = "IoT Hubs should be tagged"
  description = "Check if IoT Hubs have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_iothub")
}

control "key_vault_untagged" {
  title       = "Key vaults should be tagged"
  description = "Check if Key vaults have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_key_vault")
}

control "key_vault_deleted_vault_untagged" {
  title       = "Key vault deleted vaults should be tagged"
  description = "Check if Key vault deleted vaults have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_deleted_vault")
}

control "key_vault_key_untagged" {
  title       = "Key vault keys should be tagged"
  description = "Check if Key vault keys have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_key")
}

control "key_vault_managed_hardware_security_module_untagged" {
  title       = "Key vault managed hardware security modules should be tagged"
  description = "Check if Key vault managed hardware security modules have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_managed_hardware_security_module")
}

control "key_vault_secret_untagged" {
  title       = "Key vault secrets should be tagged"
  description = "Check if Key vault secrets have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_secret")
}

control "kubernetes_cluster_untagged" {
  title       = "Kubernetes clusters should be tagged"
  description = "Check if Kubernetes clusters have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_kubernetes_cluster")
}

control "lb_untagged" {
  title       = "Load balancers should be tagged"
  description = "Check if Load balancers have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_lb")
}

control "log_alert_untagged" {
  title       = "Log alerts should be tagged"
  description = "Check if Log alerts have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_log_alert")
}

control "log_profile_untagged" {
  title       = "Log profiles should be tagged"
  description = "Check if Log profiles have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_log_profile")
}

control "logic_app_workflow_untagged" {
  title       = "Logic app workflows should be tagged"
  description = "Check if Logic app workflows have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_logic_app_workflow")
}

control "mariadb_server_untagged" {
  title       = "MariaDB servers should be tagged"
  description = "Check if MariaDB servers have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_mariadb_server")
}

control "mssql_elasticpool_untagged" {
  title       = "Microsoft SQL elasticpools should be tagged"
  description = "Check if Microsoft SQL elasticpools have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_mssql_elasticpool")
}

control "mssql_managed_instance_untagged" {
  title       = "Microsoft SQL managed instances should be tagged"
  description = "Check if Microsoft SQL managed instances have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_mssql_managed_instance")
}

control "mysql_server_untagged" {
  title       = "MySQL servers should be tagged"
  description = "Check if MySQL servers have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_mysql_server")
}

control "network_interface_untagged" {
  title       = "Network interfaces should be tagged"
  description = "Check if Network interfaces have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_network_interface")
}

control "network_security_group_untagged" {
  title       = "Network security groups should be tagged"
  description = "Check if Network security groups have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_network_security_group")
}

control "network_watcher_untagged" {
  title       = "Network watchers should be tagged"
  description = "Check if Network watchers have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_network_watcher")
}

control "network_watcher_flow_log_untagged" {
  title       = "Network watcher flow logs should be tagged"
  description = "Check if Network watcher flow logs have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_network_watcher_flow_log")
}

control "postgresql_server_untagged" {
  title       = "PostgreSQL servers should be tagged"
  description = "Check if PostgreSQL servers have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_postgresql_server")
}

control "public_ip_untagged" {
  title       = "Public IPs should be tagged"
  description = "Check if Public IPs have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_public_ip")
}

control "recovery_services_vault_untagged" {
  title       = "Recovery services vaults should be tagged"
  description = "Check if Recovery services vaults have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_recovery_services_vault")
}

control "redis_cache_untagged" {
  title       = "Redis caches should be tagged"
  description = "Check if Redis caches have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_redis_cache")
}

control "resource_group_untagged" {
  title       = "Resource groups should be tagged"
  description = "Check if Resource groups have at least 1 tag."
  sql         = replace(local.untagged_sql_subscription, "__TABLE_NAME__", "azure_resource_group")
}

control "route_table_untagged" {
  title       = "Route tables should be tagged"
  description = "Check if Route tables have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_route_table")
}

control "search_service_untagged" {
  title       = "Search services should be tagged"
  description = "Check if Search services have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_search_service")
}

control "servicebus_namespace_untagged" {
  title       = "Service Bus namespaces should be tagged"
  description = "Check if Service Bus namespaces have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_servicebus_namespace")
}

control "sql_database_untagged" {
  title       = "SQL databases should be tagged"
  description = "Check if SQL databases have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_sql_database")
}

control "sql_server_untagged" {
  title       = "SQL servers should be tagged"
  description = "Check if SQL servers have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_sql_server")
}

control "storage_account_untagged" {
  title       = "Storage accounts should be tagged"
  description = "Check if Storage accounts have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_storage_account")
}

control "stream_analytics_job_untagged" {
  title       = "Stream Analytics jobs should be tagged"
  description = "Check if Stream Analytics jobs have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_stream_analytics_job")
}

control "virtual_network_untagged" {
  title       = "Virtual networks should be tagged"
  description = "Check if Virtual networks have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_virtual_network")
}

control "virtual_network_gateway_untagged" {
  title       = "Virtual network gateways should be tagged"
  description = "Check if Virtual network gateways have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_virtual_network_gateway")
}
