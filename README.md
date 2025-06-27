6G Fabric Benchmark Project
This project sets up a Hyperledger Fabric network for benchmarking 70 chaincodes across 14 channels, simulating a 6G network environment. It uses Caliper and Tape for performance testing.
Prerequisites

Docker and Docker Compose
Hyperledger Fabric binaries (cryptogen, configtxgen, peer)
Node.js and npm (for Caliper)
Tape CLI
Bash shell

Project Structure
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

Setup Instructions

Generate Configuration Files:
./generateCoreYamls.sh
./generateConnectionProfiles.sh
./generateChaincodes.sh
./generateWorkloadFiles.sh
./generateTapeConfigs.sh


Setup Network:
./setup_network.sh


Run Caliper Benchmark:
cd caliper
npx caliper launch manager --caliper-workspace . --caliper-benchconfig benchmarkConfig.yaml --caliper-networkconfig networkConfig.yaml


Run Tape Tests:For each Tape configuration file:
tape -c tape/tape-ResourceAllocate-generalchannelapp.yaml


Package Project:
./create_zip.sh



Troubleshooting
If you encounter the error no such host for orderer.example.com:

Verify that the Docker network fabric is running:docker network ls
docker network inspect fabric


Check if the orderer.example.com container is running:docker ps -a
docker logs orderer.example.com


Ensure TLS certificates are correctly generated:cryptogen generate --config=./crypto-config.yaml


Use localhost:7050 instead of orderer.example.com:7050 in setup_network.sh and caliper/networkConfig.yaml.
Add 127.0.0.1 orderer.example.com to /etc/hosts if needed:sudo echo "127.0.0.1 orderer.example.com" >> /etc/hosts


Rebuild the network if issues persist:docker-compose -f docker-compose.yaml down
rm -rf channel-artifacts crypto-config
./setup_network.sh



Notes

The network includes 10 organizations, each with one peer and one CA.
70 chaincodes are deployed across 14 channels (4 shared channels and 10 organization-specific channels).
Ensure ports 7050–16054 are free to avoid conflicts.
Use docker-compose down to stop the network after testing.
