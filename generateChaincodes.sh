#!/bin/bash

# تابع بررسی خطا
check_error() {
    if [ $? -ne 0 ]; then
        echo "خطا: $1"
        exit 1
    fi
}

# مسیر ذخیره chaincode
contract_dir="chaincode"
mkdir -p "$contract_dir"

# لیست قراردادها
contracts=(
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

# قالب chaincode
template=$(cat << 'EOF'
package main

import (
    "encoding/json"
    "fmt"
    "math"
    "strconv"
    "github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type {{contractName}}Contract struct {
    contractapi.Contract
}

// تعریف ساختار تخصیص
type Assignment struct {
    EntityID  string `json:"entityid"`
    AntennaID string `json:"antennaid"`
    X         float64 `json:"x"`
    Y         float64 `json:"y"`
    Timestamp string `json:"timestamp"`
}

// مختصات ثابت آنتن‌ها (Org1 تا Org10)
var antennas = map[string][2]float64{
    "Org1":  {100.0, 100.0},
    "Org2":  {200.0, 100.0},
    "Org3":  {300.0, 100.0},
    "Org4":  {100.0, 200.0},
    "Org5":  {200.0, 200.0},
    "Org6":  {300.0, 200.0},
    "Org7":  {100.0, 300.0},
    "Org8":  {200.0, 300.0},
    "Org9":  {300.0, 300.0},
    "Org10": {400.0, 300.0},
}

// محاسبه فاصله اقلیدسی
func calculateDistance(x1, y1, x2, y2 float64) float64 {
    return math.Sqrt(math.Pow(x2-x1, 2) + math.Pow(y2-y1, 2))
}

// پیدا کردن نزدیک‌ترین آنتن
func findNearestAntenna(x, y float64) string {
    minDistance := math.MaxFloat64
    nearestAntenna := ""
    for org, coords := range antennas {
        distance := calculateDistance(x, y, coords[0], coords[1])
        if distance < minDistance {
            minDistance = distance
            nearestAntenna = org
        }
    }
    return nearestAntenna
}

func (s *{{contractName}}Contract) AssignEntity(ctx contractapi.TransactionContextInterface, entityID, xStr, yStr string) error {
    if entityID == "" || xStr == "" || yStr == "" {
        return fmt.Errorf("ورودی‌ها نمی‌توانند خالی باشند")
    }

    x, err := strconv.ParseFloat(xStr, 64)
    if err != nil {
        return fmt.Errorf("خطا در تبدیل x: %v", err)
    }
    y, err := strconv.ParseFloat(yStr, 64)
    if err != nil {
        return fmt.Errorf("خطا در تبدیل y: %v", err)
    }

    antennaID := findNearestAntenna(x, y)
    if antennaID == "" {
        return fmt.Errorf("هیچ آنتن‌ها یافت نشد")
    }

    data := Assignment{
        EntityID:  entityID,
        AntennaID: antennaID,
        X:         x,
        Y:         y,
        Timestamp: ctx.GetStub().GetTxTimestamp().String(),
    }

    dataJSON, err := json.Marshal(data)
    if err != nil {
        return fmt.Errorf("خطا در سریال‌سازی: %v", err)
    }

    err = ctx.GetStub().PutState(entityID, dataJSON)
    if err != nil {
        return fmt.Errorf("خطا در ثبت داده: %v", err)
    }

    return nil
}

func (s *{{contractName}}Contract) QueryAssignment(ctx contractapi.TransactionContextInterface, entityID string) (*Assignment, error) {
    dataJSON, err := ctx.GetStub().GetState(entityID)
    if err != nil {
        return nil, fmt.Errorf("خطا در خواندن داده‌ها: %v", err)
    }
    if dataJSON == nil {
        return nil, fmt.Errorf("داده برای %s یافت نشد", entityID)
    }

    var data Assignment
    err = json.Unmarshal(dataJSON, &data)
    if err != nil {
        return nil, fmt.Errorf("خطا در دی‌سریال‌سازی: %v", err)
    }
    return &data, nil
}

func main() {
    contract := new({{contractName}}Contract)
    contract.Name = "{{contractName}}"
    contractapi.Start(contract)
}
EOF
)

# تولید chaincode برای هر قرارداد
for contract in "${contracts[@]}"; do
    echo "Processing contract: $contract"
    echo "$template" | sed "s#{{contractName}}#$contract#g" > "$contract_dir/$contract.go"
    check_error "تولید chaincode $contract.go"
    echo "Generated chaincode: $contract.go"
done
