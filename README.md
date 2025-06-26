# 6G Fabric Benchmark Project

This project sets up a Hyperledger Fabric network for benchmarking 70 chaincodes across 14 channels, simulating a 6G network environment. It uses Caliper and Tape for performance testing.

## Prerequisites
- Docker and Docker Compose
- Hyperledger Fabric binaries (`cryptogen`, `configtxgen`, `peer`)
- Node.js and npm (for Caliper)
- Tape CLI
- Bash shell

## Project Structure
```
project/
├── caliper/
│   ├── benchmarkConfig.yaml
│   └── networkConfig.yaml
├── tape/
│   ├── tape-ResourceAllocate-generalchannelapp.yaml
│   ├── tape-BandwidthShare-iotchannelapp.yaml
│   └── ... (980 files for all chaincodes and channels)
├── workload/
│   ├── callback.js
├── chaincode/
│   ├── ResourceAllocate/
│   ├── BandwidthShare/
│   └── ... (70 chaincodes)
├── channel-artifacts/
│   ├── generalchannelapp.tx
│   ├── iotchannelapp.tx
│   └── ... (14 channel artifacts)
├── crypto-config/
│   ├── peerOrganizations/
│   └── ordererOrganizations/
├── crypto-config.yaml
├── configtx.yaml
├── docker-compose.yaml
├── core-org1.yaml
├── core-org2.yaml
├── ... (core-org3.yaml to core-org10.yaml)
├── setup_network.sh
├── generateCoreYamls.sh
├── generateConnectionProfiles.sh
├── generateChaincodes.sh
├── generateWorkloadFiles.sh
├── generateTapeConfigs.sh
├── create_zip.sh
└── README.md
```

## Setup Instructions
1. **Generate Configuration Files**:
   ```bash
   ./generateCoreYamls.sh
   ./generateConnectionProfiles.sh
   ./generateChaincodes.sh
   ./generateWorkloadFiles.sh
   ./generateTapeConfigs.sh
   ```

2. **Setup Network**:
   ```bash
   ./setup_network.sh
   ```

3. **Run Caliper Benchmark**:
   ```bash
   cd caliper
   npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarkConfig.yaml --caliper-networkconfig networkConfig.yaml
   ```

4. **Run Tape Tests**:
   For each Tape configuration file:
   ```bash
   tape -c tape/tape-ResourceAllocate-generalchannelapp.yaml
   ```

5. **Package Project**:
   ```bash
   ./create_zip.sh
   ```

## Notes
- The network includes 10 organizations, each with one peer and one CA.
- 70 chaincodes are deployed across 14 channels (4 shared channels and 10 organization-specific channels).
- Use `docker-compose down` to stop the network after testing.
- Ensure ports 7050–16054 are free to avoid conflicts.
