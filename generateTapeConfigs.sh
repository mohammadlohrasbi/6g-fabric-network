#!/bin/bash

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

CHANNELS=(
  "generalchannelapp" "iotchannelapp" "securitychannelapp" "monitoringchannelapp"
  "org1channelapp" "org2channelapp" "org3channelapp" "org4channelapp" "org5channelapp"
  "org6channelapp" "org7channelapp" "org8channelapp" "org9channelapp" "org10channelapp"
)

# Function to determine function names and arguments based on chaincode
get_function_names() {
  local chaincode=$1
  case $chaincode in
    ResourceAllocate)
      echo "AssignResource" "QueryResource" '["resource1", "100", "200", "1000"]' '["resource1"]'
      ;;
    BandwidthShare|DynamicRouting|LoadBalance|LatencyOptimize|EnergyOptimize|NetworkOptimize)
      echo "AssignEntity" "QueryAssignment" '["entity1", "100", "200", "1000"]' '["entity1"]'
      ;;
    SpectrumManage)
      echo "AssignSpectrum" "QuerySpectrum" '["spectrum1", "100", "200"]' '["spectrum1"]'
      ;;
    ResourceScale)
      echo "ScaleResource" "QueryScale" '["resource1", "500"]' '["resource1"]'
      ;;
    ResourcePrioritize)
      echo "PrioritizeResource" "QueryPriority" '["resource1", "high"]' '["resource1"]'
      ;;
    UserAuth|DeviceAuth|AccessControl|TokenAuth|RoleBasedAuth|IdentityVerify|SessionAuth|MultiFactorAuth|AuthPolicy|AuthAudit)
      echo "RegisterUser" "QueryUser" '["user1", "role1"]' '["user1"]'
      ;;
    NetworkMonitor|PerformanceMonitor|TrafficMonitor|ResourceMonitor|HealthMonitor|AlertMonitor|LogMonitor|EventMonitor|MetricsCollector|StatusMonitor)
      echo "RecordMetric" "QueryMetric" '["metric1", "value1"]' '["metric1"]'
      ;;
    Encryption|IntrusionDetect|FirewallRules|SecureChannel|ThreatMonitor|AccessLog|SecurityPolicy|VulnerabilityScan|DataIntegrity|SecureBackup)
      echo "LogEvent" "QueryEvent" '["event1", "details1"]' '["event1"]'
      ;;
    TransactionAudit|ComplianceAudit|AccessAudit|EventAudit|PolicyAudit|DataAudit|UserAudit|SystemAudit|PerformanceAudit|SecurityAudit)
      echo "LogAudit" "QueryAudit" '["audit1", "details1"]' '["audit1"]'
      ;;
    ConfigManage|PolicyManage|ResourceManage|NetworkManage|DeviceManage|UserManage|ServiceManage|EventManage|AlertManage|LogManage)
      echo "UpdateConfig" "QueryConfig" '["config1", "value1"]' '["config1"]'
      ;;
    DataAnalytics|FaultDetect|AnomalyDetect|PredictiveMaintenance|PerformanceAnalytics|TrafficAnalytics|SecurityAnalytics|ResourceAnalytics|EventAnalytics|LogAnalytics)
      echo "AnalyzeData" "QueryAnalysis" '["data1", "value1"]' '["data1"]'
      ;;
    *)
      echo "Register" "Query" '["item1", "value1"]' '["item1"]'
      ;;
  esac
}

mkdir -p tape
for chaincode in "${CHAINCODES[@]}"; do
  for channel in "${CHANNELS[@]}"; do
    read -r invoke_func query_func invoke_args query_args < <(get_function_names "$chaincode")
    cat << EOF > tape/tape-${chaincode}-${channel}.yaml
target: grpc://localhost:7051
channel: ${channel}
chaincode: ${chaincode}
ccType: golang
nProc: 10
testRound: 1
txNumber: [1000]
rate: [100]
arguments:
  - ["${invoke_func}", ${invoke_args}]
  - ["${query_func}", ${query_args}]
contractConfig:
  endorsement:
    orgs: ["Org1MSP", "Org2MSP", "Org3MSP", "Org4MSP", "Org5MSP", "Org6MSP", "Org7MSP", "Org8MSP", "Org9MSP", "Org10MSP"]
EOF
  done
done

echo "Generated tape configs for ${#CHAINCODES[@]} chaincodes across ${#CHANNELS[@]} channels"
