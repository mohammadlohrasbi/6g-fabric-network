#!/bin/bash

for i in {1..10}; do
  cat << EOF > core-org${i}.yaml
peer:
  id: peer0.org${i}.example.com
  networkId: fabric
  listenAddress: 0.0.0.0:$((7051 + (i-1)*1000))
  chaincodeListenAddress: 0.0.0.0:$((7052 + (i-1)*1000))
  address: peer0.org${i}.example.com:$((7051 + (i-1)*1000))
  localMspId: Org${i}MSP
  mspConfigPath: /var/hyperledger/peer/msp
  gossip:
    bootstrap: peer0.org${i}.example.com:$((7051 + (i-1)*1000))
    externalEndpoint: peer0.org${i}.example.com:$((7051 + (i-1)*1000))
  logging:
    level: info
  tls:
    enabled: true
    cert:
      file: /var/hyperledger/peer/tls/server.crt
    key:
      file: /var/hyperledger/peer/tls/server.key
    rootcert:
      file: /var/hyperledger/peer/tls/ca.crt
EOF
done

echo "Generated core-org1.yaml to core-org10.yaml"
