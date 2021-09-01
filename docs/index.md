---
repository: "https://github.com/turbot/steampipe-mod-azure-tags"
---

# Azure Tags Mod

Run tagging controls across all your Azure subscriptions.

## References

[Azure](https://azure.microsoft.com/) provides on-demand cloud computing platforms and APIs to authenticated customers on a metered pay-as-you-go basis.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/azure_tags/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/azure_tags/queries)**

## Get started

Install the Azure plugin with [Steampipe](https://steampipe.io):
```shell
steampipe plugin install azure
```

Clone:
```sh
git clone https://github.com/turbot/steampipe-mod-azure-tags.git
cd steampipe-mod-azure-tags
```

Run all benchmarks:
```shell
steampipe check all
```

Run a single benchmark:
```shell
steampipe check benchmark.untagged
```

Run a specific control:
```shell
steampipe check control.storage_account_untagged
```

### Credentials

This mod uses the credentials configured in the [Steampipe Azure plugin](https://hub.steampipe.io/plugins/turbot/azure).

### Configuration

No extra configuration is required.

## Get involved

* Contribute: [GitHub Repo](https://github.com/turbot/steampipe-mod-azure-tags)

* Community: [Slack Channel](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)
