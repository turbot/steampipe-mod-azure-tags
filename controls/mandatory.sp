locals {
  mandatory_sql = <<-EOQ
    with analysis as (
      select
        id,
        title,
        tags ?& $1 as has_mandatory_tags,
        to_jsonb($1) - array(select jsonb_object_keys(tags)) as missing_tags,
        __DIMENSIONS__
      from
        __TABLE_NAME__
    )
    select
      id as resource,
      case
        when has_mandatory_tags then 'ok'
        else 'alarm'
      end as status,
      case
        when has_mandatory_tags then title || ' has all mandatory tags.'
        else title || ' is missing tags: ' || array_to_string(array(select jsonb_array_elements_text(missing_tags)), ', ') || '.'
      end as reason,
      __DIMENSIONS__
    from
      analysis;
  EOQ
}

locals {
  mandatory_sql_subscription   = replace(local.mandatory_sql, "__DIMENSIONS__", "subscription_id")
  mandatory_sql_resource_group = replace(local.mandatory_sql, "__DIMENSIONS__", "resource_group, subscription_id")
}

benchmark "mandatory" {
  title       = "Mandatory"
  description = "Resources should all have a standard set of tags applied for functions like resource organization, automation, cost control, and access control."
  children = [
    control.api_management_mandatory,
    control.app_service_environment_mandatory,
    control.app_service_function_app_mandatory,
    control.app_service_plan_mandatory,
    control.app_service_web_app_mandatory,
    control.application_security_group_mandatory,
    control.batch_account_mandatory,
    control.compute_availability_set_mandatory,
    control.compute_disk_encryption_set_mandatory,
    control.compute_disk_mandatory,
    control.compute_image_mandatory,
    control.compute_snapshot_mandatory,
    control.compute_virtual_machine_mandatory,
    control.compute_virtual_machine_scale_set_mandatory,
    control.container_registry_mandatory,
    control.cosmosdb_account_mandatory,
    control.cosmosdb_mongo_database_mandatory,
    control.cosmosdb_sql_database_mandatory,
    control.data_factory_mandatory,
    control.data_lake_analytics_account_mandatory,
    control.data_lake_store_mandatory,
    control.eventhub_namespace_mandatory,
    control.express_route_circuit_mandatory,
    control.firewall_mandatory,
    control.iothub_mandatory,
    control.key_vault_deleted_vault_mandatory,
    control.key_vault_key_mandatory,
    control.key_vault_managed_hardware_security_module_mandatory,
    control.key_vault_mandatory,
    control.key_vault_secret_mandatory,
    control.kubernetes_cluster_mandatory,
    control.lb_mandatory,
    control.log_alert_mandatory,
    control.log_profile_mandatory,
    control.logic_app_workflow_mandatory,
    control.mariadb_server_mandatory,
    control.mssql_elasticpool_mandatory,
    control.mssql_managed_instance_mandatory,
    control.mysql_server_mandatory,
    control.network_interface_mandatory,
    control.network_security_group_mandatory,
    control.network_watcher_flow_log_mandatory,
    control.network_watcher_mandatory,
    control.postgresql_server_mandatory,
    control.public_ip_mandatory,
    control.recovery_services_vault_mandatory,
    control.redis_cache_mandatory,
    control.resource_group_mandatory,
    control.route_table_mandatory,
    control.search_service_mandatory,
    control.servicebus_namespace_mandatory,
    control.sql_database_mandatory,
    control.sql_server_mandatory,
    control.storage_account_mandatory,
    control.stream_analytics_job_mandatory,
    control.virtual_network_gateway_mandatory,
    control.virtual_network_mandatory
  ]

  tags = merge(local.azure_tags_common_tags, {
    type = "Benchmark"
  })
}

