#!/bin/bash

# Enable debugging
set -x

# Check prerequisites
command -v cryptogen >/dev/null 2>&1 || { echo "cryptogen is required but not installed. Aborting."; exit 1; }
command -v configtxgen >/dev/null 2>&1 || { echo "configtxgen is required but not installed. Aborting."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "docker is required but not installed. Aborting."; exit 1; }
#command -v docker-compose >/dev/null 2>&1 || { echo "docker-compose is required but not installed. Aborting."; exit 1; }

# Verify configtx.yaml exists
if [ ! -f "configtx.yaml" ]; then
  echo "configtx.yaml not found in current directory. Aborting."
  exit 1
fi

# Clean up previous artifacts
rm -rf channel-artifacts crypto-config production
mkdir -p channel-artifacts production chaincode

# Generate crypto material
echo "Generating crypto material..."
cryptogen generate --config=./crypto-config.yaml || { echo "Failed to generate crypto material"; exit 1; }

# Verify MSP directories
for org in {1..10}; do
  if [ ! -d "crypto-config/peerOrganizations/org${org}.example.com/msp" ]; then
    echo "MSP directory for Org${org} not found. Aborting."
    exit 1
  fi
  if [ ! -d "crypto-config/peerOrganizations/org${org}.example.com/users/Admin@org${org}.example.com/msp" ]; then
    echo "Admin MSP directory for Org${org} not found. Aborting."
    exit 1
  fi
done
if [ ! -d "crypto-config/ordererOrganizations/example.com/msp" ]; then
  echo "MSP directory for Orderer not found. Aborting."
  exit 1
fi

# Generate genesis block and channel artifacts
export FABRIC_CFG_PATH=$PWD
echo "Generating genesis block and channel artifacts..."
echo "Verifying configtx.yaml content:"
cat configtx.yaml
echo "FABRIC_CFG_PATH is set to: $FABRIC_CFG_PATH"
configtxgen -profile OrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block || { echo "Failed to generate genesis.block"; exit 1; }
configtxgen -profile GeneralChannelApp -outputCreateChannelTx ./channel-artifacts/generalchannelapp.tx -channelID generalchannelapp || { echo "Failed to generate generalchannelapp.tx"; exit 1; }
configtxgen -profile IoTChannelApp -outputCreateChannelTx ./channel-artifacts/iotchannelapp.tx -channelID iotchannelapp || { echo "Failed to generate iotchannelapp.tx"; exit 1; }
configtxgen -profile SecurityChannelApp -outputCreateChannelTx ./channel-artifacts/securitychannelapp.tx -channelID securitychannelapp || { echo "Failed to generate securitychannelapp.tx"; exit 1; }
configtxgen -profile MonitoringChannelApp -outputCreateChannelTx ./channel-artifacts/monitoringchannelapp.tx -channelID monitoringchannelapp || { echo "Failed to generate monitoringchannelapp.tx"; exit 1; }
for i in {1..10}; do
  configtxgen -profile Org${i}ChannelApp -outputCreateChannelTx ./channel-artifacts/org${i}channelapp.tx -channelID org${i}channelapp || { echo "Failed to generate org${i}channelapp.tx"; exit 1; }
done

# Verify channel artifacts
for channel in generalchannelapp iotchannelapp securitychannelapp monitoringchannelapp org{1..10}channelapp; do
  if [ ! -f "./channel-artifacts/${channel}.tx" ]; then
    echo "Channel artifact ${channel}.tx not found. Aborting."
    exit 1
  fi
done

# Start network
echo "Starting Docker network..."
docker compose up -d || { echo "Failed to start Docker network"; exit 1; }

# Wait for network to stabilize
echo "Waiting for network to stabilize..."
sleep 90

# Verify Orderer is accessible
echo "Checking Orderer connectivity..."
docker exec peer0.org1.example.com nc -zv orderer.example.com 7050 || { echo "Orderer not accessible at orderer.example.com:7050"; exit 1; }

# Verify channel artifacts in container
echo "Verifying channel artifacts in peer0.org1.example.com..."
for channel in generalchannelapp iotchannelapp securitychannelapp monitoringchannelapp org{1..10}channelapp; do
  docker exec peer0.org1.example.com ls -l "/etc/hyperledger/configtx/${channel}.tx" || { echo "Channel artifact ${channel}.tx not found in container"; exit 1; }
done

# Verify TLS CA certificate
echo "Verifying TLS CA certificate in peer0.org1.example.com..."
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/tls/orderer-ca.crt || { echo "TLS CA certificate not found in container"; exit 1; }

# Create and join channels
for channel in generalchannelapp iotchannelapp securitychannelapp monitoringchannelapp org{1..10}channelapp; do
  echo "Creating channel $channel..."
  # Use Org1 Admin for creating all channels
  docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
             -e "CORE_PEER_LOCALMSPID=Org1MSP" \
             peer0.org1.example.com peer channel create \
             -o orderer.example.com:7050 \
             -c "$channel" \
             -f "/etc/hyperledger/configtx/${channel}.tx" \
             --outputBlock "/etc/hyperledger/configtx/${channel}.block" \
             --tls \
             --cafile /etc/hyperledger/fabric/tls/orderer-ca.crt || { echo "Failed to create channel $channel"; exit 1; }
  for i in {1..10}; do
    echo "Joining peer0.org${i}.example.com to $channel..."
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org${i}.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org${i}MSP" \
               peer0.org${i}.example.com peer channel join \
               -b "/etc/hyperledger/configtx/${channel}.block" || { echo "Failed to join peer0.org${i}.example.com to $channel"; exit 1; }
  done
done

# Skip chaincode installation for now (uncomment when chaincodes are ready)
: '
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
    echo "Installing chaincode $chaincode on peer0.org${i}.example.com..."
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org${i}.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org${i}MSP" \
               peer0.org${i}.example.com peer chaincode install \
               -n "$chaincode" -v 1.0 -p "/opt/gopath/src/github.com/chaincode/$chaincode" || { echo "Failed to install chaincode $chaincode on peer0.org${i}.example.com"; exit 1; }
  done
  for channel in generalchannelapp iotchannelapp securitychannelapp monitoringchannelapp org{1..10}channelapp; do
    echo "Instantiating chaincode $chaincode on $channel..."
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org1MSP" \
               peer0.org1.example.com peer chaincode instantiate \
               -o orderer.example.com:7050 \
               -C "$channel" \
               -n "$chaincode" \
               -v 1.0 \
               -c '{"Args":["init"]}' \
               -P "OR('Org1MSP.member','Org2MSP.member','Org3MSP.member','Org4MSP.member','Org5MSP.member','Org6MSP.member','Org7MSP.member','Org8MSP.member','Org9MSP.member','Org10MSP.member')" \
               --tls \
               --cafile /etc/hyperledger/fabric/tls/orderer-ca.crt || { echo "Failed to instantiate chaincode $chaincode on $channel"; exit 1; }
    sleep 5
  done
done
'

echo "Network setup complete with all channels."
