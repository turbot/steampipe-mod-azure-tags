variable "prohibited_tags" {
  type        = list(string)
  description = "A list of prohibited tags to check for."
  default     = ["Password", "Key"]
}

locals {
  prohibited_sql = <<-EOQ
    with analysis as (
      select
        id,
        array_agg(k) as prohibited_tags,
        _ctx,
        resource_group,
        subscription_id,
        tags,
        region
      from
        __TABLE_NAME__,
        jsonb_object_keys(tags) as k,
        unnest($1::text[]) as prohibited_key
      where
        k = prohibited_key
      group by
        id,
        _ctx,
        resource_group,
        tags,
        subscription_id,
        region
    )
    select
      r.id as resource,
      case
        when a.prohibited_tags <> array[]::text[] then 'alarm'
        else 'ok'
      end as status,
      case
        when a.prohibited_tags <> array[]::text[] then r.title || ' has prohibited tags: ' || array_to_string(a.prohibited_tags, ', ') || '.'
        else r.title || ' has no prohibited tags.'
      end as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
    from
      __TABLE_NAME__ as r
    full outer join
      analysis as a on a.id = r.id;
  EOQ
}

benchmark "prohibited" {
  title       = "Prohibited"
  description = "Prohibited tags may contain sensitive, confidential, or otherwise unwanted data and should be removed."
  children = [
    control.api_management_prohibited,
    control.app_service_environment_prohibited,
    control.app_service_function_app_prohibited,
    control.app_service_plan_prohibited,
    control.app_service_web_app_prohibited,
    control.application_security_group_prohibited,
    control.batch_account_prohibited,
    control.compute_availability_set_prohibited,
    control.compute_disk_encryption_set_prohibited,
    control.compute_disk_prohibited,
    control.compute_image_prohibited,
    control.compute_snapshot_prohibited,
    control.compute_virtual_machine_prohibited,
    control.compute_virtual_machine_scale_set_prohibited,
    control.container_registry_prohibited,
    control.cosmosdb_account_prohibited,
    control.cosmosdb_mongo_database_prohibited,
    control.cosmosdb_sql_database_prohibited,
    control.data_factory_prohibited,
    control.data_lake_analytics_account_prohibited,
    control.data_lake_store_prohibited,
    control.eventhub_namespace_prohibited,
    control.express_route_circuit_prohibited,
    control.firewall_prohibited,
    control.iothub_prohibited,
    control.key_vault_deleted_vault_prohibited,
    control.key_vault_key_prohibited,
    control.key_vault_managed_hardware_security_module_prohibited,
    control.key_vault_prohibited,
    control.key_vault_secret_prohibited,
    control.kubernetes_cluster_prohibited,
    control.lb_prohibited,
    control.log_alert_prohibited,
    control.log_profile_prohibited,
    control.logic_app_workflow_prohibited,
    control.mariadb_server_prohibited,
    control.mssql_elasticpool_prohibited,
    control.mssql_managed_instance_prohibited,
    control.mysql_server_prohibited,
    control.network_interface_prohibited,
    control.network_security_group_prohibited,
    control.network_watcher_flow_log_prohibited,
    control.network_watcher_prohibited,
    control.postgresql_server_prohibited,
    control.public_ip_prohibited,
    control.recovery_services_vault_prohibited,
    control.redis_cache_prohibited,
    control.resource_group_prohibited,
    control.route_table_prohibited,
    control.search_service_prohibited,
    control.servicebus_namespace_prohibited,
    control.sql_database_prohibited,
    control.sql_server_prohibited,
    control.storage_account_prohibited,
    control.stream_analytics_job_prohibited,
    control.virtual_network_gateway_prohibited,
    control.virtual_network_prohibited
  ]

  tags = merge(local.azure_tags_common_tags, {
    type = "Benchmark"
  })
}

