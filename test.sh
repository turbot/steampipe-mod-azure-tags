#!/bin/bash

OLDIFS=$IFS
IFS='#'

INPUT=$(steampipe check control.storage_storage_account_prohibited --var 'prohibited_tags=["Application1"]' --output csv --header=false --separator '#' | grep 'alarm')
[ -z "$INPUT" ] && { echo "No instances in alarm, aborting"; exit 0; }

while read -r group_id title description control_id control_title control_description reason resource status account_id region
do
  az tag delete --resource-id ${resource} --name Application1 --yes
done <<< "$INPUT"

IFS=$OLDIFS
