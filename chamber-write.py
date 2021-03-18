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
        config_file_path=f"{key}/{env}/config.json"
        print(f"Updating Parameter /{key}/{env}/config via {config_file_path}")

        config=open(config_file_path).read()
        config_json=json.loads(config)

        return_code=0
        if "sops" in config_json:
            return_code=os.system(f"sops -d {key}/{env}/config.json | chamber write {key}/{env} config -")
        else:
            print(f"INFO: {config_file_path} already unencrypted.")
            return_code=os.system(f"cat {key}/{env}/config.json | chamber write {key}/{env} config -")

        if return_code != 0:
                print("Error: either decrypting or updating the parameters was unsuccessful. Exiting.")
                exit(1)

        