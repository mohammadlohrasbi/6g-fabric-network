#!/bin/bash

# Script to generate Caliper benchmark configuration file
# Usage: ./generateBenchmarkConfig.sh [output_file] [comma_separated_chaincodes] [comma_separated_channels]
# Example: ./generateBenchmarkConfig.sh benchmarkConfig.yaml "ResourceAllocate,BandwidthShare" "generalchannelapp,iotchannelapp"

# Default output file
OUTPUT_FILE=${1:-"caliper/benchmarkConfig.yaml"}

# Default chaincodes (70 chaincodes across 7 categories)
ALL_CHAINCODES=(
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

# Default channels (14)
ALL_CHANNELS=(
  "generalchannelapp" "iotchannelapp" "securitychannelapp" "monitoringchannelapp"
  "org1channelapp" "org2channelapp" "org3channelapp" "org4channelapp" "org5channelapp"
  "org6channelapp" "org7channelapp" "org8channelapp" "org9channelapp" "org10channelapp"
)

# Use provided chaincodes or default to all
CHAINCODES=(${2:-${ALL_CHAINCODES[@]}})
if [ -n "$2" ]; then
  IFS=',' read -r -a CHAINCODES <<< "$2"
fi

# Use provided channels or default to all
CHANNELS=(${3:-${ALL_CHANNELS[@]}})
if [ -n "$3" ]; then
  IFS=',' read -r -a CHANNELS <<< "$3"
fi

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

# Start writing the YAML file
cat << EOF > $OUTPUT_FILE
test:
  name: 6G Fabric Benchmark
  description: Benchmark for 6G Fabric Network with selected chaincodes across selected channels
  workers:
    number: 10
  rounds:
EOF

# Generate rounds for each chaincode and channel combination
for chaincode in "${CHAINCODES[@]}"; do
  for channel in "${CHANNELS[@]}"; do
    read -r invoke_func query_func invoke_args query_args < <(get_function_names "$chaincode")
    
    cat << EOF >> $OUTPUT_FILE
    - label: ${chaincode}-${channel}
      description: Test ${chaincode} chaincode on ${channel}
      txNumber: 1000
      rateControl:
        type: fixed-rate
        opts:
          tps: 100
      workload:
        module: ./workload/callback.js
        arguments:
          chaincodeID: ${chaincode}
          channel: ${channel}
          txNumber: 1000
          args:
            - function: ${invoke_func}
              args: ${invoke_args}
            - function: ${query_func}
              args: ${query_args}
EOF
  done
done

echo "Generated $OUTPUT_FILE with $((${#CHAINCODES[@]} * ${#CHANNELS[@]})) rounds."
