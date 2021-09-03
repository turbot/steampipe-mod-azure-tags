variable "prohibited_tags" {
  type        = list(string)
  description = "A list of prohibited tags to check for."
}

locals {
  prohibited_sql = <<EOT
    with analysis as (
      select
        id,
        array_agg(k) as prohibited_tags
      from
        __TABLE_NAME__,
        jsonb_object_keys(tags) as k,
        unnest($1::text[]) as prohibited_key
      where
        k = prohibited_key
      group by
        id
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
      __DIMENSIONS__
    from
      __TABLE_NAME__ as r
    full outer join
      analysis as a on a.id = r.id
  EOT
}

locals {
  prohibited_sql_subscription   = replace(local.prohibited_sql, "__DIMENSIONS__", "r.subscription_id")
  prohibited_sql_resource_group = replace(local.prohibited_sql, "__DIMENSIONS__", "r.resource_group, r.subscription_id")
}

benchmark "prohibited" {
  title    = "Prohibited"
  description = "Prohibited tags may contain sensitive, confidential, or otherwise unwanted data and should be removed."
  children = [
    control.compute_virtual_machine_prohibited,
    control.storage_storage_account_prohibited,
  ]
}

control "compute_virtual_machine_prohibited" {
  title       = "Compute virtual machines should not have prohibited tags"
  description = "Check if Compute virtual machines have any prohibited tags."
  sql         = replace(local.prohibited_sql_resource_group, "__TABLE_NAME__", "azure_compute_virtual_machine")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}

control "storage_storage_account_prohibited" {
  title       = "Storage storage accounts should not have prohibited tags"
  description = "Check if Storage storage accounts have any prohibited tags."
  sql         = replace(local.prohibited_sql_resource_group, "__TABLE_NAME__", "azure_storage_account")
  param "prohibited_tags" {
    default = var.prohibited_tags
  }
}
