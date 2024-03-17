## Operating IBC/ Interoperability infrastructure
#### Operate a Shielded Expedition-compatible Osmosis testnet relayer

>memo: tpknam1qpxleh3wtgyxdlm6e6ux6m5mfafad6l7jae42r6xvf0yaemerltcjms5d8l
  
#### IBC Namada << >> Osmosis

```
Namada (shielded-expedition.88f17d1d14):
   channel_id:    channel-942
   client_id:     07-tendermint-2973
   connection_id: connection-1462
   port_id:       transfer
Creation address: tnam1qz0dhqrmss4gv97nl42qsymrgrmjxdru8uk6vcdd
```
```
Osmosis (osmo-test-5): 
   channel_id:    channel-6389
   client_id:     07-tendermint-2950
   connection_id: connection-2681
   port_id:       transfer
Creation address: osmo1lyedavj530a6wm5dkrwx8sweqymlvvy6ghpn0q
```

#### Transactions:

>from Namada to Osmosis  
https://www.mintscan.io/osmosis-testnet/tx/80ACD42770804BEC699FCBBFC5C997FB3CD2B766E5C2A2D11B8081EE8BF7F9A2?height=6074443

>from Osmosis to Namada
https://www.mintscan.io/osmosis-testnet/tx/9F08EAD0FB5F6AA733F12E076A69928B07BFCA3D490D3A14652B1D5EE5FBC0F0?height=6074498


#### SUCCESS:
```
SUCCESS Channel {
    ordering: Unordered,
    a_side: ChannelSide {
        chain: BaseChainHandle {
            chain_id: ChainId {
                id: "shielded-expedition.88f17d1d14",
                version: 0,
            },
            runtime_sender: Sender { .. },
        },
        client_id: ClientId(
            "07-tendermint-2973",
        ),
        connection_id: ConnectionId(
            "connection-1462",
        ),
        port_id: PortId(
            "transfer",
        ),
        channel_id: Some(
            ChannelId(
                "channel-942",
            ),
        ),
        version: None,
    },
    b_side: ChannelSide {
        chain: BaseChainHandle {
            chain_id: ChainId {
                id: "osmo-test-5",
                version: 5,
            },
            runtime_sender: Sender { .. },
        },
        client_id: ClientId(
            "07-tendermint-2950",
        ),
        connection_id: ConnectionId(
            "connection-2681",
        ),
        port_id: PortId(
            "transfer",
        ),
        channel_id: Some(
            ChannelId(
                "channel-6389",
            ),
        ),
        version: None,
    },
    connection_delay: 0ns,
}
```
#### Public Namada RPC:

https://rpc.laliola.com/   

