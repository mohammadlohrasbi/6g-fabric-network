```bash
#!/bin/bash

# Enable debugging
set -x

# Check prerequisites
command -v cryptogen >/dev/null 2>&1 || { echo "cryptogen is required but not installed."; exit 1; }
command -v configtxgen >/dev/null 2>&1 || { echo "configtxgen is required but not installed."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "docker is required but not installed."; exit 1; }
#command -v docker-compose >/dev/null 2>&1 || { echo "docker-compose is required but not installed."; exit 1; }

# Set FABRIC_CFG_PATH
export FABRIC_CFG_PATH=$PWD
echo "FABRIC_CFG_PATH is set to: $FABRIC_CFG_PATH"

# Generate crypto material
if [ ! -d "crypto-config" ]; then
  cryptogen generate --config=./crypto-config.yaml
  if [ $? -ne 0 ]; then
    echo "Failed to generate crypto material"
    exit 1
  fi
else
  echo "Crypto material already exists, skipping generation"
fi

# Verify admin MSP for Org1
if [ ! -d "crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" ]; then
  echo "Admin MSP for Org1 not found. Regenerating crypto material..."
  rm -rf crypto-config
  cryptogen generate --config=./crypto-config.yaml
  if [ $? -ne 0 ]; then
    echo "Failed to generate crypto material"
    exit 1
  fi
fi

# Generate genesis block
configtxgen -profile OrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block
if [ $? -ne 0 ]; then
  echo "Failed to generate genesis.block"
  exit 1
fi

# Generate channel configuration transactions
configtxgen -profile GeneralChannelApp -outputCreateChannelTx ./channel-artifacts/generalchannelapp.tx -channelID generalchannelapp
if [ $? -ne 0 ]; then
  echo "Failed to generate generalchannelapp.tx"
  exit 1
fi
configtxgen -profile IoTChannelApp -outputCreateChannelTx ./channel-artifacts/iotchannelapp.tx -channelID iotchannelapp
if [ $? -ne 0 ]; then
  echo "Failed to generate iotchannelapp.tx"
  exit 1
fi
configtxgen -profile SecurityChannelApp -outputCreateChannelTx ./channel-artifacts/securitychannelapp.tx -channelID securitychannelapp
if [ $? -ne 0 ]; then
  echo "Failed to generate securitychannelapp.tx"
  exit 1
fi
configtxgen -profile MonitoringChannelApp -outputCreateChannelTx ./channel-artifacts/monitoringchannelapp.tx -channelID monitoringchannelapp
if [ $? -ne 0 ]; then
  echo "Failed to generate monitoringchannelapp.tx"
  exit 1
fi

for i in {1..10}; do
  configtxgen -profile Org${i}ChannelApp -outputCreateChannelTx ./channel-artifacts/org${i}channelapp.tx -channelID org${i}channelapp
  if [ $? -ne 0 ]; then
    echo "Failed to generate org${i}channelapp.tx"
    exit 1
  fi
done

# Start network
docker compose up -d
if [ $? -ne 0 ]; then
  echo "Failed to start network"
  exit 1
fi

# Wait for network to stabilize
sleep 90

# Create and join channels
channels=("generalchannelapp" "iotchannelapp" "securitychannelapp" "monitoringchannelapp" "org1channelapp" "org2channelapp" "org3channelapp" "org4channelapp" "org5channelapp" "org6channelapp" "org7channelapp" "org8channelapp" "org9channelapp" "org10channelapp")
for channel in "${channels[@]}"; do
  docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
             -e "CORE_PEER_LOCALMSPID=Org1MSP" \
             peer0.org1.example.com peer channel create \
             -o orderer.example.com:7050 \
             -c $channel \
             -f /etc/hyperledger/configtx/${channel}.tx \
             --outputBlock /etc/hyperledger/configtx/${channel}.block \
             --tls \
             --cafile /etc/hyperledger/fabric/tls/orderer-ca.crt
  if [ $? -ne 0 ]; then
    echo "Failed to create channel $channel"
    exit 1
  fi

  for org in {1..10}; do
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org${org}.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org${org}MSP" \
               peer0.org${org}.example.com peer channel join \
               -b /etc/hyperledger/configtx/${channel}.block
    if [ $? -ne 0 ]; then
      echo "Failed to join org${org} to channel $channel"
      exit 1
    fi
  done
done

# Check chaincode directories
chaincodes=("ResourceAllocate" "BandwidthShare" "DynamicRouting" "AccessControl" "NetworkMonitor" "SecurityProtocol" "DataPrivacy" "ResourceOptimization" "LatencyMonitor" "ThroughputEnhancer" "QoSManager" "SpectrumAllocation" "DeviceAuth" "TrafficShaping" "EncryptionService" "PolicyEnforcement" "LoadBalancer" "FaultTolerance" "DataIntegrity" "SmartContract" "ConsensusManager" "KeyManagement" "AuditTrail" "PerformanceMetrics" "NetworkSlicing" "ResourcePool" "BandwidthOptimizer" "IoTSecurity" "MonitoringAgent" "AlertSystem" "DataAnalytics" "PrivacyGuard" "SecureChannel" "ResourceScheduler" "DynamicScaler" "NetworkHealth" "PolicyManager" "AccessMonitor" "TrafficAnalyzer" "SecurityAudit" "LatencyOptimizer" "ThroughputMonitor" "QoSMonitor" "SpectrumManager" "DeviceManager" "TrafficManager" "EncryptionManager" "PolicyAgent" "LoadManager" "FaultManager" "IntegrityChecker" "ContractManager" "ConsensusAgent" "KeyStore" "AuditManager" "PerformanceAnalyzer" "SliceManager" "ResourceAllocator" "BandwidthManager" "IoTManager" "MonitoringService" "AlertManager" "AnalyticsService" "PrivacyManager" "SecureComm" "SchedulerService" "ScalerService" "HealthMonitor" "PolicyService" "AccessManager" "TrafficService")
for cc in "${chaincodes[@]}"; do
  if [ ! -d "chaincode/$cc" ]; then
    mkdir -p chaincode/$cc
    echo "package main" > chaincode/$cc/dummy.go
  fi
done

# Install and instantiate chaincodes
for channel in "${channels[@]}"; do
  for cc in "${chaincodes[@]}"; do
    for org in {1..10}; do
      docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org${org}.example.com/msp" \
                 -e "CORE_PEER_LOCALMSPID=Org${org}MSP" \
                 peer0.org${org}.example.com peer chaincode install \
                 -n $cc -v 1.0 -p "/opt/gopath/src/github.com/chaincode/$cc"
      if [ $? -ne 0 ]; then
        echo "Failed to install chaincode $cc on org${org}"
        exit 1
      fi
    done
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org1MSP" \
               peer0.org1.example.com peer chaincode instantiate \
               -o orderer.example.com:7050 \
               --tls \
               --cafile /etc/hyperledger/fabric/tls/orderer-ca.crt \
               -C $channel \
               -n $cc -v 1.0 -c '{"Args":["init"]}' -P "OR('Org1MSP.member','Org2MSP.member','Org3MSP.member','Org4MSP.member','Org5MSP.member','Org6MSP.member','Org7MSP.member','Org8MSP.member','Org9MSP.member','Org10MSP.member')"
    if [ $? -ne 0 ]; then
      echo "Failed to instantiate chaincode $cc on channel $channel"
      exit 1
    fi
  done
done

echo "Network setup completed successfully"
