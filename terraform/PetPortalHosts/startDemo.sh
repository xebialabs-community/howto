#!/usr/bin/env bash

curl -LO https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip
unzip terraform_0.14.7_linux_amd64.zip
rm terraform_0.14.7_linux_amd64.zip
docker-compose up -d
