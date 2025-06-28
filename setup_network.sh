#!/bin/bash

# فعال‌سازی دیباگ
set -x

# بررسی پیش‌نیازها
command -v cryptogen >/dev/null 2>&1 || { echo "cryptogen مورد نیاز است اما نصب نشده است."; exit 1; }
command -v configtxgen >/dev/null 2>&1 || { echo "configtxgen مورد نیاز است اما نصب نشده است."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "docker مورد نیاز است اما نصب نشده است."; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo "docker-compose مورد نیاز است اما نصب نشده است."; exit 1; }

# تنظیم FABRIC_CFG_PATH
export FABRIC_CFG_PATH=$PWD
echo "FABRIC_CFG_PATH تنظیم شده است به: $FABRIC_CFG_PATH"

# بررسی وجود configtx.yaml
if [ ! -f "$FABRIC_CFG_PATH/configtx.yaml" ]; then
  echo "فایل configtx.yaml در $FABRIC_CFG_PATH یافت نشد"
  exit 1
fi

# تولید مواد رمزنگاری
if [ ! -d "crypto-config" ]; then
  cryptogen generate --config=./crypto-config.yaml
  if [ $? -ne 0 ]; then
    echo "خطا در تولید مواد رمزنگاری"
    exit 1
  fi
else
  echo "مواد رمزنگاری از قبل وجود دارند، بررسی صحت..."
fi

# بررسی MSP مدیر و گواهی‌های TLS برای Org1 تا Org10
for org in {1..10}; do
  MSP_DIR="crypto-config/peerOrganizations/org${org}.example.com/users/Admin@org${org}.example.com/msp"
  if [ ! -d "$MSP_DIR" ] || [ ! -f "$MSP_DIR/signcerts/Admin@org${org}.example.com-cert.pem" ] || [ ! -f "$MSP_DIR/keystore/"* ] || [ ! -f "$MSP_DIR/config.yaml" ]; then
    echo "MSP مدیر برای Org${org} نامعتبر یا غایب است. تولید مجدد مواد رمزنگاری..."
    rm -rf crypto-config
    cryptogen generate --config=./crypto-config.yaml
    if [ $? -ne 0 ]; then
      echo "خطا در تولید مواد رمزنگاری"
      exit 1
    fi
    break
  fi
  # بررسی نقش admin در config.yaml
  grep -q "NodeOUs:.*admin" "$MSP_DIR/config.yaml" || {
    echo "نقش admin در $MSP_DIR/config.yaml یافت نشد. تولید مجدد مواد رمزنگاری..."
    rm -rf crypto-config
    cryptogen generate --config=./crypto-config.yaml
    exit 1
  }
done

# بررسی گواهی TLS Orderer
TLS_CA="crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
if [ ! -f "$TLS_CA" ]; then
  echo "گواهی TLS Orderer یافت نشد. تولید مجدد مواد رمزنگاری..."
  rm -rf crypto-config
  cryptogen generate --config=./crypto-config.yaml
  if [ $? -ne 0 ]; then
    echo "خطا در تولید مواد رمزنگاری"
    exit 1
  fi
fi

# تولید بلاک جنسیس
configtxgen -profile OrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block
if [ $? -ne 0 ]; then
  echo "خطا در تولید genesis.block"
  exit 1
fi

# تولید تراکنش‌های تنظیمات کانال
declare -A channel_profiles=(
  ["generalchannelapp"]="GeneralChannelApp"
  ["iotchannelapp"]="IoTChannelApp"
  ["securitychannelapp"]="SecurityChannelApp"
  ["monitoringchannelapp"]="MonitoringChannelApp"
  ["org1channelapp"]="Org1ChannelApp"
  ["org2channelapp"]="Org2ChannelApp"
  ["org3channelapp"]="Org3ChannelApp"
  ["org4channelapp"]="Org4ChannelApp"
  ["org5channelapp"]="Org5ChannelApp"
  ["org6channelapp"]="Org6ChannelApp"
  ["org7channelapp"]="Org7ChannelApp"
  ["org8channelapp"]="Org8ChannelApp"
  ["org9channelapp"]="Org9ChannelApp"
  ["org10channelapp"]="Org10ChannelApp"
)

for channel in "${!channel_profiles[@]}"; do
  profile=${channel_profiles[$channel]}
  echo "تولید تراکنش برای کانال $channel با پروفایل $profile..."
  configtxgen -profile $profile -outputCreateChannelTx ./channel-artifacts/${channel}.tx -channelID ${channel}
  if [ $? -ne 0 ]; then
    echo "خطا در تولید ${channel}.tx"
    exitISMO
    exit 1
  fi
done

# راه‌اندازی شبکه
docker-compose -f docker-compose.yaml up -d
if [ $? -ne 0 ]; then
  echo "خطا در راه‌اندازی شبکه"
  exit 1
fi

# انتظار برای پایداری شبکه
echo "انتظار 90 ثانیه برای پایداری شبکه..."
sleep 90

