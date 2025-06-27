# 6G Hyperledger Fabric Network

This project implements a Hyperledger Fabric network tailored for 6G applications, featuring 10 organizations (Org1 to Org10), multiple channels (General, IoT, Security, Monitoring, and organization-specific channels), and up to 70 chaincodes for resource allocation, bandwidth sharing, security, and monitoring. The network uses an `etcdraft` consensus mechanism, with one Orderer node, multiple Peer nodes, and Certificate Authorities (CAs) per organization. This README provides a comprehensive guide to setting up, running, and testing the network using `tape` and `caliper`, along with explanations of all shell scripts.

## Project Structure

The project directory (`~/6g-fabric-network`) is organized as follows:

- `caliper/`:
  - `benchmarkConfig.yaml`: Defines Caliper benchmarking parameters (e.g., transaction rate, number of transactions).
  - `networkConfig.yaml`: Specifies network details for Caliper, including Orderer and Peer endpoints, MSPs, and TLS certificates.
- `tape/`:
  - Contains 980 configuration files (e.g., `tape-ResourceAllocate-generalchannelapp.yaml`, `tape-BandwidthShare-iotchannelapp.yaml`) for testing each chaincode on each channel using `tape`.
- `workload/`:
  - `callback.js`: Defines the workload module for Caliper, specifying chaincode functions to invoke during benchmarking.
- `chaincode/`:
  - Contains directories for up to 70 chaincodes (e.g., `ResourceAllocate/`, `BandwidthShare/`), each with Go source code (e.g., `main.go` or a placeholder like `dummy.go`).
- `channel-artifacts/`:
  - Contains 14 channel transaction files (e.g., `generalchannelapp.tx`, `iotchannelapp.tx`) and the genesis block (`genesis.block`).
- `crypto-config/`:
  - `peerOrganizations/`: Stores MSP and TLS certificates for Org1 to Org10.
  - `ordererOrganizations/`: Stores MSP and TLS certificates for the Orderer.
- `crypto-config.yaml`: Configures the organizational structure for `cryptogen` to generate certificates.
- `configtx.yaml`: Defines channel profiles, policies (e.g., `ANY Admins` for application channels), and `etcdraft` consensus settings.
- `docker-compose.yaml`: Defines Docker services for the Orderer, Peers, and CAs.
- `core-org1.yaml` **to** `core-org10.yaml`: Configuration files for each organization’s Peer nodes, specifying logging, chaincode, and ledger settings.
- `setup_network.sh`: Script to set up the network, generate artifacts, and deploy chaincodes.
- `generateCoreYamls.sh`: Script to generate `core-org*.yaml` files for each organization.
- `generateConnectionProfiles.sh`: Script to generate connection profiles for interacting with the network.
- `generateChaincodes.sh`: Script to generate placeholder chaincode directories and files.
- `generateWorkloadFiles.sh`: Script to generate Caliper workload files (e.g., `callback.js`).
- `generateTapeConfigs.sh`: Script to generate 980 `tape` configuration files.
- `create_zip.sh`: Script to package the project into a zip archive.
- `production/`: Directory for persistent data of Orderer and Peer nodes (created during setup).

## Prerequisites

- **Software**:
  - Docker (version 20.10 or higher)
  - Docker Compose (version 1.29 or higher)
  - Hyperledger Fabric tools (`cryptogen`, `configtxgen`) version 2.4.9
  - Node.js (version 16 or higher, for `tape` and `caliper`)
  - Hyperledger Caliper (version 0.5.0 or higher)
  - Go (version 1.18 or higher, for chaincode development)
- **System**: Linux or macOS is recommended.
- **Installation Commands**:

  ```bash
  # Install Fabric binaries
  curl -sSL https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/bootstrap.sh | bash -s -- 2.4.9
  # Install Node.js
  curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
  apt-get install -y nodejs
  # Install tape
  npm install -g tape
  # Install Caliper
  npm install -g @hyperledger/caliper-cli@0.5.0
  npx caliper bind --caliper-bind-sut fabric:2.4
  # Install Go
  wget https://golang.org/dl/go1.18.10.linux-amd64.tar.gz
  tar -C /usr/local -xzf go1.18.10.linux-amd64.tar.gz
  export PATH=$PATH:/usr/local/go/bin
  ```

