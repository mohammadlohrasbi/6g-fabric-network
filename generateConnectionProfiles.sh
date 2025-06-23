#!/bin/bash

# تابع بررسی خطا
check_error() {
    if [ $? -ne 0 ]; then
        echo "خطا: $1"
        exit 1
    fi
}

# قالب پروفایل اتصال
template=$(cat << 'EOF'
---
name: xAI-6G Fabric Network
version: "1.0.0"
client:
  organization: Org{{OrgNum}}
  connection:
    timeout:
      peer:
        endorser: "300"
      orderer: "300"
organizations:
  Org{{OrgNum}}:
    mspid: Org{{OrgNum}}MSP
    peers:
      - peer0.org{{OrgNum}}.example.com
    certificateAuthorities:
      - ca.org{{OrgNum}}.example.com
peers:
  peer0.org{{OrgNum}}.example.com:
    url: grpc://localhost:{{PeerPort}}
    grpcOptions:
      ssl-target-name-override: peer0.org{{OrgNum}}.example.com
    tlsCACerts:
      path: crypto-config/peerOrganizations/org{{OrgNum}}.example.com/peers/peer0.org{{OrgNum}}.example.com/tls/ca.crt
orderers:
  orderer1.example.com:
    url: grpc://localhost:7050
    grpcOptions:
      ssl-target-name-override: orderer1.example.com
    tlsCACerts:
      path: crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/ca.crt
certificateAuthorities:
  ca.org{{OrgNum}}.example.com:
    url: http://localhost:{{CAPort}}
    caName: ca-org{{OrgNum}}
    tlsCACerts:
      path: crypto-config/peerOrganizations/org{{OrgNum}}.example.com/ca/ca.org{{OrgNum}}.example.com-cert.pem
    httpOptions:
      verify: false
EOF
)

# تولید فایل‌ها برای Org1 تا Org10
for org in {1..10}; do
    peer_port=$((7051 + (org-1)*1000))
    ca_port=$((7054 + (org-1)*1000))
    
    echo "org=$org, peer_port=$peer_port, ca_port=$ca_port"
    
    profile_code="$template"
    profile_code=$(echo "$profile_code" | sed "s#{{OrgNum}}#$org#g")
    profile_code=$(echo "$profile_code" | sed "s#{{PeerPort}}#$peer_port#g")
    profile_code=$(echo "$profile_code" | sed "s#{{CAPort}}#$ca_port#g")
    
    mkdir -p "crypto-config/peerOrganizations/org${org}.example.com"
    echo "$profile_code" > "crypto-config/peerOrganizations/org${org}.example.com/connection-org${org}.yaml"
    check_error "تولید فایل connection-org${org}.yaml"
    echo "Generated connection profile: connection-org${org}.yaml"
done
