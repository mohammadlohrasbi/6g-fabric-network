#!/bin/bash

# لیست چین‌کدها
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

# لیست کانال‌ها
CHANNELS=(
  "generalchannelapp" "iotchannelapp" "securitychannelapp" "monitoringchannelapp"
  "org1channelapp" "org2channelapp" "org3channelapp" "org4channelapp" "org5channelapp"
  "org6channelapp" "org7channelapp" "org8channelapp" "org9channelapp" "org10channelapp"
)

# بررسی فضای دیسک
echo "Checking disk space..."
df -h > disk_space.log
free -m >> disk_space.log
nproc >> disk_space.log

# پاک‌سازی محیط
echo "Cleaning up environment..."
docker-compose -f docker-compose.yaml down
docker rm -f $(docker ps -a -q) 2>/dev/null
docker network rm 6g-fabric-network_fabric 2>/dev/null
docker image prune -f
docker volume prune -f
rm -rf channel-artifacts crypto-config production tape
mkdir -p channel-artifacts production chaincode caliper tape workload config

# تولید مواد رمزنگاری
echo "Generating crypto materials..."
cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
if [ $? -ne 0 ]; then
  echo "Error generating crypto materials. Check cryptogen.log"
  exit 1
fi

# فشرده‌سازی فایل‌های crypto-config
echo "Compressing crypto-config files..."
find crypto-config -type f -name "*.pem" -exec gzip {} \;
find crypto-config -type f -name "*.crt" -exec gzip {} \;

# باز کردن فایل‌های فشرده برای استفاده
echo "Uncompressing crypto-config files..."
find crypto-config -type f -name "*.gz" -exec gunzip {} \;

# تولید فایل‌های تنظیمات
echo "Generating configuration files..."
chmod +x generateCoreYamls.sh generateConnectionProfiles.sh generateChaincodes.sh generateWorkloadFiles.sh generateTapeConfigs.sh
dos2unix *.sh
./generateCoreYamls.sh
./generateConnectionProfiles.sh
./generateChaincodes.sh
./generateWorkloadFiles.sh
./generateTapeConfigs.sh

# تولید بلاک جنسیس
echo "Generating genesis block..."
configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block 2> configtxgen_genesis.log
if [ $? -ne 0 ]; then
  echo "Error generating genesis block. Check configtxgen_genesis.log"
  exit 1
fi

# تولید فایل‌های تراکنش کانال
for channel in "${CHANNELS[@]}"; do
  echo "Generating channel transaction for $channel..."
  configtxgen -profile Channel -outputCreateChannelTx ./channel-artifacts/${channel}.tx -channelID $channel 2>> configtxgen_channel.log
  if [ $? -ne 0 ]; then
    echo "Error generating channel transaction for $channel. Check configtxgen_channel.log"
    exit 1
  fi
done

# راه‌اندازی کانتینرها
echo "Starting containers..."
docker-compose -f docker-compose.yaml up -d ca.orderer.example.com ca.org1.example.com ca.org2.example.com ca.org3.example.com ca.org4.example.com ca.org5.example.com ca.org6.example.com ca.org7.example.com ca.org8.example.com ca.org9.example.com ca.org10.example.com
sleep 60
docker-compose -f docker-compose.yaml up -d orderer.example.com peer0.org1.example.com peer0.org2.example.com peer0.org3.example.com peer0.org4.example.com peer0.org5.example.com peer0.org6.example.com peer0.org7.example.com peer0.org8.example.com peer0.org9.example.com peer0.org10.example.com
sleep 60

# بررسی وضعیت کانتینرها
echo "Checking container status..."
docker ps -a > container_status.log

# ایجاد کانال‌ها
for channel in "${CHANNELS[@]}"; do
  echo "Creating channel $channel..."
  docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
              -e "CORE_PEER_LOCALMSPID=Org1MSP" \
              peer0.org1.example.com peer channel create \
              -o orderer.example.com:7050 \
              -c $channel \
              -f /etc/hyperledger/configtx/${channel}.tx \
              --outputBlock /etc/hyperledger/configtx/${channel}.block \
              --tls \
              --cafile /etc/hyperledger/fabric/tls/ca.crt 2> channel_create_${channel}.log
  if [ $? -ne 0 ]; then
    echo "Error creating channel $channel. Check channel_create_${channel}.log"
    exit 1
  fi
done

# پیوستن Peerها به کانال‌ها
for org in {1..10}; do
  peer="peer0.org${org}.example.com"
  msp="Org${org}MSP"
  port=$((7051 + (org-1)*1000))
  for channel in "${CHANNELS[@]}"; do
    echo "Joining $peer to $channel..."
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org${org}.example.com/msp" \
                -e "CORE_PEER_LOCALMSPID=$msp" \
                -e "CORE_PEER_ADDRESS=$peer:$port" \
                $peer peer channel join -b /etc/hyperledger/configtx/${channel}.block 2> channel_join_${channel}_org${org}.log
    if [ $? -ne 0 ]; then
      echo "Error joining $peer to $channel. Check channel_join_${channel}_org${org}.log"
      exit 1
    fi
  done
done

# نصب و نمونه‌سازی چین‌کدها
for chaincode in "${CHAINCODES[@]}"; do
  for channel in "${CHANNELS[@]}"; do
    for org in {1..10}; do
      peer="peer0.org${org}.example.com"
      msp="Org${org}MSP"
      port=$((7051 + (org-1)*1000))
      echo "Installing chaincode $chaincode on $peer..."
      docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org${org}.example.com/msp" \
                  -e "CORE_PEER_LOCALMSPID=$msp" \
                  -e "CORE_PEER_ADDRESS=$peer:$port" \
                  $peer peer chaincode install -n $chaincode -v 1.0 -p chaincode/$chaincode 2> chaincode_install_${chaincode}_org${org}.log
      if [ $? -ne 0 ]; then
        echo "Error installing chaincode $chaincode on $peer. Check chaincode_install_${chaincode}_org${org}.log"
        exit 1
      fi
    done
    echo "Instantiating chaincode $chaincode on $channel..."
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
                -e "CORE_PEER_LOCALMSPID=Org1MSP" \
                peer0.org1.example.com peer chaincode instantiate \
                -o orderer.example.com:7050 \
                -C $channel \
                -n $chaincode \
                -v 1.0 \
                -c '{"Args":["init"]}' \
                --tls \
                --cafile /etc/hyperledger/fabric/tls/ca.crt 2> chaincode_instantiate_${chaincode}_${channel}.log
    if [ $? -ne 0 ]; then
      echo "Error instantiating chaincode $chaincode on $channel. Check chaincode_instantiate_${chaincode}_${channel}.log"
      exit 1
    fi
    sleep 10
  done
done

# ذخیره لاگ‌های کانتینرها
echo "Saving container logs..."
docker logs ca.orderer.example.com > ca.orderer.log 2>&1
docker logs ca.org1.example.com > ca.org1.log 2>&1
docker logs orderer.example.com > orderer.log 2>&1
docker logs peer0.org1.example.com > peer0.org1.log 2>&1

echo "Network setup completed."
