variable "expected_tag_values" {
  type        = map(list(string))
  description = "Map of expected values for various tags, e.g., {\"Environment\": [\"Prod\", \"Staging\", \"Dev%\"]}. SQL wildcards '%' and '_' can be used for matching values. These characters must be escaped for exact matches, e.g., {\"created_by\": [\"test\\_user\"]}."

  default = {
    "Environment": ["Dev", "Staging", "Prod"]
  }
}

locals {
  expected_tag_values_sql = <<-EOQ
    with raw_data as
    (
      select
        id,
        title,
        tags,
        row_to_json(json_each($1)) as expected_tag_values,
        __DIMENSIONS__
      from
        __TABLE_NAME__
      where
        tags::text <> '{}'
    ),
    exploded_expected_tag_values as
    (
      select
        id,
        title,
        expected_tag_values ->> 'key' as tag_key,
        jsonb_array_elements_text((expected_tag_values ->> 'value')::jsonb) as expected_values,
        tags ->> (expected_tag_values ->> 'key') as current_value,
        __DIMENSIONS__
      from
        raw_data
    ),
    analysis as
    (
      select
        id,
        title,
        current_value like expected_values as has_appropriate_value,
        case
          when current_value is null then true
          else false
        end as has_no_matching_tags,
        tag_key,
        current_value,
        __DIMENSIONS__
      from
        exploded_expected_tag_values
    ),
    status_by_tag as
    (
      select
        id,
        title,
        bool_or(has_appropriate_value) as status,
        tag_key,
        case
          when bool_or(has_appropriate_value) then ''
          else tag_key
        end as reason,
        bool_or(has_no_matching_tags) as can_skip,
        current_value,
        __DIMENSIONS__
      from
        analysis
      group by
        id,
        title,
        tag_key,
        current_value,
        __DIMENSIONS__
    )
    select
      id as resource,
      case
        when bool_and(can_skip) then 'skip'
        when bool_and(status) then 'ok'
        else 'alarm'
      end as status,
      case
        when bool_and(can_skip) then title || ' has no matching tag keys.'
        when bool_and(status) then title || ' has expected tag values for tags: ' || array_to_string(array_agg(tag_key) filter(where status), ', ') || '.'
        else title || ' has unexpected tag values for tags: ' || array_to_string(array_agg(tag_key) filter(where not status), ', ') || '.'
      end as reason,
      __DIMENSIONS__
    from
      status_by_tag
    group by
      id,
      title,
      __DIMENSIONS__
    union all
    select
      id as resource,
      'skip' as status,
      title || ' has no tags.' as reason,
      __DIMENSIONS__
    from
      __TABLE_NAME__
    where
      tags::text = '{}'
    union all
    select
      id as resource,
      'skip' as status,
      title || ' has tags but no expected tag values are set.' as reason,
      __DIMENSIONS__
    from
      __TABLE_NAME__
    where
      $1::text = '{}'
      and tags::text <> '{}'
  EOQ
}

locals {
  expected_tag_values_sql_subscription   = replace(local.expected_tag_values_sql, "__DIMENSIONS__", "subscription_id")
  expected_tag_values_sql_resource_group = replace(local.expected_tag_values_sql, "__DIMENSIONS__", "resource_group, subscription_id")
}

