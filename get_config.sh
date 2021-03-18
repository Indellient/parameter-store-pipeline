#/bin/bash

service=$1
environment=$2

echo "$(chamber export ${service}/global config | jq -r .config)" "$(chamber export ${service}/${environment} config | jq -r .config)" | jq -s add
