#/bin/bash

CONTEXT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
for file in $(find "$CONTEXT" -name "*.json");
do
    sops --encrypt -i ${file}
done
