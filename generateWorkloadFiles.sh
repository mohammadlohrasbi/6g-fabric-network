#!/bin/bash

mkdir -p workload
cat << EOF > workload/callback.js
const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

class MyWorkload extends WorkloadModuleBase {
    constructor() {
        super();
        this.chaincodeID = '';
        this.channel = '';
        this.txIndex = 0;
    }

    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
        this.chaincodeID = roundArguments.chaincodeID;
        this.channel = roundArguments.channel;
        this.txNumber = roundArguments.txNumber;
        this.args = roundArguments.args;
    }

    async submitTransaction() {
        const func = this.args[this.txIndex % 2].function;
        const args = this.args[this.txIndex % 2].args;
        const request = {
            contractId: this.chaincodeID,
            channel: this.channel,
            contractVersion: 'v1',
            contractFunction: func,
            contractArguments: args,
            timeout: 30
        };

        await this.sutAdapter.sendRequests(request);
        this.txIndex++;
    }

    async cleanupWorkloadModule() {
        // No cleanup needed
    }

    static createWorkloadModule() {
        return new MyWorkload();
    }
}

module.exports.createWorkloadModule = MyWorkload.createWorkloadModule;
EOF

echo "Generated workload/callback.js"