## Setup Instructions

1. **Prepare the Environment**:

   ```bash
   cd ~/6g-fabric-network
   docker-compose -f docker-compose.yaml down
   docker rm -f $(docker ps -a -q)
   docker network rm 6g-fabric-network_fabric
   rm -rf channel-artifacts crypto-config production
   mkdir -p channel-artifacts production chaincode caliper tape workload
   ```

2. **Save Configuration Files**:

   - Save the following files in `~/6g-fabric-network`:
     - `crypto-config.yaml`
     - `configtx.yaml`
     - `docker-compose.yaml`
     - `core-org1.yaml` to `core-org10.yaml`
     - `setup_network.sh`
     - `generateCoreYamls.sh`
     - `generateConnectionProfiles.sh`
     - `generateChaincodes.sh`
     - `generateWorkloadFiles.sh`
     - `generateTapeConfigs.sh`
     - `create_zip.sh`
   - Make shell scripts executable:

     ```bash
     chmod +x *.sh
     dos2unix *.sh
     ```

3. **Generate Configuration Files**:

   - Run scripts to generate necessary configurations:

     ```bash
     ./generateCoreYamls.sh
     ./generateConnectionProfiles.sh
     ./generateChaincodes.sh
     ./generateWorkloadFiles.sh
     ./generateTapeConfigs.sh
     ```

4. **Prepare Chaincode**:

   - Ensure all 70 chaincode directories exist in `./chaincode`. The `generateChaincodes.sh` script creates placeholders if needed:

     ```bash
     ls -l ./chaincode
     # Example: Create a placeholder if missing
     mkdir -p ./chaincode/ResourceAllocate
     echo 'package main' > ./chaincode/ResourceAllocate/dummy.go
     ```

5. **Run the Network**:

   ```bash
   ./setup_network.sh
   ```

   - This script generates cryptographic materials, channel artifacts, starts the network, creates/joins channels, and installs/instantiates chaincodes.
   - Wait approximately 90 seconds for the network to stabilize.

6. **Verify the Network**:

   ```bash
   docker ps
   docker logs orderer.example.com
   docker logs peer0.org1.example.com
   ```

## Testing the Network

### Using Tape

The `tape` tool tests transaction performance for each chaincode on each channel using the 980 configuration files in the `tape/` directory.

#### Running Tape Tests

- **Single Test Example**:

  ```bash
  export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp
  export CORE_PEER_LOCALMSPID=Org1MSP
  export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
  export CORE_PEER_TLS_ENABLED=true
  export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
  export ORDERER_CA=/etc/hyperledger/fabric/tls/orderer-ca.crt
  docker exec peer0.org1.example.com tape \
    --config ./tape/tape-ResourceAllocate-generalchannelapp.yaml \
    --orderer orderer.example.com:7050 \
    --tls \
    --cafile $ORDERER_CA \
    --n 100 \
    --cps 10
  ```
- **Batch Testing**:
  - Run all 980 tests using a loop:

    ```bash
    for config in tape/*.yaml; do
      docker exec peer0.org1.example.com tape \
        --config $config \
        --orderer orderer.example.com:7050 \
        --tls \
        --cafile $ORDERER_CA \
        --n 100 \
        --cps 10
    done
    ```

#### Example Tape Configuration (`tape-ResourceAllocate-generalchannelapp.yaml`)

```yaml
channel: generalchannelapp
chaincode: ResourceAllocate
args: '{"Function":"init","Args":[]}'
```

- **Purpose**: Specifies the channel and chaincode to test, along with the function to invoke.
- **Output**: Generates metrics like transaction throughput and latency.

### Using Caliper

The `caliper` tool benchmarks the network using configurations in `caliper/` and `workload/`.

#### Running Caliper Tests

- **Setup**:
  - Ensure `caliper/benchConfig.yaml`, `caliper/networkConfig.yaml`, and `workload/callback.js` exist (generated by `generateWorkloadFiles.sh`).
- **Run Test**:

  ```bash
  npx caliper launch manager \
    --caliper-workspace ./ \
    --caliper-networkconfig ./caliper/networkConfig.yaml \
    --caliper-benchconfig ./caliper/benchmarkConfig.yaml \
    --caliper-fabric-gateway-enabled
  ```