control "api_management_mandatory" {
  title       = "API Management services should have mandatory tags"
  description = "Check if API Management services have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_api_management")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "app_service_environment_mandatory" {
  title       = "App Service environments should have mandatory tags"
  description = "Check if App Service environments have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_app_service_environment")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "app_service_function_app_mandatory" {
  title       = "App Service function apps should have mandatory tags"
  description = "Check if App Service function apps have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_app_service_function_app")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "app_service_plan_mandatory" {
  title       = "App Service plans should have mandatory tags"
  description = "Check if App Service plans have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_app_service_plan")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "app_service_web_app_mandatory" {
  title       = "App Service web apps should have mandatory tags"
  description = "Check if App Service web apps have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_app_service_web_app")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "application_security_group_mandatory" {
  title       = "Application security groups should have mandatory tags"
  description = "Check if Application security groups have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_application_security_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "batch_account_mandatory" {
  title       = "Batch accounts should have mandatory tags"
  description = "Check if Batch accounts have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_batch_account")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "compute_availability_set_mandatory" {
  title       = "Compute availability sets should have mandatory tags"
  description = "Check if Compute availability sets have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_compute_availability_set")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "compute_disk_mandatory" {
  title       = "Compute disks should have mandatory tags"
  description = "Check if Compute disks have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_compute_disk")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "compute_disk_encryption_set_mandatory" {
  title       = "Compute disk encryption sets should have mandatory tags"
  description = "Check if Compute disk encryption sets have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_compute_disk_encryption_set")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "compute_image_mandatory" {
  title       = "Compute images should have mandatory tags"
  description = "Check if Compute images have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_compute_image")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "compute_snapshot_mandatory" {
  title       = "Compute snapshots should have mandatory tags"
  description = "Check if Compute snapshots have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_compute_snapshot")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "compute_virtual_machine_mandatory" {
  title       = "Compute virtual machines should have mandatory tags"
  description = "Check if Compute virtual machines have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_compute_virtual_machine")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "compute_virtual_machine_scale_set_mandatory" {
  title       = "Compute virtual machine scale sets should have mandatory tags"
  description = "Check if Compute virtual machine scale sets have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_compute_virtual_machine_scale_set")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "container_registry_mandatory" {
  title       = "Container registries should have mandatory tags"
  description = "Check if Container registries have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_container_registry")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cosmosdb_account_mandatory" {
  title       = "CosmosDB accounts should have mandatory tags"
  description = "Check if CosmosDB accounts have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_cosmosdb_account")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cosmosdb_mongo_database_mandatory" {
  title       = "CosmosDB mongo databases should have mandatory tags"
  description = "Check if CosmosDB mongo databases have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_cosmosdb_mongo_database")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "cosmosdb_sql_database_mandatory" {
  title       = "CosmosDB sql databases should have mandatory tags"
  description = "Check if CosmosDB sql databases have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_cosmosdb_sql_database")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "data_factory_mandatory" {
  title       = "Data factories should have mandatory tags"
  description = "Check if Data factories have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_data_factory")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "data_lake_analytics_account_mandatory" {
  title       = "Data lake analytics accounts should have mandatory tags"
  description = "Check if Data lake analytics accounts have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_data_lake_analytics_account")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "data_lake_store_mandatory" {
  title       = "Data lake stores should have mandatory tags"
  description = "Check if Data lake stores have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_data_lake_store")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "eventhub_namespace_mandatory" {
  title       = "Event Hub namespaces should have mandatory tags"
  description = "Check if Event Hub namespaces have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_eventhub_namespace")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "express_route_circuit_mandatory" {
  title       = "ExpressRoute circuits should have mandatory tags"
  description = "Check if ExpressRoute circuits have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_express_route_circuit")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "firewall_mandatory" {
  title       = "Firewalls should have mandatory tags"
  description = "Check if Firewalls have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_firewall")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "iothub_mandatory" {
  title       = "IoT Hubs should have mandatory tags"
  description = "Check if IoT Hubs have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_iothub")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "key_vault_mandatory" {
  title       = "Key vaults should have mandatory tags"
  description = "Check if Key vaults have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_key_vault")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "key_vault_deleted_vault_mandatory" {
  title       = "Key vault deleted vaults should have mandatory tags"
  description = "Check if Key vault deleted vaults have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_deleted_vault")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "key_vault_key_mandatory" {
  title       = "Key vault keys should have mandatory tags"
  description = "Check if Key vault keys have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_key")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "key_vault_managed_hardware_security_module_mandatory" {
  title       = "Key vault managed hardware security modules should have mandatory tags"
  description = "Check if Key vault managed hardware security modules have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_managed_hardware_security_module")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "key_vault_secret_mandatory" {
  title       = "Key vault secrets should have mandatory tags"
  description = "Check if Key vault secrets have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_secret")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "kubernetes_cluster_mandatory" {
  title       = "Kubernetes clusters should have mandatory tags"
  description = "Check if Kubernetes clusters have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_kubernetes_cluster")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "lb_mandatory" {
  title       = "Load balancers should have mandatory tags"
  description = "Check if Load balancers have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_lb")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "log_alert_mandatory" {
  title       = "Log alerts should have mandatory tags"
  description = "Check if Log alerts have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_log_alert")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "log_profile_mandatory" {
  title       = "Log profiles should have mandatory tags"
  description = "Check if Log profiles have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_log_profile")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "logic_app_workflow_mandatory" {
  title       = "Logic app workflows should have mandatory tags"
  description = "Check if Logic app workflows have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_logic_app_workflow")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "mariadb_server_mandatory" {
  title       = "MariaDB servers should have mandatory tags"
  description = "Check if MariaDB servers have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_mariadb_server")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "mssql_elasticpool_mandatory" {
  title       = "Microsoft SQL elasticpools should have mandatory tags"
  description = "Check if Microsoft SQL elasticpools have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_mssql_elasticpool")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "mssql_managed_instance_mandatory" {
  title       = "Microsoft SQL managed instances should have mandatory tags"
  description = "Check if Microsoft SQL managed instances have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_mssql_managed_instance")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "mysql_server_mandatory" {
  title       = "MySQL servers should have mandatory tags"
  description = "Check if MySQL servers have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_mysql_server")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "network_interface_mandatory" {
  title       = "Network interfaces should have mandatory tags"
  description = "Check if Network interfaces have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_network_interface")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "network_security_group_mandatory" {
  title       = "Network security groups should have mandatory tags"
  description = "Check if Network security groups have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_network_security_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "network_watcher_mandatory" {
  title       = "Network watchers should have mandatory tags"
  description = "Check if Network watchers have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_network_watcher")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "network_watcher_flow_log_mandatory" {
  title       = "Network watcher flow logs should have mandatory tags"
  description = "Check if Network watcher flow logs have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_network_watcher_flow_log")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "postgresql_server_mandatory" {
  title       = "PostgreSQL servers should have mandatory tags"
  description = "Check if PostgreSQL servers have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_postgresql_server")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "public_ip_mandatory" {
  title       = "Public IPs should have mandatory tags"
  description = "Check if Public ips have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_public_ip")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "recovery_services_vault_mandatory" {
  title       = "Recovery services vaults should have mandatory tags"
  description = "Check if Recovery services vaults have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_recovery_services_vault")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "redis_cache_mandatory" {
  title       = "Redis caches should have mandatory tags"
  description = "Check if Redis caches have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_redis_cache")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "resource_group_mandatory" {
  title       = "Resource groups should have mandatory tags"
  description = "Check if Resource groups have mandatory tags."
  sql         = replace(local.mandatory_sql_subscription, "__TABLE_NAME__", "azure_resource_group")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "route_table_mandatory" {
  title       = "Route tables should have mandatory tags"
  description = "Check if Route tables have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_route_table")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "search_service_mandatory" {
  title       = "Search services should have mandatory tags"
  description = "Check if Search services have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_search_service")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "servicebus_namespace_mandatory" {
  title       = "Service Bus namespaces should have mandatory tags"
  description = "Check if Service Bus  namespaces have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_servicebus_namespace")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "sql_database_mandatory" {
  title       = "SQL databases should have mandatory tags"
  description = "Check if SQL databases have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_sql_database")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "sql_server_mandatory" {
  title       = "SQL servers should have mandatory tags"
  description = "Check if SQL servers have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_sql_server")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "storage_account_mandatory" {
  title       = "Storage accounts should have mandatory tags"
  description = "Check if Storage accounts have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_storage_account")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "stream_analytics_job_mandatory" {
  title       = "Stream Analytics jobs should have mandatory tags"
  description = "Check if Stream Analytics jobs have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_stream_analytics_job")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "virtual_network_mandatory" {
  title       = "Virtual networks should have mandatory tags"
  description = "Check if Virtual networks have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_virtual_network")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "virtual_network_gateway_mandatory" {
  title       = "Virtual network gateways should have mandatory tags"
  description = "Check if Virtual network gateways have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_virtual_network_gateway")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

