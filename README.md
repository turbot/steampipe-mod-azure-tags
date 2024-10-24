# Azure Tags Mod for Powerpipe

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
powerpipe mod install github.com/turbot/steampipe-mod-azure-tags
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

Browse and view your dashboards at **http://localhost:9033**.

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

### Configure Variables

Several benchmarks have [input variables](https://powerpipe.io/docs/build/mod-variables#input-variables) that can be configured to better match your environment and requirements. Each variable has a default defined in its source file, e.g., controls/limit.sp, but these can be overridden in several ways:

It's easiest to setup your vars file, starting with the sample:

```sh
cp powerpipe.ppvars.example powerpipe.ppvars
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

These are only some of the ways you can set variables. For a full list, please see [Passing Input Variables](https://powerpipe.io/docs/build/mod-variables#passing-input-variables).

### Remediation

Using the control output and the Azure CLI, you can remediate various tagging issues.

For instance, with the results of the `compute_virtual_machine_mandatory` control, you can add missing tags with the Azure CLI:

```sh
#!/bin/bash

OLDIFS=$IFS
IFS='#'

INPUT=$(powerpipe control run compute_virtual_machine_mandatory --var 'mandatory_tags=["Application"]' --output csv --header=false --separator '#' | grep 'alarm')
[ -z "$INPUT" ] && { echo "No virtual machines in alarm, aborting"; exit 0; }

while read -r group_id title description control_id control_title control_description reason resource status resource_group subscription
do
  az tag create --resource-id ${resource} --tags Application=MyApplication
done <<< "$INPUT"

IFS=$OLDIFS
```

To remove prohibited tags from Compute virtual machines:
```sh
#!/bin/bash

OLDIFS=$IFS
IFS='#'

INPUT=$(powerpipe control run compute_virtual_machine_prohibited --var 'prohibited_tags=["Password"]' --output csv --header=false --separator '#' | grep 'alarm')
[ -z "$INPUT" ] && { echo "No virtual machines in alarm, aborting"; exit 0; }

while read -r group_id title description control_id control_title control_description reason resource status resource_group subscription
do
  az tag delete --resource-id ${resource} --name Password --yes
done <<< "$INPUT"

IFS=$OLDIFS
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) and [Powerpipe](https://powerpipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [Azure Tags Mod](https://github.com/turbot/steampipe-mod-azure-tags/labels/help%20wanted)
