#!/bin/bash

# تابع بررسی خطا
check_error() {
    if [ $? -ne 0 ]; then
        echo "خطا: $1"
        exit 1
    fi
}

echo "تولید قراردادهای هوشمند..."

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

# ایجاد دایرکتوری و فایل برای هر قرارداد
for cc in "${chaincodes[@]}"; do
  mkdir -p chaincode/$cc
  cat > chaincode/$cc/$cc.go << EOL
package main

import (
    "encoding/json"
    "fmt"
    "math"
    "github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct {
    contractapi.Contract
}

type Assignment struct {
    EntityID string  \`json:"entityID"\`
    Antenna  string  \`json:"antenna"\`
    X        float64 \`json:"x"\`
    Y        float64 \`json:"y"\`
}

var antennaLocations = map[string][2]float64{
    "Org1":  {100, 100},
    "Org2":  {200, 100},
    "Org3":  {300, 100},
    "Org4":  {100, 200},
    "Org5":  {200, 200},
    "Org6":  {300, 200},
    "Org7":  {100, 300},
    "Org8":  {200, 300},
    "Org9":  {300, 300},
    "Org10": {400, 300},
}

func (s *SmartContract) AssignEntity(ctx contractapi.TransactionContextInterface, entityID string, x, y float64) error {
    var closestAntenna string
    minDistance := math.MaxFloat64

    for org, loc := range antennaLocations {
        distance := math.Sqrt(math.Pow(loc[0]-x, 2) + math.Pow(loc[1]-y, 2))
        if distance < minDistance {
            minDistance = distance
            closestAntenna = org
        }
    }

    assignment := Assignment{
        EntityID: entityID,
        Antenna:  closestAntenna,
        X:        x,
        Y:        y,
    }

    assignmentBytes, _ := json.Marshal(assignment)
    return ctx.GetStub().PutState(entityID, assignmentBytes)
}

func (s *SmartContract) QueryAssignment(ctx contractapi.TransactionContextInterface, entityID string) (string, error) {
    assignmentBytes, err := ctx.GetStub().GetState(entityID)
    if err != nil {
        return "", fmt.Errorf("خطا در خواندن از ledger: %v", err)
    }
    if assignmentBytes == nil {
        return "", fmt.Errorf("موجودیت %s یافت نشد", entityID)
    }
    return string(assignmentBytes), nil
}

func main() {
    chaincode, err := contractapi.NewChaincode(&SmartContract{})
    if err != nil {
        fmt.Printf("خطا در ایجاد chaincode: %v", err)
    }
    if err := chaincode.Start(); err != nil {
        fmt.Printf("خطا در شروع chaincode: %v", err)
    }
}
EOL
  check_error "تولید chaincode $cc"
done

echo "قراردادهای هوشمند با موفقیت تولید شدند!"
