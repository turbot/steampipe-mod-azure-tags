variable "tag_limit" {
  type        = number
  description = "Number of tags allowed on a resource. Azure allows up to 50 tags per resource."
  default     = 45
}

locals {
  limit_sql = <<-EOQ
    with analysis as (
      select
        id,
        title,
        cardinality(array(select jsonb_object_keys(tags))) as num_tag_keys,
        _ctx,
        tags,
        resource_group,
        subscription_id,
        region
      from
        __TABLE_NAME__
    )
    select
      id as resource,
      case
        when num_tag_keys > $1::integer then 'alarm'
        else 'ok'
      end as status,
      title || ' has ' || num_tag_keys || ' tag(s).' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      analysis;
  EOQ
}

benchmark "limit" {
  title       = "Limit"
  description = "The number of tags on each resource should be monitored to avoid hitting the limit unexpectedly."
  children = [
    control.api_management_tag_limit,
    control.app_service_environment_tag_limit,
    control.app_service_function_app_tag_limit,
    control.app_service_plan_tag_limit,
    control.app_service_web_app_tag_limit,
    control.application_security_group_tag_limit,
    control.batch_account_tag_limit,
    control.compute_availability_set_tag_limit,
    control.compute_disk_encryption_set_tag_limit,
    control.compute_disk_tag_limit,
    control.compute_image_tag_limit,
    control.compute_snapshot_tag_limit,
    control.compute_virtual_machine_scale_set_tag_limit,
    control.compute_virtual_machine_tag_limit,
    control.container_registry_tag_limit,
    control.cosmosdb_account_tag_limit,
    control.cosmosdb_mongo_database_tag_limit,
    control.cosmosdb_sql_database_tag_limit,
    control.data_factory_tag_limit,
    control.data_lake_analytics_account_tag_limit,
    control.data_lake_store_tag_limit,
    control.eventhub_namespace_tag_limit,
    control.express_route_circuit_tag_limit,
    control.firewall_tag_limit,
    control.iothub_tag_limit,
    control.key_vault_deleted_vault_tag_limit,
    control.key_vault_key_tag_limit,
    control.key_vault_managed_hardware_security_module_tag_limit,
    control.key_vault_secret_tag_limit,
    control.key_vault_tag_limit,
    control.kubernetes_cluster_tag_limit,
    control.lb_tag_limit,
    control.log_alert_tag_limit,
    control.log_profile_tag_limit,
    control.logic_app_workflow_tag_limit,
    control.mariadb_server_tag_limit,
    control.mssql_elasticpool_tag_limit,
    control.mssql_managed_instance_tag_limit,
    control.mysql_server_tag_limit,
    control.network_interface_tag_limit,
    control.network_security_group_tag_limit,
    control.network_watcher_flow_log_tag_limit,
    control.network_watcher_tag_limit,
    control.postgresql_server_tag_limit,
    control.public_ip_tag_limit,
    control.recovery_services_vault_tag_limit,
    control.redis_cache_tag_limit,
    control.resource_group_tag_limit,
    control.route_table_tag_limit,
    control.search_service_tag_limit,
    control.servicebus_namespace_tag_limit,
    control.sql_database_tag_limit,
    control.sql_server_tag_limit,
    control.storage_account_tag_limit,
    control.stream_analytics_job_tag_limit,
    control.virtual_network_gateway_tag_limit,
    control.virtual_network_tag_limit
  ]

  tags = merge(local.azure_tags_common_tags, {
    type = "Benchmark"
  })
}

