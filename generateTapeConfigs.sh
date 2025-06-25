#!/bin/bash

# تابع بررسی خطا
check_error() {
    if [ $? -ne 0 ]; then
        echo "خطا: $1"
        exit 1
    fi
}

echo "تولید فایل‌های tapeConfig.yaml برای تمام قراردادها و کانال‌ها..."

# لیست قراردادها
chaincodes=(
  "GeoAssign" "GeoUpdate" "GeoHandover" "AuthUser" "AuthIoT" "ConnectUser" "ConnectIoT"
  "BandwidthAlloc" "AuthAntenna" "RegisterUser" "RegisterIoT" "RevokeUser" "RevokeIoT"
  "RoleAssign" "AccessControl" "AuditIdentity" "IoTBandwidth" "AntennaLoad" "ResourceRequest"
  "QoSManage" "SpectrumShare" "PriorityAssign" "ResourceAudit" "LoadBalance" "DynamicAlloc"
  "AntennaStatus" "IoTStatus" "NetworkPerf" "UserActivity" "FaultDetect" "IoTFault"
  "TrafficMonitor" "ReportGenerate" "LatencyTrack" "EnergyMonitor" "Roaming" "SessionTrack"
  "IoTSession" "Disconnect" "Billing" "TransactionLog" "ConnectionAudit" "DataEncrypt"
  "IoTEncrypt" "AccessLog" "IntrusionDetect" "KeyManage" "PrivacyPolicy" "SecureChannel"
  "AuditSecurity" "EnergyOptimize" "NetworkOptimize" "IoTAnalytics" "UserAnalytics"
  "SecurityMonitor" "QuantumEncrypt" "MultiAntenna" "EdgeCompute" "IoTHealth" "NetworkHealth"
  "DataIntegrity" "PolicyEnforce" "DynamicRouting" "BandwidthShare" "LatencyOptimize"
  "FaultPredict" "IoTConfig" "UserConfig" "AntennaConfig" "PerformanceAudit" "SecurityAudit"
  "DataAnalytics" "RealTimeMonitor"
)

# لیست کانال‌ها و قراردادهای مرتبط
declare -A channel_chaincodes
channel_chaincodes=(
  ["generalchannelapp"]="GeoAssign GeoUpdate GeoHandover AuthUser ConnectUser BandwidthAlloc AuthAntenna RegisterUser RegisterIoT RevokeUser RevokeIoT RoleAssign AccessControl AuditIdentity AntennaLoad ResourceRequest QoSManage SpectrumShare PriorityAssign ResourceAudit LoadBalance DynamicAlloc AntennaStatus NetworkPerf UserActivity FaultDetect ReportGenerate LatencyTrack EnergyMonitor Roaming SessionTrack Disconnect Billing TransactionLog ConnectionAudit DataEncrypt AccessLog KeyManage PrivacyPolicy EnergyOptimize NetworkOptimize UserAnalytics MultiAntenna EdgeCompute NetworkHealth DataIntegrity PolicyEnforce DynamicRouting BandwidthShare LatencyOptimize FaultPredict UserConfig AntennaConfig PerformanceAudit DataAnalytics RealTimeMonitor"
  ["iotchannelapp"]="AuthIoT ConnectIoT IoTBandwidth IoTStatus IoTFault IoTSession IoTEncrypt IoTAnalytics IoTHealth IoTConfig"
  ["securitychannelapp"]="IntrusionDetect KeyManage PrivacyPolicy SecureChannel AuditSecurity SecurityMonitor QuantumEncrypt SecurityAudit"
  ["monitoringchannelapp"]="TrafficMonitor ReportGenerate LatencyTrack EnergyMonitor NetworkPerf NetworkHealth PerformanceAudit RealTimeMonitor DataAnalytics"
)

# ایجاد دایرکتوری tape
mkdir -p tape
check_error "ایجاد دایرکتوری tape"

# تولید فایل tapeConfig.yaml برای هر قرارداد و کانال
for channel in "${!channel_chaincodes[@]}"; do
  for cc in ${channel_chaincodes[$channel]}; do
    cat > tape/tape-${cc,,}-${channel}.yaml << EOL
---
number: 1000
rate: 100
chaincodeID: ${cc}
channel: ${channel}
contractFunction: AssignEntity
contractArguments:
  - entity\${i}
  - \${Math.random() * 500}
  - \${Math.random() * 500}
orderer: grpc://orderer1.example.com:7050
tls:
  enabled: true
  caFile: crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
peers:
  - grpc://peer0.org1.example.com:7051
  - grpc://peer0.org2.example.com:8051
  - grpc://peer0.org3.example.com:9051
  - grpc://peer0.org4.example.com:10051
  - grpc://peer0.org5.example.com:11051
  - grpc://peer0.org6.example.com:12051
  - grpc://peer0.org7.example.com:13051
  - grpc://peer0.org8.example.com:14051
  - grpc://peer0.org9.example.com:15051
  - grpc://peer0.org10.example.com:16051
msp:
  id: Org1MSP
  path: crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
EOL
    check_error "تولید tapeConfig برای ${cc} در کانال ${channel}"
  done
done

# تولید فایل‌های tapeConfig.yaml برای کانال‌های سازمانی
for i in {1..10}; do
  channel="org${i}channelapp"
  for cc in "${chaincodes[@]}"; do
    cat > tape/tape-${cc,,}-${channel}.yaml << EOL
---
number: 1000
rate: 100
chaincodeID: ${cc}
channel: ${channel}
contractFunction: AssignEntity
contractArguments:
  - entity\${i}
  - \${Math.random() * 500}
  - \${Math.random() * 500}
orderer: grpc://orderer1.example.com:7050
tls:
  enabled: true
  caFile: crypto/peerOrganizations/org${i}.example.com/peers/peer0.org${i}.example.com/tls/ca.crt
peers:
  - grpc://peer0.org${i}.example.com:$((7051 + (i-1)*1000))
msp:
  id: Org${i}MSP
  path: crypto/peerOrganizations/org${i}.example.com/users/Admin@org${i}.example.com/msp
EOL
    check_error "تولید tapeConfig برای ${cc} در کانال ${channel}"
  done
done

echo "فایل‌های tapeConfig.yaml با موفقیت تولید شدند!"
