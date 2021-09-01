benchmark "untagged" {
  title = "Untagged"
  children = [
    control.compute_virtual_machine_untagged,
    control.storage_account_untagged,
  ]
}

control "compute_virtual_machine_untagged" {
  title = "Compute Virtual Machines Untagged"
  sql = <<EOT
    select
      name as resource,
      case
        when tags is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when tags is not null then name || ' has tags.'
        else name || ' has no tags.'
      end as reason,
      region,
      resource_group,
      subscription_id
    from
      azure_compute_virtual_machine
    EOT
}

control "storage_account_untagged" {
  title = "Storage Accounts Untagged"
  sql = <<EOT
    select
      name as resource,
      case
        when tags is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when tags is not null then name || ' has tags.'
        else name || ' has no tags.'
      end as reason,
      region,
      resource_group,
      subscription_id
    from
      azure_storage_account
    EOT
}
