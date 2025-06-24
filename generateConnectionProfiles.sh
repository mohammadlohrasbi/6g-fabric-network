#!/bin/bash

# تابع بررسی خطا
check_error() {
    if [ $? -ne 0 ]; then
        echo "خطا: $1"
        exit 1
    fi
}

echo "تولید پروفایل‌های اتصال..."

# تولید networkConfig.yaml برای Caliper
cat > caliper/networkConfig.yaml << EOL
---
name: 6G-Fabric-Network
version: "2.0"
channels:
  generalchannelapp:
    orderers:
      - orderer1.example.com
    peers:
      peer0.org1.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org2.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org3.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org4.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org5.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org6.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org7.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org8.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org9.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org10.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
    chaincodes:
      - GeoAssign
      - GeoUpdate
      - GeoHandover
      - AuthUser
      - AuthIoT
      - ConnectUser
      - ConnectIoT
      - BandwidthAlloc
      - AuthAntenna
      - RegisterUser
      - RegisterIoT
      - RevokeUser
      - RevokeIoT
      - RoleAssign
      - AccessControl
      - AuditIdentity
      - IoTBandwidth
      - AntennaLoad
      - ResourceRequest
      - QoSManage
      - SpectrumShare
      - PriorityAssign
      - ResourceAudit
      - LoadBalance
      - DynamicAlloc
      - AntennaStatus
      - IoTStatus
      - NetworkPerf
      - UserActivity
      - FaultDetect
      - IoTFault
      - TrafficMonitor
      - ReportGenerate
      - LatencyTrack
      - EnergyMonitor
      - Roaming
      - SessionTrack
      - IoTSession
      - Disconnect
      - Billing
      - TransactionLog
      - ConnectionAudit
      - DataEncrypt
      - IoTEncrypt
      - AccessLog
      - IntrusionDetect
      - KeyManage
      - PrivacyPolicy
      - SecureChannel
      - AuditSecurity
      - EnergyOptimize
      - NetworkOptimize
      - IoTAnalytics
      - UserAnalytics
      - SecurityMonitor
      - QuantumEncrypt
      - MultiAntenna
      - EdgeCompute
      - IoTHealth
      - NetworkHealth
      - DataIntegrity
      - PolicyEnforce
      - DynamicRouting
      - BandwidthShare
      - LatencyOptimize
      - FaultPredict
      - IoTConfig
      - UserConfig
      - AntennaConfig
      - PerformanceAudit
      - SecurityAudit
      - DataAnalytics
      - RealTimeMonitor
  iotchannelapp:
    orderers:
      - orderer1.example.com
    peers:
      peer0.org1.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org2.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org3.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org4.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org5.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org6.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org7.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org8.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org9.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org10.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
    chaincodes:
      - AuthIoT
      - ConnectIoT
      - IoTBandwidth
      - IoTStatus
      - IoTFault
      - IoTSession
      - IoTEncrypt
      - IoTAnalytics
      - IoTHealth
      - IoTConfig
  securitychannelapp:
    orderers:
      - orderer1.example.com
    peers:
      peer0.org1.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org2.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org3.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org4.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org5.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org6.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org7.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org8.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org9.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org10.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
    chaincodes:
      - IntrusionDetect
      - KeyManage
      - PrivacyPolicy
      - SecureChannel
      - AuditSecurity
      - SecurityMonitor
      - QuantumEncrypt
      - SecurityAudit
  monitoringchannelapp:
    orderers:
      - orderer1.example.com
    peers:
      peer0.org1.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org2.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org3.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org4.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org5.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org6.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org7.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org8.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org9.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
      peer0.org10.example.com:
        endorsingPeer: true
        chaincodeQuery: true
        ledgerQuery: true
        eventSource: true
    chaincodes:
      - TrafficMonitor
      - ReportGenerate
      - LatencyTrack
      - EnergyMonitor
      - NetworkPerf
      - NetworkHealth
      - PerformanceAudit
      - RealTimeMonitor
      - DataAnalytics
orderers:
  orderer1.example.com:
    url: grpc://orderer1.example.com:7050
    grpcOptions:
      ssl-target-name-override: orderer1.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
peers:
  peer0.org1.example.com:
    url: grpc://peer0.org1.example.com:7051
    grpcOptions:
      ssl-target-name-override: peer0.org1.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  peer0.org2.example.com:
    url: grpc://peer0.org2.example.com:8051
    grpcOptions:
      ssl-target-name-override: peer0.org2.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
  peer0.org3.example.com:
    url: grpc://peer0.org3.example.com:9051
    grpcOptions:
      ssl-target-name-override: peer0.org3.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
  peer0.org4.example.com:
    url: grpc://peer0.org4.example.com:10051
    grpcOptions:
      ssl-target-name-override: peer0.org4.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
  peer0.org5.example.com:
    url: grpc://peer0.org5.example.com:11051
    grpcOptions:
      ssl-target-name-override: peer0.org5.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org5.example.com/peers/peer0.org5.example.com/tls/ca.crt
  peer0.org6.example.com:
    url: grpc://peer0.org6.example.com:12051
    grpcOptions:
      ssl-target-name-override: peer0.org6.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org6.example.com/peers/peer0.org6.example.com/tls/ca.crt
  peer0.org7.example.com:
    url: grpc://peer0.org7.example.com:13051
    grpcOptions:
      ssl-target-name-override: peer0.org7.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org7.example.com/peers/peer0.org7.example.com/tls/ca.crt
  peer0.org8.example.com:
    url: grpc://peer0.org8.example.com:14051
    grpcOptions:
      ssl-target-name-override: peer0.org8.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org8.example.com/peers/peer0.org8.example.com/tls/ca.crt
  peer0.org9.example.com:
    url: grpc://peer0.org9.example.com:15051
    grpcOptions:
      ssl-target-name-override: peer0.org9.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org9.example.com/peers/peer0.org9.example.com/tls/ca.crt
  peer0.org10.example.com:
    url: grpc://peer0.org10.example.com:16051
    grpcOptions:
      ssl-target-name-override: peer0.org10.example.com
    tlsCACerts:
      path: crypto/peerOrganizations/org10.example.com/peers/peer0.org10.example.com/tls/ca.crt
clients:
  client-org1:
    organization: Org1MSP
    credentialStore:
      path: /tmp/hfc-kvs/org1
    connection:
      timeout:
        peer:
          endorser: '300'
          eventHub: '300'
          eventReg: '300'
EOL
check_error "تولید networkConfig.yaml"

echo "پروفایل‌های اتصال با موفقیت تولید شدند!"
