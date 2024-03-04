// Benchmarks and controls for specific services should override the "service" tag
locals {
  azure_tags_common_tags = {
    category = "Tagging"
    plugin   = "azure"
    service  = "Azure"
  }
}

variable "expected_tag_values" {
  type        = map(list(string))
  description = "Map of expected values for various tags, e.g., {\"Environment\": [\"Prod\", \"Staging\", \"Dev%\"]}. SQL wildcards '%' and '_' can be used for matching values. These characters must be escaped for exact matches, e.g., {\"created_by\": [\"test\\_user\"]}."

  default = {
    "Environment": ["Dev", "Staging", "Prod"]
  }
}

variable "tag_limit" {
  type        = number
  description = "Number of tags allowed on a resource. Azure allows up to 50 tags per resource."
  default     = 45
}

variable "mandatory_tags" {
  type        = list(string)
  description = "A list of mandatory tags to check for."
  default     = ["Environment", "Owner"]
}

variable "prohibited_tags" {
  type        = list(string)
  description = "A list of prohibited tags to check for."
  default     = ["Password", "Key"]
}
