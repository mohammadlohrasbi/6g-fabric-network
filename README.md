# شبکه هایپرلجر فابریک 6G

این پروژه یک شبکه هایپرلجر فابریک برای کاربردهای 6G پیاده‌سازی می‌کند که شامل 10 سازمان (Org1 تا Org10)، 14 کانال (عمومی، IoT، امنیتی، نظارتی، و کانال‌های خاص سازمانی)، و 70 چین‌کد برای تخصیص منابع، اشتراک پهنای باند، امنیت، و نظارت است. شبکه از مکانیزم اجماع `etcdraft` با یک گره Orderer، چندین گره Peer، و مقامات گواهی (CA) برای هر سازمان استفاده می‌کند. این README دستورالعمل‌های جامعی برای راه‌اندازی، اجرا، و آزمایش شبکه با استفاده از `tape` و `caliper`، همراه با توضیحات تمام اسکریپت‌های شل و عیب‌یابی پیشرفته ارائه می‌دهد.

## ساختار پروژه
دایرکتوری پروژه (`~/6g-fabric-network`) به‌صورت زیر سازمان‌دهی شده است:

- **`caliper/`**:
  - `benchmarkConfig.yaml`: پارامترهای بنچمارک Caliper (مانند نرخ تراکنش، تعداد تراکنش‌ها).
  - `networkConfig.yaml`: جزئیات شبکه برای Caliper، شامل نقاط انتهایی Orderer و Peer، MSPها، و گواهی‌های TLS.
- **`tape/`**:
  - 980 فایل تنظیمات (مانند `tape-ResourceAllocate-generalchannelapp.yaml`) برای آزمایش هر چین‌کد روی هر کانال با `tape`.
- **`workload/`**:
  - `callback.js`: ماژول بار کاری برای Caliper، مشخص‌کننده توابع چین‌کد برای بنچمارک.
- **`chaincode/`**:
  - دایرکتوری‌های 70 چین‌کد (مانند `ResourceAllocate/`، `BandwidthShare/`) با کد Go یا فایل‌های نگهدارنده (`dummy.go`).
- **`channel-artifacts/`**:
  - 14 فایل تراکنش کانال (مانند `generalchannelapp.tx`) و بلاک جنسیس (`genesis.block`).
- **`crypto-config/`**:
  - `peerOrganizations/`: MSP و TLS برای Org1 تا Org10.
  - `ordererOrganizations/`: MSP و TLS برای Orderer.
- **`crypto-config.yaml`**: ساختار سازمانی برای تولید گواهی‌ها با `cryptogen`.
- **`configtx.yaml`**: پروفایل‌های کانال، سیاست‌ها (`ANY Admins`، `ANY Readers`، `ANY Writers`)، و تنظیمات `etcdraft`.
- **`docker-compose.yaml`**: سرویس‌های داکر برای Orderer، Peerها، و CAها.
- **`core-org1.yaml` تا `core-org10.yaml`**: تنظیمات گره‌های Peer (لاگ، چین‌کد، لجر).
- **`setup_network.sh`**: راه‌اندازی شبکه، تولید آرتیفکت‌ها، و استقرار چین‌کدها.
- **`generateCoreYamls.sh`**: تولید فایل‌های `core-org*.yaml`.
- **`generateConnectionProfiles.sh`**: تولید پروفایل‌های اتصال.
- **`generateChaincodes.sh`**: تولید دایرکتوری‌های نگهدارنده چین‌کد.
- **`generateWorkloadFiles.sh`**: تولید فایل‌های بار کاری Caliper.
- **`generateTapeConfigs.sh`**: تولید 980 فایل تنظیمات `tape`.
- **`create_zip.sh`**: بسته‌بندی پروژه به زیپ.
- **`production/`**: داده‌های پایدار Orderer و Peerها (ایجاد در راه‌اندازی).

## پیش‌نیازها
- **نرم‌افزار**:
  - داکر (نسخه 20.10 یا بالاتر)
  - داکر کامپوز (نسخه 1.29 یا بالاتر)
  - ابزارهای فابریک (`cryptogen`، `configtxgen`) نسخه 2.4.9
  - Node.js (نسخه 16 یا بالاتر)
  - Hyperledger Caliper (نسخه 0.5.0 یا بالاتر)
  - Go (نسخه 1.18 یا بالاتر)
- **سیستم**: لینوکس یا macOS.
- **دستورات نصب**:
  ```bash
  curl -sSL https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/bootstrap.sh | bash -s -- 2.4.9
  curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
  apt-get install -y nodejs
  npm install -g tape
  npm install -g @hyperledger/caliper-cli@0.5.0
  npx caliper bind --caliper-bind-sut fabric:2.4
  wget https://golang.org/dl/go1.18.10.linux-amd64.tar.gz
  tar -C /usr/local -xzf go1.18.10.linux-amd64.tar.gz
  export PATH=$PATH:/usr/local/go/bin
  ```

