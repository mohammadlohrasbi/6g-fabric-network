#!/bin/bash

# فعال‌سازی دیباگ
set -x

# بررسی پیش‌نیازها
command -v cryptogen >/dev/null 2>&1 || { echo "cryptogen مورد نیاز است اما نصب نشده است."; exit 1; }
command -v configtxgen >/dev/null 2>&1 || { echo "configtxgen مورد نیاز است اما نصب نشده است."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "docker مورد نیاز است اما نصب نشده است."; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo "docker-compose مورد نیاز است اما نصب نشده است."; exit 1; }

# بررسی نسخه cryptogen
cryptogen version
EXPECTED_CRYPT_VERSION="2.4.9"
if ! cryptogen version | grep -q "$EXPECTED_CRYPT_VERSION"; then
  echo "نسخه cryptogen با $EXPECTED_CRYPT_VERSION سازگار نیست. لطفاً نسخه 2.4.9 را نصب کنید."
  exit 1
fi

# بررسی نسخه docker-compose
docker-compose version
EXPECTED_DOCKER_COMPOSE_VERSION="1.29.2"
if ! docker-compose version | grep -q "$EXPECTED_DOCKER_COMPOSE_VERSION"; then
  echo "نسخه docker-compose با $EXPECTED_DOCKER_COMPOSE_VERSION سازگار نیست. لطفاً نسخه 1.29.2 را نصب کنید."
  exit 1
fi

# تنظیم FABRIC_CFG_PATH
export FABRIC_CFG_PATH=$PWD
echo "FABRIC_CFG_PATH تنظیم شده است به: $FABRIC_CFG_PATH"

# بررسی وجود configtx.yaml
if [ ! -f "$FABRIC_CFG_PATH/configtx.yaml" ]; then
  echo "فایل configtx.yaml در $FABRIC_CFG_PATH یافت نشد"
  exit 1
fi

# بررسی وجود crypto-config.yaml
if [ ! -f "$FABRIC_CFG_PATH/crypto-config.yaml" ]; then
  echo "فایل crypto-config.yaml در $FABRIC_CFG_PATH یافت نشد"
  exit 1
fi

# بررسی وجود docker-compose.yaml
if [ ! -f "$FABRIC_CFG_PATH/docker-compose.yaml" ]; then
  echo "فایل docker-compose.yaml در $FABRIC_CFG_PATH یافت نشد"
  exit 1
fi

# تولید مواد رمزنگاری
if [ ! -d "crypto-config" ]; then
  cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
  if [ $? -ne 0 ]; then
    echo "خطا در تولید مواد رمزنگاری. لاگ‌ها را بررسی کنید: cryptogen.log"
    cat cryptogen.log
    exit 1
  fi
else
  echo "مواد رمزنگاری از قبل وجود دارند، بررسی صحت..."
fi

# بررسی MSP مدیر و گواهی‌های TLS برای Org1 تا Org10
for org in {1..10}; do
  MSP_DIR="crypto-config/peerOrganizations/org${org}.example.com/users/Admin@org${org}.example.com/msp"
  CA_DIR="crypto-config/peerOrganizations/org${org}.example.com/ca"
  echo "بررسی MSP برای Org${org} در $MSP_DIR..."
  if [ ! -d "$MSP_DIR" ] || [ ! -f "$MSP_DIR/signcerts/Admin@org${org}.example.com-cert.pem" ] || [ ! -f "$MSP_DIR/keystore/"* ] || [ ! -f "$MSP_DIR/config.yaml" ]; then
    echo "MSP مدیر برای Org${org} نامعتبر یا غایب است. تولید مجدد مواد رمزنگاری..."
    rm -rf crypto-config
    cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
    if [ $? -ne 0 ]; then
      echo "خطا در تولید مواد رمزنگاری. لاگ‌ها را بررسی کنید: cryptogen.log"
      cat cryptogen.log
      exit 1
    fi
    # بررسی مجدد پس از تولید
    if [ ! -f "$MSP_DIR/config.yaml" ]; then
      echo "فایل config.yaml برای Org${org} پس از تولید مجدد یافت نشد"
      exit 1
    fi
  fi
  # بررسی نقش admin در config.yaml
  if ! grep -q "AdminOUIdentifier" "$MSP_DIR/config.yaml"; then
    echo "نقش AdminOUIdentifier در $MSP_DIR/config.yaml یافت نشد."
    echo "محتوای فایل config.yaml برای Org${org}:"
    cat "$MSP_DIR/config.yaml"
    echo "تولید مجدد مواد رمزنگاری..."
    rm -rf crypto-config
    cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
    if [ $? -ne 0 ]; then
      echo "خطا در تولید مواد رمزنگاری. لاگ‌ها را بررسی کنید: cryptogen.log"
      cat cryptogen.log
      exit 1
    fi
    # بررسی مجدد
    if ! grep -q "AdminOUIdentifier" "$MSP_DIR/config.yaml"; then
      echo "نقش AdminOUIdentifier پس از تولید مجدد همچنان در $MSP_DIR/config.yaml یافت نشد"
      echo "محتوای فایل config.yaml پس از تولید مجدد:"
      cat "$MSP_DIR/config.yaml"
      exit 1
    fi
  fi
  # بررسی دایرکتوری CA
  if [ ! -d "$CA_DIR" ]; then
    echo "دایرکتوری CA برای Org${org} در $CA_DIR یافت نشد. تولید مجدد مواد رمزنگاری..."
    rm -rf crypto-config
    cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
    if [ $? -ne 0 ]; then
      echo "خطا در تولید مواد رمزنگاری. لاگ‌ها را بررسی کنید: cryptogen.log"
      cat cryptogen.log
      exit 1
    fi
  fi
  echo "نقش admin و CA برای Org${org} تأیید شد."
