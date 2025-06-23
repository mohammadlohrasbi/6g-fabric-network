#!/bin/bash

# تابع بررسی خطا
check_error() {
    if [ $? -ne 0 ]; then
        echo "خطا: $1"
        exit 1
    fi
}

# مسیر ذخیره workload
workload_dir="workload"
mkdir -p "$workload_dir"

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

# قالب workload
template=$(cat << 'EOF'
const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

class {{contractName}}Workload extends WorkloadModuleBase {
    constructor() {
        super();
        this.contractId = '{{contractName}}';
        this.contractVersion = 'v1';
        this.entityCount = parseInt(process.env.ENTITY_COUNT || '1000');
    }

    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
        this.entities = [];
        for (let i = 0; i < this.entityCount; i++) {
            const x = (Math.random() * 500).toFixed(2); // مختصات تصادفی بین 0 تا 500
            const y = (Math.random() * 500).toFixed(2);
            this.entities.push({ id: `entity_${workerIndex}_${i}`, x, y });
        }
    }

    async submitTransaction() {
        const entity = this.entities[Math.floor(Math.random() * this.entities.length)];
        const args = {
            contractId: this.contractId,
            contractVersion: this.contractVersion,
            contractFunction: 'AssignEntity',
            contractArguments: [entity.id, entity.x, entity.y],
            readOnly: false
        };
        await this.sutAdapter.sendRequests(args);
    }
}

async function createWorkloadModule() {
    return new {{contractName}}Workload();
}

module.exports.createWorkloadModule = createWorkloadModule;
EOF
)

# تولید فایل‌های workload برای هر قرارداد
for contract in "${contracts[@]}"; do
    contract_lower=$(echo "$contract" | tr '[:upper:]' '[:lower:]')
    echo "Processing workload: $contract_lower.js"
    echo "$template" | sed "s#{{contractName}}#$contract#g" > "$workload_dir/$contract_lower.js"
    check_error "تولید workload $contract_lower.js"
    echo "Generated workload: $contract_lower.js"
done
