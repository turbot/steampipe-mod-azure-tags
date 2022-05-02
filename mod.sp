// Benchmarks and controls for specific services should override the "service" tag
locals {
  azure_tags_common_tags = {
    category = "Tagging"
    plugin   = "azure"
    service  = "Azure"
  }
}

mod "azure_tags" {
  # hub metadata
  title         = "Azure Tags"
  description   = "Run tagging controls across all your Azure subscriptions using Steampipe."
  color         = "#0089D6"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/azure-tags.svg"
  categories    = ["azure", "tags", "public cloud"]

  opengraph {
    title        = "Steampipe Mod for Azure Tags"
    description  = "Run tagging controls across all your Azure subscriptions using Steampipe."
    image        = "/images/mods/turbot/azure-tags-social-graphic.png"
  }
}