benchmark "expected_tag_values" {
  title       = "Expected Tag Values"
  description = "Resources should have specific values for some tags."
  children = [
    control.api_management_expected_tag_values,
    control.app_service_environment_expected_tag_values,
    control.app_service_function_app_expected_tag_values,
    control.app_service_plan_expected_tag_values,
    control.app_service_web_app_expected_tag_values,
    control.application_security_group_expected_tag_values,
    control.batch_account_expected_tag_values,
    control.compute_availability_set_expected_tag_values,
    control.compute_disk_expected_tag_values,
    control.compute_disk_encryption_set_expected_tag_values,
    control.compute_image_expected_tag_values,
    control.compute_snapshot_expected_tag_values,
    control.compute_virtual_machine_expected_tag_values,
    control.compute_virtual_machine_scale_set_expected_tag_values,
    control.container_registry_expected_tag_values,
    control.cosmosdb_account_expected_tag_values,
    control.cosmosdb_mongo_database_expected_tag_values,
    control.cosmosdb_sql_database_expected_tag_values,
    control.data_factory_expected_tag_values,
    control.data_lake_analytics_account_expected_tag_values,
    control.data_lake_store_expected_tag_values,
    control.eventhub_namespace_expected_tag_values,
    control.express_route_circuit_expected_tag_values,
    control.firewall_expected_tag_values,
    control.iothub_expected_tag_values,
    control.key_vault_expected_tag_values,
    control.key_vault_deleted_vault_expected_tag_values,
    control.key_vault_key_expected_tag_values,
    control.key_vault_managed_hardware_security_module_expected_tag_values,
    control.key_vault_secret_expected_tag_values,
    control.kubernetes_cluster_expected_tag_values,
    control.lb_expected_tag_values,
    control.log_alert_expected_tag_values,
    control.log_profile_expected_tag_values,
    control.logic_app_workflow_expected_tag_values,
    control.mariadb_server_expected_tag_values,
    control.mssql_elasticpool_expected_tag_values,
    control.mssql_managed_instance_expected_tag_values,
    control.mysql_server_expected_tag_values,
    control.network_interface_expected_tag_values,
    control.network_security_group_expected_tag_values,
    control.network_watcher_expected_tag_values,
    control.network_watcher_flow_log_expected_tag_values,
    control.postgresql_server_expected_tag_values,
    control.public_ip_expected_tag_values,
    control.recovery_services_vault_expected_tag_values,
    control.redis_cache_expected_tag_values,
    control.resource_group_expected_tag_values,
    control.route_table_expected_tag_values,
    control.search_service_expected_tag_values,
    control.servicebus_namespace_expected_tag_values,
    control.sql_database_expected_tag_values,
    control.sql_server_expected_tag_values,
    control.storage_account_expected_tag_values,
    control.stream_analytics_job_expected_tag_values,
    control.virtual_network_expected_tag_values,
    control.virtual_network_gateway_expected_tag_values
  ]

  tags = merge(local.azure_tags_common_tags, {
    type = "Benchmark"
  })
}