control "api_management_prohibited" {
  title       = "API Management services should not have prohibited tags"
  description = "Check if API Management services have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_api_management")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "app_service_environment_prohibited" {
  title       = "App Service environments should not have prohibited tags"
  description = "Check if App Service environments have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_app_service_environment")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "app_service_function_app_prohibited" {
  title       = "App Service function apps should not have prohibited tags"
  description = "Check if App Service function apps have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_app_service_function_app")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "app_service_plan_prohibited" {
  title       = "App Service plans should not have prohibited tags"
  description = "Check if App Service plans have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_app_service_plan")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "app_service_web_app_prohibited" {
  title       = "App Service web apps should not have prohibited tags"
  description = "Check if App Service web apps have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_app_service_web_app")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "application_security_group_prohibited" {
  title       = "Application security groups should not have prohibited tags"
  description = "Check if Application security groups have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_application_security_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "batch_account_prohibited" {
  title       = "Batch accounts should not have prohibited tags"
  description = "Check if Batch accounts have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_batch_account")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "compute_availability_set_prohibited" {
  title       = "Compute availability sets should not have prohibited tags"
  description = "Check if Compute availability sets have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_compute_availability_set")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "compute_disk_prohibited" {
  title       = "Compute disks should not have prohibited tags"
  description = "Check if Compute disks have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_compute_disk")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "compute_disk_encryption_set_prohibited" {
  title       = "Compute disk encryption sets should not have prohibited tags"
  description = "Check if Compute disk encryption sets have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_compute_disk_encryption_set")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "compute_image_prohibited" {
  title       = "Compute images should not have prohibited tags"
  description = "Check if Compute images have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_compute_image")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "compute_snapshot_prohibited" {
  title       = "Compute snapshots should not have prohibited tags"
  description = "Check if Compute snapshots have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_compute_snapshot")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "compute_virtual_machine_prohibited" {
  title       = "Compute virtual machines should not have prohibited tags"
  description = "Check if Compute virtual machines have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_compute_virtual_machine")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "compute_virtual_machine_scale_set_prohibited" {
  title       = "Compute virtual machine scale sets should not have prohibited tags"
  description = "Check if Compute virtual machine scale sets have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_compute_virtual_machine_scale_set")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "container_registry_prohibited" {
  title       = "Container registries should not have prohibited tags"
  description = "Check if Container registries have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_container_registry")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cosmosdb_account_prohibited" {
  title       = "CosmosDB accounts should not have prohibited tags"
  description = "Check if CosmosDB accounts have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_cosmosdb_account")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cosmosdb_mongo_database_prohibited" {
  title       = "CosmosDB mongo databases should not have prohibited tags"
  description = "Check if CosmosDB mongo databases have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_cosmosdb_mongo_database")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "cosmosdb_sql_database_prohibited" {
  title       = "CosmosDB sql databases should not have prohibited tags"
  description = "Check if CosmosDB sql databases have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_cosmosdb_sql_database")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "data_factory_prohibited" {
  title       = "Data factories should not have prohibited tags"
  description = "Check if Data factories have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_data_factory")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "data_lake_analytics_account_prohibited" {
  title       = "Data lake analytics accounts should not have prohibited tags"
  description = "Check if Data lake analytics accounts have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_data_lake_analytics_account")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "data_lake_store_prohibited" {
  title       = "Data lake stores should not have prohibited tags"
  description = "Check if Data lake stores have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_data_lake_store")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "eventhub_namespace_prohibited" {
  title       = "Event Hub namespaces should not have prohibited tags"
  description = "Check if Event Hub namespaces have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_eventhub_namespace")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "express_route_circuit_prohibited" {
  title       = "ExpressRoute circuits should not have prohibited tags"
  description = "Check if ExpressRoute circuits have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_express_route_circuit")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "firewall_prohibited" {
  title       = "Firewalls should not have prohibited tags"
  description = "Check if Firewalls have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_firewall")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "iothub_prohibited" {
  title       = "IoT Hubs should not have prohibited tags"
  description = "Check if IoT Hubs have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_iothub")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "key_vault_prohibited" {
  title       = "Key vaults should not have prohibited tags"
  description = "Check if Key vaults have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_key_vault")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "key_vault_deleted_vault_prohibited" {
  title       = "Key vault deleted vaults should not have prohibited tags"
  description = "Check if Key vault deleted vaults have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_key_vault_deleted_vault")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "key_vault_key_prohibited" {
  title       = "Key vault keys should not have prohibited tags"
  description = "Check if Key vault keys have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_key_vault_key")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "key_vault_managed_hardware_security_module_prohibited" {
  title       = "Key vault managed hardware security modules should not have prohibited tags"
  description = "Check if Key vault managed hardware security modules have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_key_vault_managed_hardware_security_module")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "key_vault_secret_prohibited" {
  title       = "Key vault secrets should not have prohibited tags"
  description = "Check if Key vault secrets have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_key_vault_secret")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "kubernetes_cluster_prohibited" {
  title       = "Kubernetes clusters should not have prohibited tags"
  description = "Check if Kubernetes clusters have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_kubernetes_cluster")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "lb_prohibited" {
  title       = "Load balancers should not have prohibited tags"
  description = "Check if Load balancers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_lb")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "log_alert_prohibited" {
  title       = "Log alerts should not have prohibited tags"
  description = "Check if Log alerts have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_log_alert")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "log_profile_prohibited" {
  title       = "Log profiles should not have prohibited tags"
  description = "Check if Log profiles have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_log_profile")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "logic_app_workflow_prohibited" {
  title       = "Logic app workflows should not have prohibited tags"
  description = "Check if Logic app workflows have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_logic_app_workflow")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "mariadb_server_prohibited" {
  title       = "MariaDB servers should not have prohibited tags"
  description = "Check if MariaDB servers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_mariadb_server")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "mssql_elasticpool_prohibited" {
  title       = "Mssql elasticpools should not have prohibited tags"
  description = "Check if Mssql elasticpools have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_mssql_elasticpool")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "mssql_managed_instance_prohibited" {
  title       = "Microsoft SQL managed instances should not have prohibited tags"
  description = "Check if Microsoft SQL managed instances have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_mssql_managed_instance")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "mysql_server_prohibited" {
  title       = "MySQL servers should not have prohibited tags"
  description = "Check if MySQL servers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_mysql_server")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "network_interface_prohibited" {
  title       = "Network interfaces should not have prohibited tags"
  description = "Check if Network interfaces have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_network_interface")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "network_security_group_prohibited" {
  title       = "Network security groups should not have prohibited tags"
  description = "Check if Network security groups have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_network_security_group")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "network_watcher_prohibited" {
  title       = "Network watchers should not have prohibited tags"
  description = "Check if Network watchers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_network_watcher")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "network_watcher_flow_log_prohibited" {
  title       = "Network watcher flow logs should not have prohibited tags"
  description = "Check if Network watcher flow logs have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_network_watcher_flow_log")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "postgresql_server_prohibited" {
  title       = "PostgreSQL servers should not have prohibited tags"
  description = "Check if PostgreSQL servers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_postgresql_server")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "public_ip_prohibited" {
  title       = "Public IPs should not have prohibited tags"
  description = "Check if Public IPs have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_public_ip")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "recovery_services_vault_prohibited" {
  title       = "Recovery services vaults should not have prohibited tags"
  description = "Check if Recovery services vaults have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_recovery_services_vault")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "redis_cache_prohibited" {
  title       = "Redis caches should not have prohibited tags"
  description = "Check if Redis caches have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_redis_cache")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "resource_group_prohibited" {
  title       = "Resource groups should not have prohibited tags"
  description = "Check if Resource groups have any prohibited tags."
  sql         = <<-EOQ
      with analysis as (
      select
        id,
        array_agg(k) as prohibited_tags,
        _ctx,
        name,
        subscription_id,
        region
      from
        azure_resource_group,
        jsonb_object_keys(tags) as k,
        unnest($1::text[]) as prohibited_key
      where
        k = prohibited_key
      group by
        id,
        _ctx,
        name,
        subscription_id,
        region
    )
    select
      r.id as resource,
      case
        when a.prohibited_tags <> array[]::text[] then 'alarm'
        else 'ok'
      end as status,
      case
        when a.prohibited_tags <> array[]::text[] then r.title || ' has prohibited tags: ' || array_to_string(a.prohibited_tags, ', ') || '.'
        else r.title || ' has no prohibited tags.'
      end as reason,
      r._ctx,
      r.name,
      r.subscription_id,
      r.region      
    from
      azure_resource_group as r
    full outer join
      analysis as a on a.id = r.id;
  EOQ
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "route_table_prohibited" {
  title       = "Route tables should not have prohibited tags"
  description = "Check if Route tables have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_route_table")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "search_service_prohibited" {
  title       = "Search services should not have prohibited tags"
  description = "Check if Search services have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_search_service")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "servicebus_namespace_prohibited" {
  title       = "Service Bus namespaces should not have prohibited tags"
  description = "Check if Servicebus namespaces have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_servicebus_namespace")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "sql_database_prohibited" {
  title       = "SQL databases should not have prohibited tags"
  description = "Check if SQL databases have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_sql_database")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "sql_server_prohibited" {
  title       = "Sql servers should not have prohibited tags"
  description = "Check if Sql servers have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_sql_server")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "storage_account_prohibited" {
  title       = "Storage accounts should not have prohibited tags"
  description = "Check if Storage accounts have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_storage_account")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "stream_analytics_job_prohibited" {
  title       = "Stream Analytics jobs should not have prohibited tags"
  description = "Check if Stream Analytics jobs have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_stream_analytics_job")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "virtual_network_prohibited" {
  title       = "Virtual networks should not have prohibited tags"
  description = "Check if Virtual networks have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_virtual_network")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "virtual_network_gateway_prohibited" {
  title       = "Virtual network gateways should not have prohibited tags"
  description = "Check if Virtual network gateways have any prohibited tags."
  sql         = replace(local.prohibited_sql, "__TABLE_NAME__", "azure_virtual_network_gateway")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}
