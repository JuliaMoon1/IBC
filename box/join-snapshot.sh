#!/bin/bash
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
CLEAN='\033[0m'

INSTALLATION=$1
if [ -z $INSTALLATION ]; then
    INSTALLATION=cosmovisor
fi

MONIKER=$2
if [ -z $MONIKER ]; then
    MONIKER=my-node
fi

OSMOSIS_HOME=$HOME/.osmosisd
OSMOSIS_VERSION=21.0.0-a-rc4-testnet
GOLANG_VERSION=1.20

ADDRBOOK_URL=https://rpc.testnet.osmosis.zone/addrbook
GENESIS_URL=https://genesis.testnet.osmosis.zone/genesis.json
SNAPSHOT_URL=$(curl -s https://osmosis.fra1.digitaloceanspaces.com/osmo-test-5/snapshots/latest)

WAIT=10

# Checking system resources
printf "${GREEN}CPU cores: $(nproc) ${CLEAN}\n"
free_mem=$(free -m | awk '/^Mem:/{print $2}') # Get free memory in MB
if [ "$free_mem" -lt 8000 ]; then # Assuming 8GB is the minimum requirement
    printf "${RED}Free memory is less than 8GB ${CLEAN}\n"
else
    printf "Free memory: ${free_mem}MB \n"
fi

# Determine architecture for downloading the correct Go binary
ARCH=$(uname -m)
case $ARCH in
    x86_64) ARCH="amd64";;
    aarch64) ARCH="arm64";;
    *) printf "${RED}Unsupported architecture: $ARCH ${CLEAN}\n"; exit 1;;
esac
printf "${GREEN}CPU arch detected: $ARCH ${CLEAN}\n"

# Dependencies check
PACKAGES="unzip tar git jq sed wget curl lz4"
for dep in $PACKAGES; do
    if ! command -v "$dep" >/dev/null; then
        printf "${GREEN}Installing $dep... ${CLEAN}"
        sudo apt-get install "$dep" -y || printf "${RED}Failed to install $dep ${CLEAN}\n"
    fi
done

# Define and download the Go package
GO_PACKAGE_URL="https://go.dev/dl/go${GOLANG_VERSION}.linux-${ARCH}.tar.gz"
wget -q $GO_PACKAGE_URL
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $(basename $GO_PACKAGE_URL)
echo "export PATH=\$PATH:/usr/local/go/bin:\$(go env GOPATH)/bin" >> ~/.profile
source ~/.profile
printf "${GREEN}Go version installed: $(go version) ${CLEAN}\n"

# Node configuration
mkdir -p $OSMOSIS_HOME

# Initialize the node
osmosisd init $MONIKER --chain-id osmo-test-5 --home $OSMOSIS_HOME

# Correcting the RPC port setting to avoid conflicts
sed -i.bak "s/26657/29657/g" $OSMOSIS_HOME/config/config.toml

# Downloading necessary files
wget -q $GENESIS_URL -O $OSMOSIS_HOME/config/genesis.json
wget -q $ADDRBOOK_URL -O $OSMOSIS_HOME/config/addrbook.json

# Download and unpack the snapshot
wget -q -O - $SNAPSHOT_URL | lz4 -d | tar -C $OSMOSIS_HOME/ -xvf -

# Docker specific setup
if [ "$INSTALLATION" == "docker" ]; then
    cd $OSMOSIS_HOME
    sudo docker compose up -d
fi

printf "${GREEN}Osmosis Node service is running ${CLEAN}\n"

# Correctly querying the Osmosis node status with the updated RPC port
status=$(curl -s localhost:29657/status | jq '.result.sync_info.catching_up')
printf "${GREEN}Node status Catching up: $status , retrying until false ${CLEAN}\n"

while [ "$status" = "true" ]
do
  sleep $WAIT
  status=$(curl -s localhost:29657/status | jq '.result.sync_info.catching_up')
  printf "${GREEN}Node status Catching up: $status , retrying until false${CLEAN}\n"
done

printf "${GREEN}Node Catching up is no longer true, NODE IS READY! ${CLEAN}\n"
