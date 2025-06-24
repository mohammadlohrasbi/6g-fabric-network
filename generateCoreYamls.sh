#!/bin/bash

# تابع بررسی خطا
check_error() {
    if [ $? -ne 0 ]; then
        echo "خطا: $1"
        exit 1
    fi
}

echo "تولید فایل‌های core.yaml برای تمام سازمان‌ها..."

for i in {1..10}; do
  org="org${i}"
  port=$((7051 + (i-1)*1000))
  cat > core-org${i}.yaml << EOL
---
peer:
  id: cli-org${i}
  networkId: 6gfabric
  address: peer0.${org}.example.com:${port}
  localMspId: Org${i}MSP
  mspConfigPath: /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${org}.example.com/users/Admin@${org}.example.com/msp
  tls:
    enabled: true
    clientCert: /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${org}.example.com/users/Admin@${org}.example.com/tls/client.crt
    clientKey: /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${org}.example.com/users/Admin@${org}.example.com/tls/client.key
    rootcert: /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${org}.example.com/peers/peer0.${org}.example.com/tls/ca.crt
  gossip:
    useLeaderElection: true
    orgLeader: false
    externalEndpoint: peer0.${org}.example.com:${port}
  chaincodeListenAddress: 0.0.0.0:$((port+1))
  chaincodeAddress: peer0.${org}.example.com:$((port+1))
logging:
  level: info
fileSystemPath: /var/hyperledger/production
EOL
  check_error "تولید core-org${i}.yaml"
done

echo "فایل‌های core.yaml با موفقیت تولید شدند!"