- **Output**: Generates an HTML report with metrics (e.g., throughput, latency, resource usage).

#### Example Caliper Configurations

- **benchmarkConfig.yaml**:

  ```yaml
  test:
    name: 6g-fabric-benchmark
    description: Benchmark for 6G Fabric network
    workers:
      number: 5
    rounds:
      - label: invoke
        txNumber: 1000
        rateControl:
          type: fixed-rate
          opts:
            tps: 50
        workload:
          module: workload/callback.js
  ```
- **networkConfig.yaml**:

  ```yaml
  caliper:
    blockchain: fabric
  fabric:
    network:
      orderer:
        - url: grpcs://orderer.example.com:7050
          msp: OrdererMSP
          tlsCACerts:
            path: ./crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
      peers:
        - url: grpcs://peer0.org1.example.com:7051
          msp: Org1MSP
          tlsCACerts:
            path: ./crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  ```
- **callback.js**:

  ```javascript
  'use strict';
  module.exports.info = 'Invoking chaincode';
  let bc, contx;
  module.exports.init = async function(blockchain, context, args) {
      bc = blockchain;
      contx = context;
  };
  module.exports.run = async function() {
      let args = {
          chaincodeFunction: 'init',
          chaincodeArguments: []
      };
      return bc.invokeSmartContract(contx, 'ResourceAllocate', '1.0', args, 30);
  };
  module.exports.end = async function() {
      return Promise.resolve();
  };
  ```

## Shell Script Explanations

### setup_network.sh

- **Purpose**: Sets up the entire Hyperledger Fabric network.
- **Key Steps**:
  - Verifies prerequisites (`cryptogen`, `configtxgen`, `docker`, `docker-compose`).
  - Generates cryptographic materials using `crypto-config.yaml`.
  - Creates genesis block and channel transactions using `configtx.yaml`.
  - Starts Docker containers using `docker-compose.yaml`.
  - Creates and joins 14 channels (e.g., `generalchannelapp`, `iotchannelapp`, `org1channelapp`).
  - Installs and instantiates up to 70 chaincodes on all peers and channels.
  - Includes checks for chaincode directories and creates placeholders if missing.
- **Usage**:

  ```bash
  ./setup_network.sh
  ```
- **Notes**: Waits 90 seconds for network stabilization. Uses `core-org*.yaml` for peer configurations.

### generateCoreYamls.sh

- **Purpose**: Generates `core-org1.yaml` to `core-org10.yaml` files for each organization’s Peer nodes.
- **Key Steps**:
  - Creates YAML files with peer configurations (e.g., logging levels, chaincode execution settings, ledger state database).
  - Example content for `core-org1.yaml`:

    ```yaml
    peer:
      id: peer0.org1.example.com
      address: peer0.org1.example.com:7051
      localMspId: Org1MSP
      logLevel: info
      chaincode:
        builder: external
        startuptimeout: 300s
      state:
        stateDatabase: goleveldb
    ```
  - Loops through Org1 to Org10 to create 10 files.
- **Usage**:

  ```bash
  ./generateCoreYamls.sh
  ```
- **Notes**: Ensures consistent peer configurations across organizations.

### generateConnectionProfiles.sh

- **Purpose**: Generates connection profiles (e.g., JSON files) for client applications to interact with the network.
- **Key Steps**:
  - Creates a connection profile per organization, specifying Orderer and Peer endpoints, MSPs, and TLS certificates.
  - Example output: `connection-org1.json`.
- **Usage**:

  ```bash
  ./generateConnectionProfiles.sh
  ```
- **Notes**: Used by `caliper` and other client applications.

### generateChaincodes.sh

- **Purpose**: Generates placeholder directories and files for the 70 chaincodes in `./chaincode`.
- **Key Steps**:
  - Creates directories like `ResourceAllocate/`, `BandwidthShare/`, etc.
  - Adds a minimal Go file (e.g., `dummy.go`) to each directory:

    ```go
    package main
    ```
  - Ensures `setup_network.sh` can install chaincodes without errors.
- **Usage**:

  ```bash
  ./generateChaincodes.sh
  ```
- **Notes**: Replace placeholders with actual chaincode logic before deployment.

