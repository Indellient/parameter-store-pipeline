#!/usr/bin/python3

import os
import json

service_config_locations = {
    "petshop-billing"    : ["global", "dev", "qa", "uat", "prod"],
    "petshop-inventory"  : ["global", "dev", "qa", "uat", "prod"],
    "petshop-storefront" : ["global", "dev", "qa", "uat", "prod"]
}

for key in service_config_locations:
    for env in service_config_locations[key]:
        print(f"Writing config for {key}/{env}: {key}/{env}/config.json")
        os.system(f"cat {key}/{env}/config.json | chamber write {key}/{env} config -")