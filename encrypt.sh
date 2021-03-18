#/bin/bash

CONTEXT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
for file in $(find "$CONTEXT" -name "*.json");
do
    if [[ $(cat petshop-billing/dev/config.json | jq -r .sops) == null ]];
    then
        sops --encrypt -i ${file}
    fi
done
