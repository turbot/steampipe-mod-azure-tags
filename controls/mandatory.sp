variable "mandatory_tags" {
  type        = list(string)
  description = "A list of mandatory tags to check for."
}

locals {
  mandatory_sql = <<EOT
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
      analysis
  EOT
}

locals {
  mandatory_sql_subscription   = replace(local.mandatory_sql, "__DIMENSIONS__", "subscription_id")
  mandatory_sql_resource_group = replace(local.mandatory_sql, "__DIMENSIONS__", "resource_group, subscription_id")
}

benchmark "mandatory" {
  title       = "Mandatory"
  description = "Resources should all have a standard set of tags applied for functions like resource organization, automation, cost control, and access control."
  children = [
    control.compute_virtual_machine_mandatory,
    control.storage_storage_account_mandatory,
  ]
}

control "compute_virtual_machine_mandatory" {
  title       = "Compute virtual machines should have mandatory tags"
  description = "Check if Compute virtual machines have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_compute_virtual_machine")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}

control "storage_storage_account_mandatory" {
  title       = "Storage storage accounts should have mandatory tags"
  description = "Check if Storage storage accounts have mandatory tags."
  sql         = replace(local.mandatory_sql_resource_group, "__TABLE_NAME__", "azure_storage_account")
  param "mandatory_tags" {
    default = var.mandatory_tags
  }
}
