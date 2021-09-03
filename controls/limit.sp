variable "tag_limit" {
  type        = number
  description = "Number of tags allowed on a resource. Azure allows up to 50 tags per resource."
}

locals {
  limit_sql = <<EOT
    with analysis as (
      select
        id,
        title,
        cardinality(array(select jsonb_object_keys(tags))) as num_tag_keys,
        __DIMENSIONS__
      from
        __TABLE_NAME__
    )
    select
      id as resource,
      case
        when num_tag_keys > $1::integer then 'alarm'
        else 'ok'
      end as status,
      title || ' has ' || num_tag_keys || ' tag(s).' as reason,
      __DIMENSIONS__
    from
      analysis
  EOT
}

locals {
  limit_sql_subscription   = replace(local.limit_sql, "__DIMENSIONS__", "subscription_id")
  limit_sql_resource_group = replace(local.limit_sql, "__DIMENSIONS__", "resource_group, subscription_id")
}

benchmark "limit" {
  title       = "Limit"
  description = "The number of tags on each resource should be monitored to avoid hitting the limit unexpectedly."
  children = [
    control.compute_virtual_machine_tag_limit,
    control.storage_storage_account_tag_limit
  ]
}

control "compute_virtual_machine_tag_limit" {
  title       = "Compute virtual machines should not exceed tag limit"
  description = "Check if the number of tags on Compute virtual machines do not exceed the limit."
  sql         = replace(local.limit_sql_resource_group, "__TABLE_NAME__", "azure_compute_virtual_machine")
  param "tag_limit" {
    default = var.tag_limit
  }
}

control "storage_storage_account_tag_limit" {
  title       = "Storage storage accounts should not exceed tag limit"
  description = "Check if the number of tags on Storage storage accounts do not exceed the limit."
  sql         = replace(local.limit_sql_resource_group, "__TABLE_NAME__", "azure_storage_account")
  param "tag_limit" {
    default = var.tag_limit
  }
}
