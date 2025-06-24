#!/bin/bash

# تابع بررسی خطا
check_error() {
    if [ $? -ne 0 ]; then
        echo "خطا: $1"
        exit 1
    fi
}

echo "تولید فایل‌های workload..."

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

# ایجاد فایل workload برای هر قرارداد
for cc in "${chaincodes[@]}"; do
  cat > workload/${cc,,}.js << EOL
const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

class ${cc}Workload extends WorkloadModuleBase {
    constructor() {
        super();
        this.entityCount = parseInt(process.env.ENTITY_COUNT) || 1000;
    }

    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
        this.entities = [];
        for (let i = 0; i < this.entityCount; i++) {
            this.entities.push(\`entity\${workerIndex}_\${i}\`);
        }
    }

    async submitTransaction() {
        const entityID = this.entities[Math.floor(Math.random() * this.entities.length)];
        const x = Math.random() * 500;
        const y = Math.random() * 500;

        const request = {
            contractId: '${cc}',
            contractFunction: 'AssignEntity',
            contractArguments: [entityID, x.toString(), y.toString()],
            readOnly: false
        };

        await this.sutAdapter.sendRequests(request);
    }

    async cleanupWorkloadModule() {
        // تمیزکاری
    }
}

function createWorkloadModule() {
    return new ${cc}Workload();
}

module.exports.createWorkloadModule = createWorkloadModule;
EOL
  check_error "تولید workload $cc"
done

echo "فایل‌های workload با موفقیت تولید شدند!"