# بررسی وضعیت کانتینرها و ذخیره لاگ‌ها
docker ps
docker logs orderer.example.com > orderer.log 2>&1
docker logs peer0.org1.example.com > peer0.org1.log 2>&1

# بررسی MSP داخل کانتینر
echo "بررسی MSP داخل کانتینر peer0.org1.example.com..."
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/users/Admin@org1.example.com/msp
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/users/Admin@org1.example.com/msp/signcerts
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/users/Admin@org1.example.com/msp/keystore

# ایجاد و پیوستن به کانال‌ها
channels=("generalchannelapp" "iotchannelapp" "securitychannelapp" "monitoringchannelapp" "org1channelapp" "org2channelapp" "org3channelapp" "org4channelapp" "org5channelapp" "org6channelapp" "org7channelapp" "org8channelapp" "org9channelapp" "org10channelapp")
for channel in "${channels[@]}"; do
  echo "ایجاد کانال $channel..."
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
    echo "خطا در ایجاد کانال $channel"
    echo "لاگ‌های Orderer و Peer را بررسی کنید: orderer.log, peer0.org1.log"
    exit 1
  fi

  for org in {1..10}; do
    echo "پیوستن org${org} به کانال $channel..."
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org${org}.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org${org}MSP" \
               peer0.org${org}.example.com peer channel join \
               -b /etc/hyperledger/configtx/${channel}.block
    if [ $? -ne 0 ]; then
      echo "خطا در پیوستن org${org} به کانال $channel"
      exit 1
    fi
  done
done

# بررسی دایرکتوری‌های چین‌کد
chaincodes=("ResourceAllocate" "BandwidthShare" "DynamicRouting" "AccessControl" "NetworkMonitor" "SecurityProtocol" "DataPrivacy" "ResourceOptimization" "LatencyMonitor" "ThroughputEnhancer" "QoSManager" "SpectrumAllocation" "DeviceAuth" "TrafficShaping" "EncryptionService" "PolicyEnforcement" "LoadBalancer" "FaultTolerance" "DataIntegrity" "SmartContract" "ConsensusManager" "KeyManagement" "AuditTrail" "PerformanceMetrics" "NetworkSlicing" "ResourcePool" "BandwidthOptimizer" "IoTSecurity" "MonitoringAgent" "AlertSystem" "DataAnalytics" "PrivacyGuard" "SecureChannel" "ResourceScheduler" "DynamicScaler" "NetworkHealth" "PolicyManager" "AccessMonitor" "TrafficAnalyzer" "SecurityAudit" "LatencyOptimizer" "ThroughputMonitor" "QoSMonitor" "SpectrumManager" "DeviceManager" "TrafficManager" "EncryptionManager" "PolicyAgent" "LoadManager" "FaultManager" "IntegrityChecker" "ContractManager" "ConsensusAgent" "KeyStore" "AuditManager" "PerformanceAnalyzer" "SliceManager" "ResourceAllocator" "BandwidthManager" "IoTManager" "MonitoringService" "AlertManager" "AnalyticsService" "PrivacyManager" "SecureComm" "SchedulerService" "ScalerService" "HealthMonitor" "PolicyService" "AccessManager" "TrafficService")
for cc in "${chaincodes[@]}"; do
  if [ ! -d "chaincode/$cc" ]; then
    mkdir -p chaincode/$cc
    echo "package main" > chaincode/$cc/dummy.go
  fi
done

# نصب و نمونه‌سازی چین‌کدها
for channel in "${channels[@]}"; do
  for cc in "${chaincodes[@]}"; do
    for org in {1..10}; do
      echo "نصب چین‌کد $cc روی org${org}..."
      docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org${org}.example.com/msp" \
                 -e "CORE_PEER_LOCALMSPID=Org${org}MSP" \
                 peer0.org${org}.example.com peer chaincode install \
                 -n $cc -v 1.0 -p "/opt/gopath/src/github.com/chaincode/$cc"
      if [ $? -ne 0 ]; then
        echo "خطا در نصب چین‌کد $cc روی org${org}"
        exit 1
      fi
    done
    echo "نمونه‌سازی چین‌کد $cc روی کانال $channel..."
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org1MSP" \
               peer0.org1.example.com peer chaincode instantiate \
               -o orderer.example.com:7050 \
               --tls \
               --cafile /etc/hyperledger/fabric/tls/orderer-ca.crt \
               -C $channel \
               -n $cc -v 1.0 -c '{"Args":["init"]}' -P "OR('Org1MSP.member','Org2MSP.member','Org3MSP.member','Org4MSP.member','Org5MSP.member','Org6MSP.member','Org7MSP.member','Org8MSP.member','Org9MSP.member','Org10MSP.member')"
    if [ $? -ne 0 ]; then
      echo "خطا در نمونه‌سازی چین‌کد $cc روی کانال $channel"
      exit 1
    fi
  done
done

echo "راه‌اندازی شبکه با موفقیت انجام شد"
