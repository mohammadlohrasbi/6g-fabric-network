# شبکه بلاکچین 6G با Hyperledger Fabric

این پروژه یک شبکه بلاکچین بهینه‌شده مبتنی بر Hyperledger Fabric را پیاده‌سازی می‌کند که برای برنامه‌های کاربردی 6G طراحی شده است. شبکه شامل 10 سازمان (Org1 تا Org10)، یک Orderer، و سرویس‌های CA برای تولید گواهی‌های MSP و TLS است. این پروژه از ابزارهای Caliper و Tape برای آزمایش عملکرد و استقرار 70 چین‌کد در 14 کانال استفاده می‌کند. تنظیمات برای کاهش فضای ذخیره‌سازی کانتینرها بهینه شده‌اند.

## ساختار پروژه

### دایرکتوری‌ها
- **`caliper/`**:
  - `benchmarkConfig.yaml`: تنظیمات بنچمارک Caliper (نرخ تراکنش، تعداد تراکنش).
  - `networkConfig.yaml`: جزئیات شبکه برای Caliper (نقاط انتهایی، MSPها، گواهی‌های TLS).
- **`tape/`**:
  - 980 فایل تنظیمات (مانند `tape-ResourceAllocate-generalchannelapp.yaml`) برای آزمایش چین‌کدها با ابزار Tape.
- **`workload/`**:
  - `callback.js`: ماژول بار کاری Caliper برای فراخوانی توابع چین‌کد.
- **`chaincode/`**:
  - 70 دایرکتوری چین‌کد (مانند `ResourceAllocate/`) حاوی کد Go یا فایل‌های نگهدارنده (`dummy.go`).
- **`channel-artifacts/`**:
  - 14 فایل تراکنش کانال (مانند `generalchannelapp.tx`) و بلاک جنسیس (`genesis.block`).
- **`crypto-config/`**:
  - `peerOrganizations/`: MSP و TLS برای Org1 تا Org10.
  - `ordererOrganizations/`: MSP و TLS برای Orderer.
- **`production/`**:
  - داده‌های پایدار برای Orderer و Peerها (فشرده‌شده).
- **`config/`**:
  - فایل‌های تنظیمات Peer (`core-org1.yaml` تا `core-org10.yaml`).

### فایل‌های تنظیمات
- **`crypto-config.yaml`**: تعریف ساختار سازمانی برای تولید گواهی‌ها با `cryptogen` (10 سازمان، 1 Orderer).
- **`configtx.yaml`**: پروفایل‌های کانال، سیاست‌ها (ANY Admins، ANY Readers، ANY Writers)، و تنظیمات اجماع `etcdraft`.
- **`docker-compose.yaml`**: تعریف سرویس‌های Docker برای Orderer، Peerها، و CAها (21 کانتینر بهینه‌شده).
- **`core-org1.yaml` تا `core-org10.yaml`**: تنظیمات Peerها (لاگ، چین‌کد، لجر فشرده).
- **`setup_network.sh`**: اسکریپت برای تولید آرتیفکت‌ها، راه‌اندازی شبکه، و استقرار چین‌کدها.
- **`generateCoreYamls.sh`**: تولید فایل‌های `core-org*.yaml` برای تنظیمات Peerها.
- **`generateConnectionProfiles.sh`**: تولید پروفایل‌های اتصال برای Caliper.
- **`generateChaincodes.sh`**: تولید دایرکتوری‌های چین‌کد.
- **`generateWorkloadFiles.sh`**: تولید فایل‌های بار کاری Caliper.
- **`generateTapeConfigs.sh`**: تولید 980 فایل تنظیمات Tape (بهینه‌شده).
- **`create_zip.sh`**: بسته‌بندی پروژه به فایل زیپ.

## پیش‌نیازها

- **Docker**: نسخه 20.10 یا بالاتر
- **Docker Compose**: نسخه 1.29.2
- **Hyperledger Fabric ابزارها**: نسخه 2.4.9 (شامل `cryptogen`, `configtxgen`)
- **Go**: نسخه 1.18 یا بالاتر (برای چین‌کدها)
- **Node.js**: نسخه 16 یا بالاتر (برای Caliper)
- **Tape**: ابزار تست عملکرد Hyperledger
- **سیستم**: حداقل 8GB RAM آزاد، 4 CPU، و 10GB فضای دیسک

دستورات نصب (برای Ubuntu/Debian):
```bash
# نصب Docker
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# نصب Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# نصب Hyperledger Fabric ابزارها
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.4.9 1.5.7
export PATH=$PWD/bin:$PATH

# نصب Node.js
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# نصب Caliper CLI
npm install -g @hyperledger/caliper-cli@0.5.0
npx caliper bind --caliper-bind-sut fabric:2.4

# نصب Tape
npm install -g @hyperledger/tape
```

## راه‌اندازی شبکه

1. **کلون کردن مخزن**:
   ```bash
   git clone <repository-url>
   cd 6g-fabric-network
   ```