## دستورالعمل‌های راه‌اندازی
1. **آماده‌سازی محیط**:
   ```bash
   cd ~/6g-fabric-network
   docker compose down
   docker rm -f $(docker ps -a -q)
   docker network rm 6g-fabric-network_fabric
   rm -rf channel-artifacts crypto-config production
   mkdir -p channel-artifacts production chaincode caliper tape workload
   ```

2. **ذخیره فایل‌های تنظیمات**:
   - فایل‌ها را در `~/6g-fabric-network` ذخیره کنید:
     - `crypto-config.yaml`
     - `configtx.yaml`
     - `docker-compose.yaml`
     - `core-org1.yaml` تا `core-org10.yaml`
     - `setup_network.sh`
     - `generateCoreYamls.sh`
     - `generateConnectionProfiles.sh`
     - `generateChaincodes.sh`
     - `generateWorkloadFiles.sh`
     - `generateTapeConfigs.sh`
     - `create_zip.sh`
   - اسکریپت‌ها را اجرایی کنید:
     ```bash
     chmod +x *.sh
     dos2unix *.sh
     ```

3. **تولید فایل‌های تنظیمات**:
   ```bash
   ./generateCoreYamls.sh
   ./generateConnectionProfiles.sh
   ./generateChaincodes.sh
   ./generateWorkloadFiles.sh
   ./generateTapeConfigs.sh
   ```

4. **آماده‌سازی چین‌کد**:
   - اطمینان از وجود 70 دایرکتوری چین‌کد در `./chaincode`:
     ```bash
     ls -l ./chaincode
     mkdir -p ./chaincode/ResourceAllocate
     echo 'package main' > ./chaincode/ResourceAllocate/dummy.go
     ```

5. **اجرای شبکه**:
   ```bash
   ./setup_network.sh
   ```
   - تولید مواد رمزنگاری، آرتیفکت‌ها، راه‌اندازی شبکه، ایجاد/پیوستن 14 کانال، و نصب/نمونه‌سازی 70 چین‌کد.
   - 90 ثانیه صبر کنید.

6. **تأیید شبکه**:
   ```bash
   docker ps
   docker logs orderer.example.com > orderer.log
   docker logs peer0.org1.example.com > peer0.org1.log
   ```

## آزمایش شبکه
### استفاده از Tape
- **آزمایش تکی**:
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
- **آزمایش دسته‌ای**:
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

#### نمونه تنظیمات Tape
```yaml
channel: generalchannelapp
chaincode: ResourceAllocate
args: '{"Function":"init","Args":[]}'
```

### استفاده از Caliper
- **آماده‌سازی**:
  - اطمینان از وجود `caliper/benchmarkConfig.yaml`، `caliper/networkConfig.yaml`، و `workload/callback.js`.
- **اجرای آزمایش**:
  ```bash
  npx caliper launch manager \
    --caliper-workspace ./ \
    --caliper-networkconfig ./caliper/networkConfig.yaml \
    --caliper-benchconfig ./caliper/benchmarkConfig.yaml \
    --caliper-fabric-gateway-enabled
  ```