control "api_management_expected_tag_values" {
  title       = "API Management services should have appropriate tag values"
  description = "Check if API Management services have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_api_management")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "app_service_environment_expected_tag_values" {
  title       = "App Service environments should have appropriate tag values"
  description = "Check if App Service environments have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_app_service_environment")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "app_service_function_app_expected_tag_values" {
  title       = "App Service function apps should have appropriate tag values"
  description = "Check if App Service function apps have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_app_service_function_app")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "app_service_plan_expected_tag_values" {
  title       = "App Service plans should have appropriate tag values"
  description = "Check if App Service plans have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_app_service_plan")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "app_service_web_app_expected_tag_values" {
  title       = "App Service web apps should have appropriate tag values"
  description = "Check if App Service web apps have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_app_service_web_app")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "application_security_group_expected_tag_values" {
  title       = "Application security groups should have appropriate tag values"
  description = "Check if Application security groups have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_application_security_group")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "batch_account_expected_tag_values" {
  title       = "Batch accounts should have appropriate tag values"
  description = "Check if Batch accounts have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_batch_account")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "compute_availability_set_expected_tag_values" {
  title       = "Compute availability sets should have appropriate tag values"
  description = "Check if Compute availability sets have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_compute_availability_set")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "compute_disk_expected_tag_values" {
  title       = "Compute disks should have appropriate tag values"
  description = "Check if Compute disks have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_compute_disk")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "compute_disk_encryption_set_expected_tag_values" {
  title       = "Compute disk encryption sets should have appropriate tag values"
  description = "Check if Compute disk encryption sets have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_compute_disk_encryption_set")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "compute_image_expected_tag_values" {
  title       = "Compute images should have appropriate tag values"
  description = "Check if Compute images have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_compute_image")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "compute_snapshot_expected_tag_values" {
  title       = "Compute snapshots should have appropriate tag values"
  description = "Check if Compute snapshots have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_compute_snapshot")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "compute_virtual_machine_expected_tag_values" {
  title       = "Compute virtual machines should have appropriate tag values"
  description = "Check if Compute virtual machines have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_compute_virtual_machine")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "compute_virtual_machine_scale_set_expected_tag_values" {
  title       = "Compute virtual machine scale sets should have appropriate tag values"
  description = "Check if Compute virtual machine scale sets have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_compute_virtual_machine_scale_set")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "container_registry_expected_tag_values" {
  title       = "Container registries should have appropriate tag values"
  description = "Check if Container registries have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_container_registry")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "cosmosdb_account_expected_tag_values" {
  title       = "CosmosDB accounts should have appropriate tag values"
  description = "Check if CosmosDB accounts have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_cosmosdb_account")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "cosmosdb_mongo_database_expected_tag_values" {
  title       = "CosmosDB mongo databases should have appropriate tag values"
  description = "Check if CosmosDB mongo databases have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_cosmosdb_mongo_database")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "cosmosdb_sql_database_expected_tag_values" {
  title       = "CosmosDB sql databases should have appropriate tag values"
  description = "Check if CosmosDB sql databases have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_cosmosdb_sql_database")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "data_factory_expected_tag_values" {
  title       = "Data factories should have appropriate tag values"
  description = "Check if Data factories have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_data_factory")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "data_lake_analytics_account_expected_tag_values" {
  title       = "Data lake analytics accounts should have appropriate tag values"
  description = "Check if Data lake analytics accounts have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_data_lake_analytics_account")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "data_lake_store_expected_tag_values" {
  title       = "Data lake stores should have appropriate tag values"
  description = "Check if Data lake stores have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_data_lake_store")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "eventhub_namespace_expected_tag_values" {
  title       = "Event Hub namespaces should have appropriate tag values"
  description = "Check if Event Hub namespaces have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_eventhub_namespace")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "express_route_circuit_expected_tag_values" {
  title       = "ExpressRoute circuits should have appropriate tag values"
  description = "Check if ExpressRoute circuits have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_express_route_circuit")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "firewall_expected_tag_values" {
  title       = "Firewalls should have appropriate tag values"
  description = "Check if Firewalls have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_firewall")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "iothub_expected_tag_values" {
  title       = "IoT Hubs should have appropriate tag values"
  description = "Check if IoT Hubs have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_iothub")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "key_vault_expected_tag_values" {
  title       = "Key vaults should have appropriate tag values"
  description = "Check if Key vaults have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_key_vault")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "key_vault_deleted_vault_expected_tag_values" {
  title       = "Key vault deleted vaults should have appropriate tag values"
  description = "Check if Key vault deleted vaults have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_deleted_vault")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "key_vault_key_expected_tag_values" {
  title       = "Key vault keys should have appropriate tag values"
  description = "Check if Key vault keys have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_key")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "key_vault_managed_hardware_security_module_expected_tag_values" {
  title       = "Key vault managed hardware security modules should have appropriate tag values"
  description = "Check if Key vault managed hardware security modules have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_managed_hardware_security_module")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "key_vault_secret_expected_tag_values" {
  title       = "Key vault secrets should have appropriate tag values"
  description = "Check if Key vault secrets have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_key_vault_secret")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "kubernetes_cluster_expected_tag_values" {
  title       = "Kubernetes clusters should have appropriate tag values"
  description = "Check if Kubernetes clusters have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_kubernetes_cluster")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "lb_expected_tag_values" {
  title       = "Load balancers should have appropriate tag values"
  description = "Check if Load balancers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_lb")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "log_alert_expected_tag_values" {
  title       = "Log alerts should have appropriate tag values"
  description = "Check if Log alerts have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_log_alert")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "log_profile_expected_tag_values" {
  title       = "Log profiles should have appropriate tag values"
  description = "Check if Log profiles have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_log_profile")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "logic_app_workflow_expected_tag_values" {
  title       = "Logic app workflows should have appropriate tag values"
  description = "Check if Logic app workflows have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_logic_app_workflow")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "mariadb_server_expected_tag_values" {
  title       = "MariaDB servers should have appropriate tag values"
  description = "Check if MariaDB servers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_mariadb_server")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "mssql_elasticpool_expected_tag_values" {
  title       = "Microsoft SQL elasticpools should have appropriate tag values"
  description = "Check if Microsoft SQL elasticpools have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_mssql_elasticpool")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "mssql_managed_instance_expected_tag_values" {
  title       = "Microsoft SQL managed instances should have appropriate tag values"
  description = "Check if Microsoft SQL managed instances have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_mssql_managed_instance")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "mysql_server_expected_tag_values" {
  title       = "MySQL servers should have appropriate tag values"
  description = "Check if MySQL servers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_mysql_server")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "network_interface_expected_tag_values" {
  title       = "Network interfaces should have appropriate tag values"
  description = "Check if Network interfaces have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_network_interface")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "network_security_group_expected_tag_values" {
  title       = "Network security groups should have appropriate tag values"
  description = "Check if Network security groups have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_network_security_group")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "network_watcher_expected_tag_values" {
  title       = "Network watchers should have appropriate tag values"
  description = "Check if Network watchers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_network_watcher")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "network_watcher_flow_log_expected_tag_values" {
  title       = "Network watcher flow logs should have appropriate tag values"
  description = "Check if Network watcher flow logs have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_network_watcher_flow_log")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "postgresql_server_expected_tag_values" {
  title       = "PostgreSQL servers should have appropriate tag values"
  description = "Check if PostgreSQL servers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_postgresql_server")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "public_ip_expected_tag_values" {
  title       = "Public IPs should have appropriate tag values"
  description = "Check if Public ips have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_public_ip")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "recovery_services_vault_expected_tag_values" {
  title       = "Recovery services vaults should have appropriate tag values"
  description = "Check if Recovery services vaults have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_recovery_services_vault")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "redis_cache_expected_tag_values" {
  title       = "Redis caches should have appropriate tag values"
  description = "Check if Redis caches have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_redis_cache")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "resource_group_expected_tag_values" {
  title       = "Resource groups should have appropriate tag values"
  description = "Check if Resource groups have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_subscription, "__TABLE_NAME__", "azure_resource_group")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "route_table_expected_tag_values" {
  title       = "Route tables should have appropriate tag values"
  description = "Check if Route tables have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_route_table")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "search_service_expected_tag_values" {
  title       = "Search services should have appropriate tag values"
  description = "Check if Search services have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_search_service")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "servicebus_namespace_expected_tag_values" {
  title       = "Service Bus namespaces should have appropriate tag values"
  description = "Check if Service Bus  namespaces have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_servicebus_namespace")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "sql_database_expected_tag_values" {
  title       = "SQL databases should have appropriate tag values"
  description = "Check if SQL databases have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_sql_database")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "sql_server_expected_tag_values" {
  title       = "SQL servers should have appropriate tag values"
  description = "Check if SQL servers have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_sql_server")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "storage_account_expected_tag_values" {
  title       = "Storage accounts should have appropriate tag values"
  description = "Check if Storage accounts have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_storage_account")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "stream_analytics_job_expected_tag_values" {
  title       = "Stream Analytics jobs should have appropriate tag values"
  description = "Check if Stream Analytics jobs have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_stream_analytics_job")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "virtual_network_expected_tag_values" {
  title       = "Virtual networks should have appropriate tag values"
  description = "Check if Virtual networks have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_virtual_network")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}

control "virtual_network_gateway_expected_tag_values" {
  title       = "Virtual network gateways should have appropriate tag values"
  description = "Check if Virtual network gateways have appropriate tag values."
  sql         = replace(local.expected_tag_values_sql_resource_group, "__TABLE_NAME__", "azure_virtual_network_gateway")
  param "expected_tag_values" {
    default = var.expected_tag_values
  }
}