2. **ایجاد دایرکتوری‌های مورد نیاز**:
   ```bash
   mkdir -p channel-artifacts production chaincode caliper tape workload config
   ```

3. **پاک‌سازی محیط و کش Docker**:
   ```bash
   docker-compose -f docker-compose.yaml down
   docker rm -f $(docker ps -a -q)
   docker network rm 6g-fabric-network_fabric
   docker image prune -f
   docker volume prune -f
   rm -rf channel-artifacts crypto-config production tape
   mkdir -p channel-artifacts production chaincode caliper tape workload config
   ```

4. **بررسی فضای دیسک**:
   ```bash
   df -h
   free -m
   nproc
   ```
   اطمینان حاصل کنید که حداقل 10GB فضای دیسک و 8GB RAM آزاد دارید.

5. **تأیید پیش‌نیازها**:
   ```bash
   docker version
   docker-compose version
   cryptogen version
   configtxgen version
   go version
   node --version
   npx caliper --version
   tape --version
   ```

6. **تولید مواد رمزنگاری**:
   ```bash
   cryptogen generate --config=./crypto-config.yaml 2> cryptogen.log
   cat cryptogen.log
   ls -l crypto-config/peerOrganizations/org1.example.com/ca
   ls -l crypto-config/ordererOrganizations/example.com/ca
   ls -l crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
   cat crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml
   ```

7. **فشرده‌سازی دایرکتوری crypto-config**:
   ```bash
   find crypto-config -type f -name "*.pem" -exec gzip {} \;
   find crypto-config -type f -name "*.crt" -exec gzip {} \;
   ```

8. **باز کردن فایل‌های فشرده قبل از اجرای شبکه**:
   ```bash
   find crypto-config -type f -name "*.gz" -exec gunzip {} \;
   ```

9. **تولید فایل‌های تنظیمات**:
   ```bash
   chmod +x generateCoreYamls.sh generateConnectionProfiles.sh generateChaincodes.sh generateWorkloadFiles.sh generateTapeConfigs.sh
   dos2unix *.sh
   ./generateCoreYamls.sh
   ./generateConnectionProfiles.sh
   ./generateChaincodes.sh
   ./generateWorkloadFiles.sh
   ./generateTapeConfigs.sh
   ```

10. **اجرای اسکریپت راه‌اندازی**:
    ```bash
    chmod +x setup_network.sh
    dos2unix setup_network.sh
    ./setup_network.sh
    ```

11. **بررسی وضعیت شبکه**:
    ```bash
    docker ps -a
    cat container_status.log
    cat orderer.log
    cat peer0.org1.log
    cat ca.org1.log
    cat ca.orderer.log
    ```

12. **اجرای بنچمارک Caliper**:
    ```bash
    npx caliper launch manager --caliper-workspace ./caliper \
        --caliper-benchconfig ./caliper/benchmarkConfig.yaml \
        --caliper-networkconfig ./caliper/networkConfig.yaml
    ```

13. **اجرای تست Tape**:
    ```bash
    tape -c ./tape/tape-ResourceAllocate-generalchannelapp.yaml
    ```

14. **بسته‌بندی پروژه**:
    ```bash
    chmod +x create_zip.sh
    dos2unix create_zip.sh
    ./create_zip.sh
    ```

## کانال‌ها و چین‌کدها

### کانال‌ها
شبکه شامل 14 کانال است:
- `generalchannelapp`
- `iotchannelapp`
- `securitychannelapp`
- `monitoringchannelapp`
- `org1channelapp` تا `org10channelapp`

### چین‌کدها
شبکه شامل 70 چین‌کد است:
- `ResourceAllocate`
- `BandwidthShare`
- `DynamicRouting`
- `LoadBalance`
- `LatencyOptimize`
- `EnergyOptimize`
- `NetworkOptimize`
- `SpectrumManage`
- `ResourceScale`
- `ResourcePrioritize`
- `UserAuth`
- `DeviceAuth`
- `AccessControl`
- `TokenAuth`
- `RoleBasedAuth`
- `IdentityVerify`
- `SessionAuth`
- `MultiFactorAuth`
- `AuthPolicy`
- `AuthAudit`
- `NetworkMonitor`
- `PerformanceMonitor`
- `TrafficMonitor`
- `ResourceMonitor`
- `HealthMonitor`
- `AlertMonitor`
- `LogMonitor`
- `EventMonitor`
- `MetricsCollector`
- `StatusMonitor`
- `Encryption`
- `IntrusionDetect`
- `FirewallRules`
- `SecureChannel`
- `ThreatMonitor`
- `AccessLog`
- `SecurityPolicy`
- `VulnerabilityScan`
- `DataIntegrity`
- `SecureBackup`
- `TransactionAudit`
- `ComplianceAudit`
- `AccessAudit`
- `EventAudit`
- `PolicyAudit`
- `DataAudit`
- `UserAudit`
- `SystemAudit`
- `PerformanceAudit`
- `SecurityAudit`
- `ConfigManage`
- `PolicyManage`
- `ResourceManage`
- `NetworkManage`
- `DeviceManage`
- `UserManage`
- `ServiceManage`
- `EventManage`
- `AlertManage`
- `LogManage`
- `DataAnalytics`
- `FaultDetect`
- `AnomalyDetect`
- `PredictiveMaintenance`
- `PerformanceAnalytics`
- `TrafficAnalytics`
- `SecurityAnalytics`
- `ResourceAnalytics`
- `EventAnalytics`
- `LogAnalytics`

