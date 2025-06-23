const fs = require('fs');

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function generateRandomCoordinates() {
    return { x: getRandomInt(0, 10000), y: getRandomInt(0, 10000) };
}

function getRandomAntenna() {
    const antennas = ['Antenna1', 'Antenna2', 'Antenna3', 'Antenna4', 'Antenna5', 'Antenna6', 'Antenna7', 'Antenna8'];
    return antennas[getRandomInt(0, antennas.length - 1)];
}

function generateUserID(index) {
    return `User_${index}_${getRandomInt(1000, 9999)}`;
}

function generateIoTID(index) {
    return `IoT_${index}_${getRandomInt(1000, 9999)}`;
}

function generateToken(index) {
    return `token_${index}_${getRandomInt(1000, 9999)}`;
}

function generateAmount() {
    return getRandomInt(50, 200).toString();
}

function generateTimestamp() {
    return new Date().toISOString();
}

function generateResource() {
    return `Resource_${getRandomInt(1000, 9999)}`;
}

function generateDetails(index) {
    return `Details_${index}_${getRandomInt(1000, 9999)}`;
}

function generateConfig() {
    const config = {
        number: 1000,
        rateControl: {
            type: 'fixed-rate',
            opts: { tps: 100 }
        },
        rounds: [],
        connectionProfile: 'crypto-config/peerOrganizations/org1.example.com/connection-org1.yaml',
        mspID: 'Org1MSP',
        privateKey: 'crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/priv_sk',
        signedCert: 'crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem'
    };

    const contracts = [
        { name: 'GeoAssign', channel: 'channel0', invoke: 'AssignAntenna', invokeArgs: ['entityID', 'x', 'y'], query: 'QueryAssignment', queryArgs: ['entityID'] },
        { name: 'GeoUpdate', channel: 'channel9', invoke: 'UpdateLocation', invokeArgs: ['entityID', 'x', 'y'], query: 'QueryLocation', queryArgs: ['entityID'] },
        { name: 'GeoHandover', channel: 'channel1', invoke: 'PerformHandover', invokeArgs: ['entityID', 'fromAntenna', 'toAntenna'], query: 'QueryHandover', queryArgs: ['entityID'] },
        { name: 'AuthUser', channel: 'channel9', invoke: 'Authenticate', invokeArgs: ['userID', 'token'], query: 'QueryAuth', queryArgs: ['userID'] },
        { name: 'AuthIoT', channel: 'channel9', invoke: 'AuthenticateIoT', invokeArgs: ['iotID', 'token'], query: 'QueryAuthIoT', queryArgs: ['iotID'] },
        { name: 'ConnectUser', channel: 'channel9', invoke: 'ConnectUser', invokeArgs: ['userID', 'antennaID', 'x', 'y'], query: 'QueryConnection', queryArgs: ['userID'] },
        { name: 'ConnectIoT', channel: 'channel9', invoke: 'ConnectIoT', invokeArgs: ['iotID', 'antennaID', 'x', 'y'], query: 'QueryConnection', queryArgs: ['iotID'] },
        { name: 'BandwidthAlloc', channel: 'channel1', invoke: 'AllocateBandwidth', invokeArgs: ['entityID', 'antennaID', 'startTime', 'amount', 'x', 'y'], query: 'QueryBandwidth', queryArgs: ['entityID', 'txID'] },
        { name: 'AuthAntenna', channel: 'channel1', invoke: 'AuthenticateAntenna', invokeArgs: ['antennaID', 'token'], query: 'QueryAuthAntenna', queryArgs: ['antennaID'] },
        { name: 'RegisterUser', channel: 'channel9', invoke: 'RegisterUser', invokeArgs: ['userID'], query: 'QueryUser', queryArgs: ['userID'] },
        { name: 'RegisterIoT', channel: 'channel9', invoke: 'RegisterIoT', invokeArgs: ['iotID'], query: 'QueryIoT', queryArgs: ['iotID'] },
        { name: 'RevokeUser', channel: 'channel9', invoke: 'RevokeUser', invokeArgs: ['userID'], query: 'QueryRevoke', queryArgs: ['userID'] },
        { name: 'RevokeIoT', channel: 'channel9', invoke: 'RevokeIoT', invokeArgs: ['iotID'], query: 'QueryRevoke', queryArgs: ['iotID'] },
        { name: 'RoleAssign', channel: 'channel0', invoke: 'AssignRole', invokeArgs: ['entityID', 'role'], query: 'QueryRole', queryArgs: ['entityID'] },
        { name: 'AccessControl', channel: 'channel1', invoke: 'GrantAccess', invokeArgs: ['entityID', 'resourceID', 'permission'], query: 'QueryAccess', queryArgs: ['entityID'] },
        { name: 'AuditIdentity', channel: 'channel0', invoke: 'LogIdentity', invokeArgs: ['entityID', 'action'], query: 'QueryAudit', queryArgs: ['entityID'] },
        { name: 'IoTBandwidth', channel: 'channel9', invoke: 'AllocateIoTBandwidth', invokeArgs: ['iotID', 'amount'], query: 'QueryIoTBandwidth', queryArgs: ['iotID'] },
        { name: 'AntennaLoad', channel: 'channel1', invoke: 'UpdateLoad', invokeArgs: ['antennaID', 'load'], query: 'QueryLoad', queryArgs: ['antennaID'] },
        { name: 'ResourceRequest', channel: 'channel9', invoke: 'RequestResource', invokeArgs: ['resourceID', 'userID', 'amount'], query: 'QueryRequest', queryArgs: ['resourceID'] },
        { name: 'QoSManage', channel: 'channel1', invoke: 'SetQoS', invokeArgs: ['entityID', 'qosLevel'], query: 'QueryQoS', queryArgs: ['entityID'] },
        { name: 'SpectrumShare', channel: 'channel0', invoke: 'ShareSpectrum', invokeArgs: ['antennaID', 'amount'], query: 'QuerySpectrum', queryArgs: ['antennaID'] },
        { name: 'PriorityAssign', channel: 'channel9', invoke: 'AssignPriority', invokeArgs: ['entityID', 'priority'], query: 'QueryPriority', queryArgs: ['entityID'] },
        { name: 'ResourceAudit', channel: 'channel0', invoke: 'LogResource', invokeArgs: ['resourceID', 'action'], query: 'QueryResourceAudit', queryArgs: ['resourceID'] },
        { name: 'LoadBalance', channel: 'channel1', invoke: 'BalanceLoad', invokeArgs: ['antennaID', 'load'], query: 'QueryBalance', queryArgs: ['antennaID'] },
        { name: 'DynamicAlloc', channel: 'channel1', invoke: 'AllocateDynamic', invokeArgs: ['entityID', 'resourceID', 'amount'], query: 'QueryDynamic', queryArgs: ['entityID'] },
        { name: 'AntennaStatus', channel: 'channel1', invoke: 'UpdateStatus', invokeArgs: ['antennaID', 'status'], query: 'QueryStatus', queryArgs: ['antennaID'] },
        { name: 'IoTStatus', channel: 'channel9', invoke: 'UpdateIoTStatus', invokeArgs: ['iotID', 'status'], query: 'QueryIoTStatus', queryArgs: ['iotID'] },
        { name: 'NetworkPerf', channel: 'channel0', invoke: 'LogPerformance', invokeArgs: ['metric', 'value'], query: 'QueryPerformance', queryArgs: ['metric'] },
        { name: 'UserActivity', channel: 'channel9', invoke: 'LogActivity', invokeArgs: ['userID', 'action'], query: 'QueryActivity', queryArgs: ['userID'] },
        { name: 'FaultDetect', channel: 'channel1', invoke: 'DetectFault', invokeArgs: ['antennaID', 'fault'], query: 'QueryFault', queryArgs: ['antennaID'] },
        { name: 'IoTFault', channel: 'channel9', invoke: 'DetectIoTFault', invokeArgs: ['iotID', 'fault'], query: 'QueryIoTFault', queryArgs: ['iotID'] },
        { name: 'TrafficMonitor', channel: 'channel1', invoke: 'MonitorTraffic', invokeArgs: ['antennaID', 'traffic'], query: 'QueryTraffic', queryArgs: ['antennaID'] },
        { name: 'ReportGenerate', channel: 'channel0', invoke: 'GenerateReport', invokeArgs: ['reportID', 'content'], query: 'QueryReport', queryArgs: ['reportID'] },
        { name: 'LatencyTrack', channel: 'channel1', invoke: 'TrackLatency', invokeArgs: ['antennaID', 'latency'], query: 'QueryLatency', queryArgs: ['antennaID'] },
        { name: 'EnergyMonitor', channel: 'channel1', invoke: 'MonitorEnergy', invokeArgs: ['antennaID', 'energy'], query: 'QueryEnergy', queryArgs: ['antennaID'] },
        { name: 'Roaming', channel: 'channel0', invoke: 'PerformRoaming', invokeArgs: ['entityID', 'fromAntenna', 'toAntenna'], query: 'QueryRoaming', queryArgs: ['entityID'] },
        { name: 'SessionTrack', channel: 'channel9', invoke: 'TrackSession', invokeArgs: ['userID', 'sessionID'], query: 'QuerySession', queryArgs: ['userID'] },
        { name: 'IoTSession', channel: 'channel9', invoke: 'TrackIoTSession', invokeArgs: ['iotID', 'sessionID'], query: 'QueryIoTSession', queryArgs: ['iotID'] },
        { name: 'Disconnect', channel: 'channel1', invoke: 'DisconnectEntity', invokeArgs: ['entityID', 'antennaID'], query: 'QueryDisconnect', queryArgs: ['entityID'] },
        { name: 'Billing', channel: 'channel9', invoke: 'GenerateBill', invokeArgs: ['userID', 'amount'], query: 'QueryBill', queryArgs: ['userID'] },
        { name: 'TransactionLog', channel: 'channel0', invoke: 'LogTransaction', invokeArgs: ['txID', 'details'], query: 'QueryTransaction', queryArgs: ['txID'] },
        { name: 'ConnectionAudit', channel: 'channel0', invoke: 'LogConnection', invokeArgs: ['entityID', 'action'], query: 'QueryConnectionAudit', queryArgs: ['entityID'] },
        { name: 'DataEncrypt', channel: 'channel9', invoke: 'EncryptData', invokeArgs: ['userID', 'data'], query: 'QueryEncryptedData', queryArgs: ['userID'] },
        { name: 'IoTEncrypt', channel: 'channel9', invoke: 'EncryptIoTData', invokeArgs: ['iotID', 'data'], query: 'QueryEncryptedIoTData', queryArgs: ['iotID'] },
        { name: 'AccessLog', channel: 'channel1', invoke: 'LogAccess', invokeArgs: ['entityID', 'resourceID'], query: 'QueryAccessLog', queryArgs: ['entityID'] },
        { name: 'IntrusionDetect', channel: 'channel0', invoke: 'DetectIntrusion', invokeArgs: ['entityID', 'details'], query: 'QueryIntrusion', queryArgs: ['entityID'] },
        { name: 'KeyManage', channel: 'channel0', invoke: 'ManageKey', invokeArgs: ['entityID', 'key'], query: 'QueryKey', queryArgs: ['entityID'] },
        { name: 'PrivacyPolicy', channel: 'channel1', invoke: 'SetPolicy', invokeArgs: ['entityID', 'policy'], query: 'QueryPolicy', queryArgs: ['entityID'] },
        { name: 'SecureChannel', channel: 'channel1', invoke: 'CreateChannel', invokeArgs: ['entityID', 'channelID'], query: 'QueryChannel', queryArgs: ['entityID'] },
        { name: 'AuditSecurity', channel: 'channel0', invoke: 'LogSecurity', invokeArgs: ['entityID', 'action'], query: 'QuerySecurityAudit', queryArgs: ['entityID'] }
    ];

    contracts.forEach(contract => {
        config.rounds.push({
            label: `${contract.name}_Invoke`,
            contractID: contract.name,
            channel: contract.channel,
            function: contract.invoke,
            arguments: []
        });
        config.rounds.push({
            label: `${contract.name}_Query`,
            contractID: contract.name,
            channel: contract.channel,
            function: contract.query,
            arguments: []
        });
    });

    for (let i = 0; i < 500; i++) {
        const userID = generateUserID(i);
        const iotID = generateIoTID(i);
        const coords = generateRandomCoordinates();
        const antennaID = getRandomAntenna();
        const fromAntenna = getRandomAntenna();
        const toAntenna = getRandomAntenna();
        const token = generateToken(i);
        const amount = generateAmount();
        const startTime = generateTimestamp();
        const txID = `tx_${i}`;
        const resourceID = generateResource();
        const action = generateDetails(i);
        const role = generateDetails(i);
        const permission = generateDetails(i);
        const qosLevel = generateDetails(i);
        const priority = generateDetails(i);
        const load = generateAmount();
        const status = generateDetails(i);
        const fault = generateDetails(i);
        const traffic = generateDetails(i);
        const content = generateDetails(i);
        const latency = generateDetails(i);
        const energy = generateDetails(i);
        const sessionID = `id_${i}`;
        const channelID = `id_${i}`;
        const reportID = `id_${i}`;
        const metric = `id_${i}`;
        const value = generateAmount();
        const data = generateDetails(i);
        const key = generateDetails(i);
        const policy = generateDetails(i);
        const details = generateDetails(i);

        contracts.forEach((contract, index) => {
            const invokeRound = config.rounds[index * 2];
            const queryRound = config.rounds[index * 2 + 1];
            const args = contract.invokeArgs.map(arg => {
                if (arg === 'entityID') return userID;
                if (arg === 'userID') return userID;
                if (arg === 'iotID') return iotID;
                if (arg === 'x') return coords.x.toString();
                if (arg === 'y') return coords.y.toString();
                if (arg === 'antennaID') return antennaID;
                if (arg === 'fromAntenna') return fromAntenna;
                if (arg === 'toAntenna') return toAntenna;
                if (arg === 'token') return token;
                if (arg === 'amount') return amount;
                if (arg === 'startTime') return startTime;
                if (arg === 'txID') return txID;
                if (arg === 'resourceID') return resourceID;
                if (arg === 'action') return action;
                if (arg === 'role') return role;
                if (arg === 'permission') return permission;
                if (arg === 'qosLevel') return qosLevel;
                if (arg === 'priority') return priority;
                if (arg === 'load') return load;
                if (arg === 'status') return status;
                if (arg === 'fault') return fault;
                if (arg === 'traffic') return traffic;
                if (arg === 'content') return content;
                if (arg === 'latency') return latency;
                if (arg === 'energy') return energy;
                if (arg === 'sessionID') return sessionID;
                if (arg === 'channelID') return channelID;
                if (arg === 'reportID') return reportID;
                if (arg === 'metric') return metric;
                if (arg === 'value') return value;
                if (arg === 'data') return data;
                if (arg === 'key') return key;
                if (arg === 'policy') return policy;
                if (arg === 'details') return details;
                return arg;
            });
            const queryArgs = contract.queryArgs.map(arg => {
                if (arg === 'entityID') return userID;
                if (arg === 'userID') return userID;
                if (arg === 'iotID') return iotID;
                if (arg === 'txID') return txID;
                if (arg === 'resourceID') return resourceID;
                if (arg === 'antennaID') return antennaID;
                if (arg === 'metric') return metric;
                if (arg === 'reportID') return reportID;
                return arg;
            });
            invokeRound.arguments.push(args);
            queryRound.arguments.push(queryArgs);
        });
    }

    fs.writeFileSync('tape-config.yaml', JSON.stringify(config, null, 2));
}

generateConfig();