control "api_management_tag_limit" {
  title       = "API Management services should not exceed tag limit"
  description = "Check if the number of tags on API Management services do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_api_management")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "app_service_environment_tag_limit" {
  title       = "App Service environments should not exceed tag limit"
  description = "Check if the number of tags on App Service environments do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_app_service_environment")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "app_service_function_app_tag_limit" {
  title       = "App Service function apps should not exceed tag limit"
  description = "Check if the number of tags on App Service function apps do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_app_service_function_app")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "app_service_plan_tag_limit" {
  title       = "App Service plans should not exceed tag limit"
  description = "Check if the number of tags on App Service plans do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_app_service_plan")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "app_service_web_app_tag_limit" {
  title       = "App Service web apps should not exceed tag limit"
  description = "Check if the number of tags on App Service web apps do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_app_service_web_app")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "application_security_group_tag_limit" {
  title       = "Application security groups should not exceed tag limit"
  description = "Check if the number of tags on Application security groups do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_application_security_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "batch_account_tag_limit" {
  title       = "Batch accounts should not exceed tag limit"
  description = "Check if the number of tags on Batch accounts do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_batch_account")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "compute_availability_set_tag_limit" {
  title       = "Compute availability sets should not exceed tag limit"
  description = "Check if the number of tags on Compute availability sets do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_compute_availability_set")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "compute_disk_tag_limit" {
  title       = "Compute disks should not exceed tag limit"
  description = "Check if the number of tags on Compute disks do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_compute_disk")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "compute_disk_encryption_set_tag_limit" {
  title       = "Compute disk encryption sets should not exceed tag limit"
  description = "Check if the number of tags on Compute disk encryption sets do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_compute_disk_encryption_set")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "compute_image_tag_limit" {
  title       = "Compute images should not exceed tag limit"
  description = "Check if the number of tags on Compute images do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_compute_image")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "compute_snapshot_tag_limit" {
  title       = "Compute snapshots should not exceed tag limit"
  description = "Check if the number of tags on Compute snapshots do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_compute_snapshot")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "compute_virtual_machine_tag_limit" {
  title       = "Compute virtual machines should not exceed tag limit"
  description = "Check if the number of tags on Compute virtual machines do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_compute_virtual_machine")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "compute_virtual_machine_scale_set_tag_limit" {
  title       = "Compute virtual machine scale sets should not exceed tag limit"
  description = "Check if the number of tags on Compute virtual machine scale sets do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_compute_virtual_machine_scale_set")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "container_registry_tag_limit" {
  title       = "Container registries should not exceed tag limit"
  description = "Check if the number of tags on Container registries do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_container_registry")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cosmosdb_account_tag_limit" {
  title       = "CosmosDB accounts should not exceed tag limit"
  description = "Check if the number of tags on CosmosDB accounts do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_cosmosdb_account")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cosmosdb_mongo_database_tag_limit" {
  title       = "CosmosDB mongo databases should not exceed tag limit"
  description = "Check if the number of tags on CosmosDB mongo databases do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_cosmosdb_mongo_database")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "cosmosdb_sql_database_tag_limit" {
  title       = "CosmosDB sql databases should not exceed tag limit"
  description = "Check if the number of tags on CosmosDB sql databases do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_cosmosdb_sql_database")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "data_factory_tag_limit" {
  title       = "Data factories should not exceed tag limit"
  description = "Check if the number of tags on Data factories do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_data_factory")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "data_lake_analytics_account_tag_limit" {
  title       = "Data Lake analytics accounts should not exceed tag limit"
  description = "Check if the number of tags on Data Lake analytics accounts do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_data_lake_analytics_account")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "data_lake_store_tag_limit" {
  title       = "Data Lake stores should not exceed tag limit"
  description = "Check if the number of tags on Data Lake stores do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_data_lake_store")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "eventhub_namespace_tag_limit" {
  title       = "Event Hub namespaces should not exceed tag limit"
  description = "Check if the number of tags on Event Hub namespaces do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_eventhub_namespace")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "express_route_circuit_tag_limit" {
  title       = "ExpressRoute circuits should not exceed tag limit"
  description = "Check if the number of tags on ExpressRoute circuits do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_express_route_circuit")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "firewall_tag_limit" {
  title       = "Firewalls should not exceed tag limit"
  description = "Check if the number of tags on Firewalls do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_firewall")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "iothub_tag_limit" {
  title       = "IoT Hubs should not exceed tag limit"
  description = "Check if the number of tags on IoT Hubs do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_iothub")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "key_vault_tag_limit" {
  title       = "Key vaults should not exceed tag limit"
  description = "Check if the number of tags on Key vaults do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_key_vault")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "key_vault_deleted_vault_tag_limit" {
  title       = "Key vault deleted vaults should not exceed tag limit"
  description = "Check if the number of tags on Key vault deleted vaults do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_key_vault_deleted_vault")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "key_vault_key_tag_limit" {
  title       = "Key vault keys should not exceed tag limit"
  description = "Check if the number of tags on Key vault keys do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_key_vault_key")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "key_vault_managed_hardware_security_module_tag_limit" {
  title       = "Key vault managed hardware security modules should not exceed tag limit"
  description = "Check if the number of tags on Key vault managed hardware security modules do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_key_vault_managed_hardware_security_module")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "key_vault_secret_tag_limit" {
  title       = "Key vault secrets should not exceed tag limit"
  description = "Check if the number of tags on Key vault secrets do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_key_vault_secret")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "kubernetes_cluster_tag_limit" {
  title       = "Kubernetes clusters should not exceed tag limit"
  description = "Check if the number of tags on Kubernetes clusters do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_kubernetes_cluster")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "lb_tag_limit" {
  title       = "Load balancers should not exceed tag limit"
  description = "Check if the number of tags on Load balancers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_lb")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "log_alert_tag_limit" {
  title       = "Log alerts should not exceed tag limit"
  description = "Check if the number of tags on Log alerts do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_log_alert")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "log_profile_tag_limit" {
  title       = "Log profiles should not exceed tag limit"
  description = "Check if the number of tags on Log profiles do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_log_profile")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "logic_app_workflow_tag_limit" {
  title       = "Logic app workflows should not exceed tag limit"
  description = "Check if the number of tags on Logic app workflows do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_logic_app_workflow")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mariadb_server_tag_limit" {
  title       = "MariaDB servers should not exceed tag limit"
  description = "Check if the number of tags on MariaDB servers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_mariadb_server")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mssql_elasticpool_tag_limit" {
  title       = "Microsoft SQL elasticpools should not exceed tag limit"
  description = "Check if the number of tags on Microsoft SQL elasticpools do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_mssql_elasticpool")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mssql_managed_instance_tag_limit" {
  title       = "Microsoft SQL managed instances should not exceed tag limit"
  description = "Check if the number of tags on Microsoft SQL managed instances do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_mssql_managed_instance")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "mysql_server_tag_limit" {
  title       = "MySQL servers should not exceed tag limit"
  description = "Check if the number of tags on MySQL servers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_mysql_server")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "network_interface_tag_limit" {
  title       = "Network interfaces should not exceed tag limit"
  description = "Check if the number of tags on Network interfaces do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_network_interface")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "network_security_group_tag_limit" {
  title       = "Network security groups should not exceed tag limit"
  description = "Check if the number of tags on Network security groups do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_network_security_group")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "network_watcher_tag_limit" {
  title       = "Network watchers should not exceed tag limit"
  description = "Check if the number of tags on Network watchers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_network_watcher")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "network_watcher_flow_log_tag_limit" {
  title       = "Network watcher flow logs should not exceed tag limit"
  description = "Check if the number of tags on Network watcher flow logs do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_network_watcher_flow_log")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "postgresql_server_tag_limit" {
  title       = "PostgreSQL servers should not exceed tag limit"
  description = "Check if the number of tags on PostgreSQL servers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_postgresql_server")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "public_ip_tag_limit" {
  title       = "Public IPs should not exceed tag limit"
  description = "Check if the number of tags on Public ips do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_public_ip")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "recovery_services_vault_tag_limit" {
  title       = "Recovery services vaults should not exceed tag limit"
  description = "Check if the number of tags on Recovery services vaults do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_recovery_services_vault")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "redis_cache_tag_limit" {
  title       = "Redis caches should not exceed tag limit"
  description = "Check if the number of tags on Redis caches do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_redis_cache")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "resource_group_tag_limit" {
  title       = "Resource groups should not exceed tag limit"
  description = "Check if the number of tags on Resource groups do not exceed the limit."
  sql         = <<-EOQ
    with analysis as (
      select
        id,
        title,
        cardinality(array(select jsonb_object_keys(tags))) as num_tag_keys,
        _ctx,
        name,
        tags,
        subscription_id,
        region
      from
        azure_resource_group
    )
    select
      id as resource,
      case
        when num_tag_keys > $1::integer then 'alarm'
        else 'ok'
      end as status,
      title || ' has ' || num_tag_keys || ' tag(s).' as reason,
      _ctx,
      name,
      subscription_id,
      region
    from
      analysis;
  EOQ

  param "tag_limit" {
    default = var.tag_limit
  }
}

