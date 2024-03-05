// Benchmarks and controls for specific services should override the "service" tag
locals {
  azure_tags_common_tags = {
    category = "Tagging"
    plugin   = "azure"
    service  = "Azure"
  }
}
