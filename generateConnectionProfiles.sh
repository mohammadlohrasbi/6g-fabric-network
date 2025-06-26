#!/bin/bash

for i in {1..10}; do
  cat << EOF > connection-org${i}.json
{
  "name": "fabric-network-org${i}",
  "version": "1.0.0",
  "client": {
    "organization": "Org${i}",
    "connection": {
      "timeout": {
        "peer": { "endorser": "300" },
        "orderer": "300"
      }
    }
  },
  "organizations": {
    "Org${i}": {
      "mspid": "Org${i}MSP",
      "peers": ["peer0.org${i}.example.com"],
      "certificateAuthorities": ["ca.org${i}.example.com"]
    }
  },
  "peers": {
    "peer0.org${i}.example.com": {
      "url": "grpc://localhost:$((7051 + (i-1)*1000))",
      "grpcOptions": {
        "ssl-target-name-override": "peer0.org${i}.example.com"
      },
      "tlsCACerts": {
        "path": "crypto-config/peerOrganizations/org${i}.example.com/peers/peer0.org${i}.example.com/tls/ca.crt"
      }
    }
  },
  "certificateAuthorities": {
    "ca.org${i}.example.com": {
      "url": "http://localhost:$((7054 + (i-1)*1000))",
      "caName": "ca-org${i}",
      "tlsCACerts": {
        "path": "crypto-config/peerOrganizations/org${i}.example.com/ca/ca.org${i}.example.com-cert.pem"
      },
      "httpOptions": { "verify": false }
    }
  }
}
EOF
done

echo "Generated connection-org1.json to connection-org10.json"
