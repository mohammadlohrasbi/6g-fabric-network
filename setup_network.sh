#!/bin/bash

# Generate crypto material
cryptogen generate --config=./crypto-config.yaml

# Create channel artifacts directory
mkdir -p channel-artifacts

# Generate genesis block and channel artifacts
export FABRIC_CFG_PATH=$PWD
configtxgen -profile GeneralChannelApp -outputCreateChannelTx ./channel-artifacts/generalchannelapp.tx -channelID generalchannelapp
configtxgen -profile IoTChannelApp -outputCreateChannelTx ./channel-artifacts/iotchannelapp.tx -channelID iotchannelapp
configtxgen -profile SecurityChannelApp -outputCreateChannelTx ./channel-artifacts/securitychannelapp.tx -channelID securitychannelapp
configtxgen -profile MonitoringChannelApp -outputCreateChannelTx ./channel-artifacts/monitoringchannelapp.tx -channelID monitoringchannelapp
for i in {1..10}; do
  configtxgen -profile Org${i}ChannelApp -outputCreateChannelTx ./channel-artifacts/org${i}channelapp.tx -channelID org${i}channelapp
done
configtxgen -profile GeneralChannelApp -outputBlock ./channel-artifacts/genesis.block

# Start network
docker compose up -d

# Wait for network to stabilize
sleep 10

# Create and join channels
for channel in generalchannelapp iotchannelapp securitychannelapp monitoringchannelapp org{1..10}channelapp; do
  docker exec peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c $channel -f ./channel-artifacts/${channel}.tx --outputBlock ./channel-artifacts/${channel}.block --tls --cafile /var/hyperledger/peer/tls/ca.crt
  for i in {1..10}; do
    docker exec peer0.org${i}.example.com peer channel join -b ./channel-artifacts/${channel}.block
  done
done

# Install chaincodes
CHAINCODES=(
  "ResourceAllocate" "BandwidthShare" "DynamicRouting" "LoadBalance" "LatencyOptimize"
  "EnergyOptimize" "NetworkOptimize" "SpectrumManage" "ResourceScale" "ResourcePrioritize"
  "UserAuth" "DeviceAuth" "AccessControl" "TokenAuth" "RoleBasedAuth"
  "IdentityVerify" "SessionAuth" "MultiFactorAuth" "AuthPolicy" "AuthAudit"
  "NetworkMonitor" "PerformanceMonitor" "TrafficMonitor" "ResourceMonitor" "HealthMonitor"
  "AlertMonitor" "LogMonitor" "EventMonitor" "MetricsCollector" "StatusMonitor"
  "Encryption" "IntrusionDetect" "FirewallRules" "SecureChannel" "ThreatMonitor"
  "AccessLog" "SecurityPolicy" "VulnerabilityScan" "DataIntegrity" "SecureBackup"
  "TransactionAudit" "ComplianceAudit" "AccessAudit" "EventAudit" "PolicyAudit"
  "DataAudit" "UserAudit" "SystemAudit" "PerformanceAudit" "SecurityAudit"
  "ConfigManage" "PolicyManage" "ResourceManage" "NetworkManage" "DeviceManage"
  "UserManage" "ServiceManage" "EventManage" "AlertManage" "LogManage"
  "DataAnalytics" "FaultDetect" "AnomalyDetect" "PredictiveMaintenance" "PerformanceAnalytics"
  "TrafficAnalytics" "SecurityAnalytics" "ResourceAnalytics" "EventAnalytics" "LogAnalytics"
)

for chaincode in "${CHAINCODES[@]}"; do
  for i in {1..10}; do
    docker exec peer0.org${i}.example.com peer chaincode install -n $chaincode -v 1.0 -p /opt/gopath/src/github.com/chaincode/$chaincode
  done
  for channel in generalchannelapp iotchannelapp securitychannelapp monitoringchannelapp org{1..10}channelapp; do
    docker exec peer0.org1.example.com peer chaincode instantiate -o orderer.example.com:7050 -C $channel -n $chaincode -v 1.0 -c '{"Args":["init"]}' -P "OR('Org1MSP.member','Org2MSP.member','Org3MSP.member','Org4MSP.member','Org5MSP.member','Org6MSP.member','Org7MSP.member','Org8MSP.member','Org9MSP.member','Org10MSP.member')" --tls --cafile /var/hyperledger/peer/tls/ca.crt
  done
done

echo "Network setup complete with all channels and chaincodes."
