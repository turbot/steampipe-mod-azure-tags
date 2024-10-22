mod "azure_tags" {
  # Hub metadata
  title         = "Azure Tags"
  description   = "Run tagging controls across all your Azure subscriptions using Powerpipe and Steampipe."
  color         = "#0089D6"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/azure-tags.svg"
  categories    = ["azure", "tags", "public cloud"]

  opengraph {
    title       = "Powerpipe Mod for Azure Tags"
    description = "Run tagging controls across all your Azure subscriptions using Powerpipe and Steampipe."
    image       = "/images/mods/turbot/azure-tags-social-graphic.png"
  }
}