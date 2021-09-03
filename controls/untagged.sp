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
  title    = "Untagged"
  description = "Untagged resources are difficult to monitor and should be identified and remediated."
  children = [
    control.compute_virtual_machine_untagged,
    control.storage_storage_account_untagged,
  ]
}

control "compute_virtual_machine_untagged" {
  title       = "Compute virtual machines should be tagged"
  description = "Check if Compute virtual machines have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_compute_virtual_machine")
}

control "storage_storage_account_untagged" {
  title       = "Storage storage accounts should be tagged"
  description = "Check if Storage storage accounts have at least 1 tag."
  sql         = replace(local.untagged_sql_resource_group, "__TABLE_NAME__", "azure_storage_account")
}
