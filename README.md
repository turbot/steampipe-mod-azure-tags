# Azure Tags Mod for Powerpipe

> [!IMPORTANT]
> Steampipe mods are [migrating to Powerpipe format](https://powerpipe.io) to gain new features. This mod currently works with both Steampipe and Powerpipe, but will only support Powerpipe from v1.x onward.

An Azure tags checking tool that can be used to look for untagged resources, missing tags, resources with too many tags, and more.

Run checks in a dashboard:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-azure-tags/main/docs/azure_tags_dashboard.png)

Or in a terminal:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-azure-tags/main/docs/azure_tags_mod_terminal.png)

## Documentation

- **[Benchmarks and controls →](https://hub.powerpipe.io/mods/turbot/azure_tags/controls)**

## Getting Started

### Installation

Install Powerpipe (https://powerpipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/powerpipe
```

This mod also requires [Steampipe](https://steampipe.io) with the [Azure plugin](https://hub.steampipe.io/plugins/turbot/azure) as the data source. Install Steampipe (https://steampipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/steampipe
steampipe plugin install azure
```

Steampipe will automatically use your default Azure and Azure Active Directory credentials. Optionally, you can [setup multiple subscriptions](https://hub.steampipe.io/plugins/turbot/azure#multi-subscription-connections) for Azure or [customize Azure credentials](https://hub.steampipe.io/plugins/turbot/azure#configuring-azure-credentials).

Finally, install the mod:

```sh
mkdir dashboards
cd dashboards
powerpipe mod init
powerpipe mod install github.com/turbot/powerpipe-mod-azure-tags
```

### Browsing Dashboards

Start Steampipe as the data source:

```sh
steampipe service start
```

Start the dashboard server:

```sh
powerpipe server
```

Browse and view your dashboards at **https://localhost:9033**.

### Running Checks in Your Terminal

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `powerpipe benchmark` command:

List available benchmarks:

```sh
powerpipe benchmark list
```

Run a benchmark:

```sh
powerpipe benchmark run azure_tags.benchmark.limit
```

Different output formats are also available, for more information please see
[Output Formats](https://powerpipe.io/docs/reference/cli/benchmark#output-formats).

### Configuration

Several benchmarks have [input variables](https://steampipe.io/docs/using-steampipe/mod-variables) that can be configured to better match your environment and requirements. Each variable has a default defined, but these can be overridden in several ways:

It's easiest to setup your vars file, starting with the sample:

```sh
cp powerpipe.ppvar.example powerpipe.ppvars
vi powerpipe.ppvars
```

Alternatively you can pass variables on the command line:

```sh
powerpipe benchmark run azure_tags.benchmark.mandatory --var 'mandatory_tags=["Application", "Environment", "Department", "Owner"]'
```

Or through environment variables:

```sh
export PP_VAR_mandatory_tags='["Application", "Environment", "Department"]'
powerpipe benchmark run azure_tags.benchmark.mandatory
```

These are only some of the ways you can set variables. For a full list, please see [Passing Input Variables](https://steampipe.io/docs/using-steampipe/mod-variables#passing-input-variables).

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) and [Powerpipe](https://powerpipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [Azure Tags Mod](https://github.com/turbot/steampipe-mod-azure-tags/labels/help%20wanted)