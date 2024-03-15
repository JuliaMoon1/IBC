# IBC
Operating IBC/ Interoperability infrastructure (Osmosis testnet relaer)
#### namada RPC
```
https://rpc.laliola.com
```
#### osmo RPC
```
https://osmo.laliola.com
```
## Installation & setup

#### setup vars
```
export INSTALLATION=docker 
export MONIKER=osmo_laliola
```
#### Download a Osmo (osmo-test-5) snapshot and set up Docker
```
curl -s -L https://raw.githubusercontent.com/JuliaMoon1/IBC/main/box/join-snapshot.sh | bash -s $INSTALLATION $MONIKER
```
>the Docker image adjusted for avoide ports conflict with Namada