هر چین‌کد در تمام کانال‌ها نصب و نمونه‌سازی می‌شود.

## عیب‌یابی

اگر با خطاهایی مانند "container is not running" یا "no space left on device" مواجه شدید:
1. **بررسی وضعیت کانتینرها**:
   ```bash
   docker ps -a
   cat container_status.log
   ```

2. **بررسی لاگ‌های کانتینرها**:
   ```bash
   docker logs ca.orderer.example.com
   docker logs ca.org1.example.com
   docker logs orderer.example.com
   docker logs peer0.org1.example.com
   cat orderer.log
   cat peer0.org1.log
   cat ca.org1.log
   cat ca.orderer.log
   ```

3. **بررسی منابع سیستم**:
   ```bash
   df -h
   free -m
   nproc
   docker stats
   ```
   اگر فضای دیسک محدود است، تصاویر و حجم‌های بلااستفاده را پاک کنید:
   ```bash
   docker image prune -f
   docker volume prune -f
   ```

4. **بررسی گواهی‌ها**:
   ```bash
   ls -l crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
   ls -l crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
   ls -l crypto-config/peerOrganizations/org1.example.com/ca
   cat crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml
   ```

5. **باز کردن فایل‌های فشرده**:
   ```bash
   find crypto-config -type f -name "*.gz" -exec gunzip {} \;
   ```

6. **راه‌اندازی دستی کانتینرها**:
   ```bash
   docker-compose -f docker-compose.yaml up -d ca.orderer.example.com ca.org1.example.com ca.org2.example.com ca.org3.example.com ca.org4.example.com ca.org5.example.com ca.org6.example.com ca.org7.example.com ca.org8.example.com ca.org9.example.com ca.org10.example.com
   sleep 60
   docker-compose -f docker-compose.yaml up -d orderer.example.com peer0.org1.example.com peer0.org2.example.com peer0.org3.example.com peer0.org4.example.com peer0.org5.example.com peer0.org6.example.com peer0.org7.example.com peer0.org8.example.com peer0.org9.example.com peer0.org10.example.com
   sleep 60
   docker ps -a
   ```

7. **تست دستی ایجاد کانال**:
   ```bash
   docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org1MSP" \
               peer0.org1.example.com peer channel create \
               -o orderer.example.com:7050 \
               -c generalchannelapp \
               -f /etc/hyperledger/configtx/generalchannelapp.tx \
               --outputBlock /etc/hyperledger/configtx/generalchannelapp.block \
               --tls \
               --cafile /etc/hyperledger/fabric/tls/ca.crt
   ```

## لاگ‌های مهم
- `container_status.log`: وضعیت کانتینرها
- `orderer.log`: لاگ‌های Orderer
- `peer0.org1.log`: لاگ‌های Peer سازمان 1
- `ca.org1.log`: لاگ‌های CA سازمان 1
- `ca.orderer.log`: لاگ‌های CA Orderer
- `msp_config.log`: محتوای فایل `config.yaml` برای MSP
- `msp_dir.log`: ساختار دایرکتوری MSP
- `tls_ca.log`: وضعیت گواهی‌های TLS
- `cryptogen.log`: لاگ‌های تولید مواد رمزنگاری
- `configtx_admins.log`: سیاست‌های Admins در `configtx.yaml`
- `ca_org1_dir.log`: محتوای دایرکتوری CA سازمان 1
- `ca_orderer_dir.log`: محتوای دایرکتوری CA Orderer

## یادداشت‌ها
- **نسخه‌ها**: از Hyperledger Fabric 2.4.9، Fabric CA 1.5.7، Caliper 0.5.0، و Tape استفاده کنید.
- **منابع**: شبکه با 21 کانتینر بهینه‌سازی شده و حداقل 8GB RAM و 10GB فضای دیسک طراحی شده است.
- **فشرده‌سازی**: فایل‌های `.pem` و `.crt` در `crypto-config/` فشرده شده‌اند (با `gzip`). قبل از اجرای `setup_network.sh`، آن‌ها را با `gunzip` باز کنید.
- **زمان**: این فایل در تاریخ 2025-06-29 06:45 CEST به‌روزرسانی شده است.
- **خطاها**: اگر با خطای "no space left on device" مواجه شدید، فضای دیسک را بررسی و کش Docker را پاک کنید.

برای گزارش مشکلات یا سؤالات، لاگ‌های بالا را بررسی و با تیم توسعه به اشتراک بگذارید.
