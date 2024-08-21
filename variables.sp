// Benchmarks and controls for specific services should override the "service" tag
locals {
  azure_tags_common_tags = {
    category = "Tagging"
    plugin   = "azure"
    service  = "Azure"
  }
}

variable "common_dimensions" {
  type        = list(string)
  description = "A list of common dimensions to add to each control."
  # Define which common dimensions should be added to each control.
  # - connection_name (_ctx ->> 'connection_name')
  # - region
  # - resource_group
  # - subscription_id
  default = ["resource_group", "subscription_id"]
}

variable "tag_dimensions" {
  type        = list(string)
  description = "A list of tags to add as dimensions to each control."
  # A list of tag names to include as dimensions for resources that support
  # tags (e.g. "department", "environment"). Default to empty since tag names are
  # a personal choice
  default = []
}

locals {
  # Local internal variable to build the SQL select clause for common
  # dimensions using a table name qualifier if required. Do not edit directly.
  common_dimensions_qualifier_sql = <<-EOQ
  %{~if contains(var.common_dimensions, "connection_name")}, __QUALIFIER___ctx ->> 'connection_name' as connection_name%{endif~}
  %{~if contains(var.common_dimensions, "region")}, __QUALIFIER__region as region%{endif~}
  %{~if contains(var.common_dimensions, "subscription_id")}, __QUALIFIER__subscription_id as subscription_id%{endif~}
  EOQ

  # Local internal variable to build the SQL select clause for tag
  # dimensions. Do not edit directly.
  tag_dimensions_qualifier_sql = <<-EOQ
  %{~for dim in var.tag_dimensions},  __QUALIFIER__tags ->> '${dim}' as "${replace(dim, "\"", "\"\"")}"%{endfor~}
  EOQ
}

locals {
  # Local internal variable with the full SQL select clause for common
  # and tag dimensions. Do not edit directly.
  common_dimensions_sql                 = replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "")
  tag_dimensions_sql                    = replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "")
}