control "route_table_tag_limit" {
  title       = "Route tables should not exceed tag limit"
  description = "Check if the number of tags on Route tables do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_route_table")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "search_service_tag_limit" {
  title       = "Search services should not exceed tag limit"
  description = "Check if the number of tags on Search services do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_search_service")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "servicebus_namespace_tag_limit" {
  title       = "Service Bus namespaces should not exceed tag limit"
  description = "Check if the number of tags on Service Bus namespaces do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_servicebus_namespace")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "sql_database_tag_limit" {
  title       = "SQL databases should not exceed tag limit"
  description = "Check if the number of tags on SQL databases do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_sql_database")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "sql_server_tag_limit" {
  title       = "SQL servers should not exceed tag limit"
  description = "Check if the number of tags on SQL servers do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_sql_server")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "storage_account_tag_limit" {
  title       = "Storage accounts should not exceed tag limit"
  description = "Check if the number of tags on Storage accounts do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_storage_account")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "stream_analytics_job_tag_limit" {
  title       = "Stream Analytics jobs should not exceed tag limit"
  description = "Check if the number of tags on Stream Analytics jobs do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_stream_analytics_job")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "virtual_network_tag_limit" {
  title       = "Virtual networks should not exceed tag limit"
  description = "Check if the number of tags on Virtual networks do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_virtual_network")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "virtual_network_gateway_tag_limit" {
  title       = "Virtual network gateways should not exceed tag limit"
  description = "Check if the number of tags on Virtual network gateways do not exceed the limit."
  sql         = replace(local.limit_sql, "__TABLE_NAME__", "azure_virtual_network_gateway")
  param "tag_limit" {
    default = var.tag_limit
  }
}
