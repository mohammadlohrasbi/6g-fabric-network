#!/bin/bash

# دایرکتوری برای فایل‌های تنظیمات
mkdir -p config

# تولید فایل core-org*.yaml برای هر سازمان
for org in {1..10}; do
  port=$((7051 + (org-1)*1000))
  chaincode_port=$((7052 + (org-1)*1000))
  cat << EOF > config/core-org${org}.yaml
peer:
  id: peer0.org${org}.example.com
  networkId: fabric
  listenAddress: 0.0.0.0:${port}
  chaincodeListenAddress: 0.0.0.0:${chaincode_port}
  address: peer0.org${org}.example.com:${port}
  localMspId: Org${org}MSP
  mspConfigPath: /etc/hyperledger/fabric/msp
  tls:
    enabled: true
    cert:
      file: /etc/hyperledger/fabric/tls/server.crt
    key:
      file: /etc/hyperledger/fabric/tls/server.key
    rootcert:
      file: /etc/hyperledger/fabric/tls/ca.crt
  gossip:
    bootstrap: peer0.org${org}.example.com:${port}
    externalEndpoint: peer0.org${org}.example.com:${port}
  logging:
    level: info
  ledger:
    state:
      maxFileSize: 10MB
EOF
done

echo "فایل‌های تنظیمات core-org*.yaml برای 10 سازمان تولید شد."
