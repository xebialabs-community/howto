#!/usr/bin/env bash

XLD_URL="http://localhost:5516"
XLD_USER="admin"
XLD_PASSWD="admin"
CLI_VERSION="10.0.0"
VERSION="1.0.0"

echo "Version = ${VERSION}"

path_to_executable=$(which xl)
if [ ! -x "$path_to_executable" ]
then
  platform = `uname`
  if [ "$platform" -eq "Darwin" ]
  then
    curl -LO https://dist.xebialabs.com/public/xl-cli/$VERSION/darwin-amd64/xl
  else
    curl -LO https://dist.xebialabs.com/public/xl-cli/$CLI_VERSION/linux-amd64/xl
  fi
  chmod +x xl
  export PATH=$PATH:.
else
  xl apply --xl-deploy-url=$XLD_URL --xl-deploy-username=$XLD_USER --xl-deploy-password=$XLD_PASSWD --file xebialabs.yaml --values version=$VERSION
  if [ ! -x "$path_to_executable" ]
  then
    rm xl
  fi
fi