#### نمونه تنظیمات Caliper
- **benchmarkConfig.yaml**:
  ```yaml
  test:
    name: 6g-fabric-benchmark
    description: بنچمارک شبکه فابریک 6G
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
  module.exports.info = 'فراخوانی چین‌کد';
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

## توضیحات اسکریپت‌های شل
### setup_network.sh
- **هدف**: راه‌اندازی شبکه فابریک.
- **مراحل**:
  - بررسی پیش‌نیازها.
  - تولید مواد رمزنگاری با بررسی MSPها و گواهی TLS.
  - تولید بلاک جنسیس و 14 تراکنش کانال.
  - راه‌اندازی کانتینرهای داکر.
  - ایجاد/پیوستن 14 کانال.
  - نصب/نمونه‌سازی 70 چین‌کد.
  - ذخیره لاگ‌های دیباگ.
- **استفاده**:
  ```bash
  ./setup_network.sh
  ```

### generateCoreYamls.sh
- **هدف**: تولید `core-org1.yaml` تا `core-org10.yaml`.
- **مراحل**:
  - ایجاد فایل‌های YAML با تنظیمات Peer (لاگ، چین‌کد، دیتابیس لجر).
  - نمونه:
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
- **استفاده**:
  ```bash
  ./generateCoreYamls.sh
  ```

### generateConnectionProfiles.sh
- **هدف**: تولید پروفایل‌های اتصال (JSON).
- **مراحل**:
  - ایجاد پروفایل برای هر سازمان با نقاط انتهایی و MSP.
- **استفاده**:
  ```bash
  ./generateConnectionProfiles.sh
  ```

### generateChaincodes.sh
- **هدف**: تولید دایرکتوری‌های 70 چین‌کد.
- **مراحل**:
  - ایجاد دایرکتوری‌ها و فایل‌های `dummy.go`.
- **استفاده**:
  ```bash
  ./generateChaincodes.sh
  ```

### generateWorkloadFiles.sh
- **هدف**: تولید فایل‌های بار کاری Caliper.
- **مراحل**:
  - ایجاد `callback.js` برای فراخوانی توابع چین‌کد.
- **استفاده**:
  ```bash
  ./generateWorkloadFiles.sh
  ```

### generateTapeConfigs.sh
- **هدف**: تولید 980 فایل تنظیمات `tape`.
- **مراحل**:
  - ایجاد فایل‌های YAML برای هر ترکیب چین‌کد-کانال.
- **استفاده**:
  ```bash
  ./generateTapeConfigs.sh
  ```

### create_zip.sh
- **هدف**: بسته‌بندی پروژه به زیپ.
- **مراحل**:
  - ایجاد زیپ بدون `production/`.
- **استفاده**:
  ```bash
  ./create_zip.sh
  ```

## عیب‌یابی
### خطا: `policy for [Group] /Channel/Application not satisfied`
- **علت**: سیاست `Admins` برآورده نشده، احتمالاً به دلیل MSP نامعتبر.
- **راه‌حل**:
  - بررسی MSP مدیر برای Org1 تا Org10:
    ```bash
    for org in {1..10}; do ls -l crypto-config/peerOrganizations/org${org}.example.com/users/Admin@org${org}.example.com/msp; done
    ```
  - بررسی فایل‌های گواهی:
    ```bash
    ls -l crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts
    ls -l crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore
    ```
  - تولید مجدد مواد رمزنگاری:
    ```bash
    rm -rf crypto-config
    cryptogen generate --config=./crypto-config.yaml
    ```
  - بررسی گواهی TLS Orderer:
    ```bash
    ls -l crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
    ```
  - آزمایش دستی ایجاد کانال:
    ```bash
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org1MSP" \
               peer0.org1.example.com peer channel create \
               -o orderer.example.com:7050 \
               -c generalchannelapp \
               -f /etc/hyperledger/configtx/generalchannelapp.tx \
               --outputBlock /etc/hyperledger/configtx/generalchannelapp.block \
               --tls \
               --cafile /etc/hyperledger/fabric/tls/orderer-ca.crt
    ```
  - بررسی لاگ‌های Orderer و Peer:
    ```bash
    cat orderer.log
    cat peer0.org1.log
    ```

### خطا: `no Readers policy defined`
- **علت**: نبود سیاست `Readers` در کانال‌های سازمانی.
- **راه‌حل**:
  - بررسی `configtx.yaml` برای سیاست‌های `Readers` و `Writers`:
    ```yaml
    Policies:
      Readers:
        Type: ImplicitMeta
        Rule: "ANY Readers"
      Writers:
        Type: ImplicitMeta
        Rule: "ANY Writers"
      Admins:
        Type: ImplicitMeta
        Rule: "ANY Admins"
    ```
  - تولید مجدد آرتیفکت‌ها:
    ```bash
    export FABRIC_CFG_PATH=$PWD
    configtxgen -profile GeneralChannelApp -outputCreateChannelTx ./channel-artifacts/generalchannelapp.tx -channelID generalchannelapp
    ```

### خطا: `etcdraft configuration missing`
- **علت**: نبود تنظیمات `EtcdRaft`.
- **راه‌حل**:
  - بررسی `configtx.yaml`:
    ```yaml
    EtcdRaft:
      Consenters:
        - Host: orderer.example.com
          Port: 7050
          ClientTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
          ServerTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
    ```
  - تولید مجدد بلاک جنسیس:
    ```bash
    export FABRIC_CFG_PATH=$PWD
    configtxgen -profile OrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block
    ```

### خطای نصب چین‌کد
- **علت**: نبود دایرکتوری‌های چین‌کد.
- **راه‌حل**:
  - بررسی:
    ```bash
    ls -l ./chaincode
    ```
  - اجرای `generateChaincodes.sh`:
    ```bash
    ./generateChaincodes.sh
    ```

### خطای اتصال به Orderer
- **علت**: Orderer غیرقابل دسترسی یا TLS نادرست.
- **راه‌حل**:
  - بررسی لاگ‌ها:
    ```bash
    docker logs orderer.example.com | grep -i "error"
    ```
  - بررسی گواهی‌های TLS:
    ```bash
    ls -l crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls
    ```

## یادداشت‌ها
- **چین‌کدها**: 70 چین‌کد (مانند `ResourceAllocate`) باید با کد Go معتبر یا نگهدارنده پر شوند.
- **پاک‌سازی**:
  ```bash
  docker-compose -f docker-compose.yaml down
  docker rm -f $(docker ps -a -q)
  rm -rf channel-artifacts crypto-config production
  ```
- **لاگ‌ها**:
  ```bash
  docker logs orderer.example.com > orderer.log
  docker logs peer0.org1.example.com > peer0.org1.log
  ```
- **مقیاس آزمایش**: آزمایش 980 تست `tape` منابع زیادی نیاز دارد. ابتدا یک زیرمجموعه آزمایش کنید.

## پشتیبانی
لاگ‌ها را به اشتراک بگذارید:
```bash
docker logs orderer.example.com > orderer.log
docker logs peer0.org1.example.com > peer0.org1.log
```