done

# بررسی گواهی TLS Orderer
TLS_CA="crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
if [ ! -f "$TLS_CA" ]; then
  echo "گواهی TLS Orderer یافت نشد. تولید مجدد مواد رمزنگاری..."
  rm -rf crypto-config
  cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
  if [ $? -ne 0 ]; then
    echo "خطا در تولید مواد رمزنگاری. لاگ‌ها را بررسی کنید: cryptogen.log"
    cat cryptogen.log
    exit 1
  fi
fi

# بررسی محتوای configtx.yaml
echo "بررسی سیاست‌های Admins در configtx.yaml..."
grep -A 5 "Admins:" $FABRIC_CFG_PATH/configtx.yaml > configtx_admins.log
cat configtx_admins.log

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
    exit 1
  fi
done

# راه‌اندازی شبکه با docker-compose
echo "راه‌اندازی شبکه با docker-compose.yaml..."
docker-compose -f docker-compose.yaml up -d
if [ $? -ne 0 ]; then
  echo "خطا در راه‌اندازی شبکه"
  exit 1
fi

# بررسی فایل‌های docker-compose دیگر
echo "بررسی فایل‌های docker-compose در سیستم..."
find / -name "docker-compose.yaml" -o -name "docker-compose.yml" 2>/dev/null > docker_compose_files.log
cat docker_compose_files.log

# انتظار برای پایداری شبکه (300 ثانیه)
echo "انتظار 300 ثانیه برای پایداری شبکه..."
sleep 300

# بررسی وضعیت کانتینرها
echo "بررسی وضعیت کانتینرها..."
docker ps -a > container_status.log
cat container_status.log
if ! docker ps | grep -q "ca.orderer.example.com"; then
  echo "کانتینر ca.orderer.example.com در حال اجرا نیست"
  docker logs ca.orderer.example.com > ca.orderer.log 2>&1
  cat ca.orderer.log
  exit 1
fi
if ! docker ps | grep -q "ca.org1.example.com"; then
  echo "کانتینر ca.org1.example.com در حال اجرا نیست"
  docker logs ca.org1.example.com > ca.org1.log 2>&1
  cat ca.org1.log
  exit 1
fi
if ! docker ps | grep -q "orderer.example.com"; then
  echo "کانتینر orderer.example.com در حال اجرا نیست"
  docker logs orderer.example.com > orderer.log 2>&1
  cat orderer.log
  exit 1
fi
if ! docker ps | grep -q "peer0.org1.example.com"; then
  echo "کانتینر peer0.org1.example.com در حال اجرا نیست"
  docker logs peer0.org1.example.com > peer0.org1.log 2>&1
  cat peer0.org1.log
  exit 1
fi

# ذخیره لاگ‌ها
docker logs orderer.example.com > orderer.log 2>&1
docker logs peer0.org1.example.com > peer0.org1.log 2>&1
docker logs ca.org1.example.com > ca.org1.log 2>&1
docker logs ca.orderer.example.com > ca.orderer.log 2>&1

# بررسی MSP داخل کانتینر
echo "بررسی MSP داخل کانتینر peer0.org1.example.com..."
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/users/Admin@org1.example.com/msp > msp_dir.log 2>&1
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/users/Admin@org1.example.com/msp/signcerts >> msp_dir.log 2>&1
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/users/Admin@org1.example.com/msp/keystore >> msp_dir.log 2>&1
docker exec peer0.org1.example.com cat /etc/hyperledger/fabric/users/Admin@org1.example.com/msp/config.yaml > msp_config.log 2>&1
cat msp_dir.log
cat msp_config.log

# بررسی گواهی TLS داخل کانتینر
echo "بررسی گواهی TLS داخل کانتینر orderer.example.com و peer0.org1.example.com..."
docker exec orderer.example.com ls -l /etc/hyperledger/fabric/tls/ca.crt > tls_ca.log 2>&1
docker exec peer0.org1.example.com ls -l /etc/hyperledger/fabric/tls/ca.crt >> tls_ca.log 2>&1
cat tls_ca.log

# بررسی گواهی‌های CA
echo "بررسی گواهی‌های CA..."
docker exec ca.org1.example.com ls -l /etc/hyperledger/fabric-ca-server > ca_org1_dir.log 2>&1
docker exec ca.orderer.example.com ls -l /etc/hyperledger/fabric-ca-server > ca_orderer_dir.log 2>&1
cat ca_org1_dir.log
cat ca_orderer_dir.log

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
             --cafile /etc/hyperledger/fabric/tls/ca.crt
  if [ $? -ne 0 ]; then
    echo "خطا در ایجاد کانال $channel"
    echo "لاگ‌های Orderer، Peer و CA را بررسی کنید: orderer.log, peer0.org1.log, ca.org1.log, ca.orderer.log, msp_config.log, msp_dir.log, tls_ca.log, configtx_admins.log, ca_org1_dir.log, ca_orderer_dir.log, container_status.log"
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
               --cafile /etc/hyperledger/fabric/tls/ca.crt \
               -C $channel \
               -n $cc -v 1.0 -c '{"Args":["init"]}' -P "OR('Org1MSP.member','Org2MSP.member','Org3MSP.member','Org4MSP.member','Org5MSP.member','Org6MSP.member','Org7MSP.member','Org8MSP.member','Org9MSP.member','Org10MSP.member')"
    if [ $? -ne 0 ]; then
      echo "خطا در نمونه‌سازی چین‌کد $cc روی کانال $channel"
      exit 1
    fi
  done
done

echo "راه‌اندازی شبکه با موفقیت انجام شد"