### generateWorkloadFiles.sh

- **Purpose**: Generates Caliper workload files, such as `callback.js` in the `workload/` directory.
- **Key Steps**:
  - Creates `callback.js` with a template for invoking chaincode functions.
  - Supports multiple chaincodes by generating workload files per chaincode if needed.
- **Usage**:

  ```bash
  ./generateWorkloadFiles.sh
  ```
- **Notes**: Ensures Caliper can run benchmarks with the correct workload.

### generateTapeConfigs.sh

- **Purpose**: Generates 980 `tape` configuration files in the `tape/` directory for each chaincode-channel combination.
- **Key Steps**:
  - Iterates over 70 chaincodes and 14 channels to create YAML files like `tape-ResourceAllocate-generalchannelapp.yaml`.
  - Example content:

    ```yaml
    channel: generalchannelapp
    chaincode: ResourceAllocate
    args: '{"Function":"init","Args":[]}'
    ```
- **Usage**:

  ```bash
  ./generateTapeConfigs.sh
  ```
- **Notes**: Enables comprehensive performance testing with `tape`.

### create_zip.sh

- **Purpose**: Packages the project directory into a zip archive for distribution or backup.
- **Key Steps**:
  - Creates a zip file (e.g., `6g-fabric-network.zip`) including all configurations, scripts, and chaincode.
  - Excludes `production/` to avoid including runtime data.
- **Usage**:

  ```bash
  ./create_zip.sh
  ```
- **Notes**: Useful for sharing the project setup.

## Troubleshooting

### Error: `etcdraft configuration missing`

- **Cause**: Missing `EtcdRaft` configuration in `configtx.yaml`.
- **Solution**:
  - Verify `configtx.yaml` includes:

    ```yaml
    EtcdRaft:
      Consenters:
        - Host: orderer.example.com
          Port: 7050
          ClientTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
          ServerTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
    ```
  - Check TLS certificates:

    ```bash
    ls -l crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
    ```
  - Regenerate artifacts:

    ```bash
    export FABRIC_CFG_PATH=$PWD
    configtxgen -profile OrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block
    ```

### Error: `policy for [Group] /Channel/Application not satisfied`

- **Cause**: Invalid admin identity.
- **Solution**:
  - Verify `ANY Admins` policy in `configtx.yaml` for application channels.
  - Check admin MSP:

    ```bash
    ls -l crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    ```
  - Test channel creation:

    ```bash
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org1MSP" \
               peer0.org1.example.com peer channel create \
               -o orderer.example.com:7050 \
               -c org2channelapp \
               -f /etc/hyperledger/configtx/org2channelapp.tx \
               --outputBlock /etc/hyperledger/configtx/org2channelapp.block \
               --tls \
               --cafile /etc/hyperledger/fabric/tls/orderer-ca.crt
    ```

### Chaincode Installation Error

- **Cause**: Missing chaincode directories or files.
- **Solution**:
  - Verify chaincode directories:

    ```bash
    ls -l ./chaincode
    docker exec peer0.org1.example.com ls -l /opt/gopath/src/github.com/chaincode
    ```
  - Run `generateChaincodes.sh` to create placeholders:

    ```bash
    ./generateChaincodes.sh
    ```

### Orderer Connection Error

- **Cause**: Orderer is inaccessible or TLS is misconfigured.
- **Solution**:
  - Check Orderer logs:

    ```bash
    docker logs orderer.example.com | grep -i "error"
    ```
  - Verify TLS certificates:

    ```bash
    ls -l crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls
    ```

## Notes

- **Chaincodes**: Ensure all 70 chaincode directories are populated with valid Go code or placeholders before running `setup_network.sh`.
- **Cleanup**: To reset the network:

  ```bash
  docker-compose -f docker-compose.yaml down
  docker rm -f $(docker ps -a -q)
  rm -rf channel-artifacts crypto-config production
  ```
- **Logs**: For debugging, save logs:

  ```bash
  docker logs orderer.example.com > orderer.log
  docker logs peer0.org1.example.com > peer0.org1.log
  ```

## Support

For issues, share the following logs:

```bash
docker logs orderer.example.com > orderer.log
docker logs peer0.org1.example.com > peer0.org1.log
```
