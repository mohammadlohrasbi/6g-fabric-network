برای ارائه فایل `README.md` به‌صورت جداگانه جهت دانلود، محتوای آن را در قالب یک فایل متنی ارائه می‌دهم که می‌توانید آن را مستقیماً ذخیره کنید. این فایل همان نسخه جامع و به‌روزرسانی‌شده‌ای است که در پاسخ قبلی ارائه شد و شامل توضیحات دقیق درباره قراردادهای هوشمند، کانال‌ها، و دستورالعمل‌های اجرای پروژه 6G Fabric است. برای دانلود، می‌توانید محتوای زیر را در یک فایل متنی ذخیره کرده و یا از دستورات ارائه‌شده برای ذخیره مستقیم استفاده کنید.

---

### ذخیره فایل `README.md`
محتوای زیر را کپی کرده و در فایلی به نام `README.md` ذخیره کنید:


# پروژه 6G Fabric

این پروژه یک شبکه بلاکچین مبتنی بر **Hyperledger Fabric 2.5** را پیاده‌سازی می‌کند که برای شبیه‌سازی تخصیص کاربران و دستگاه‌های IoT به آنتن‌ها در یک شبکه 6G طراحی شده است. این شبکه شامل **۱۰ سازمان**، **۱ ترتیب‌دهنده**، **۱۴ کانال**، و **۷۰ قرارداد هوشمند** است که عملیات مختلفی مانند تخصیص جغرافیایی، احراز هویت، مدیریت پهنای باند، و نظارت بر عملکرد را انجام می‌دهند. قراردادهای هوشمند از منطق تخصیص مبتنی بر **فاصله اقلیدسی** برای اتصال کاربران یا دستگاه‌های IoT به نزدیک‌ترین آنتن استفاده می‌کنند.

## نمای کلی پروژه
شبکه 6G Fabric برای شبیه‌سازی یک محیط 6G طراحی شده است که در آن کاربران و دستگاه‌های IoT به آنتن‌های متعلق به سازمان‌های مختلف (مانند اپراتورهای مخابراتی) متصل می‌شوند. هر سازمان یک همتا (peer) و یک کانتینر CLI دارد. قراردادهای هوشمند عملیات مختلفی از جمله تخصیص منابع، احراز هویت، و نظارت بر شبکه را مدیریت می‌کنند. شبکه از ۱۴ کانال برای جداسازی عملیات استفاده می‌کند: ۴ کانال مشترک (برای برنامه‌های عمومی، IoT، امنیت، و نظارت) و ۱۰ کانال سازمانی (یکی برای هر سازمان).

### مختصات آنتن‌ها
هر سازمان یک آنتن با مختصات ثابت دارد که برای محاسبه فاصله اقلیدسی در قراردادهای هوشمند (مانند `GeoAssign`) استفاده می‌شود:
- **Org1**: (100, 100)
- **Org2**: (200, 100)
- **Org3**: (300, 100)
- **Org4**: (100, 200)
- **Org5**: (200, 200)
- **Org6**: (300, 200)
- **Org7**: (100, 300)
- **Org8**: (200, 300)
- **Org9**: (300, 300)
- **Org10**: (400, 300)

این مختصات برای تخصیص کاربران/IoT‌ها به نزدیک‌ترین آنتن استفاده می‌شوند. مختصات کاربران/IoT‌ها به‌صورت تصادفی در محدوده (0 تا 500) تولید می‌شوند.

## ساختار پروژه
پروژه شامل فایل‌ها و دایرکتوری‌های زیر است:
- **`crypto-config.yaml`**: تعریف سازمان‌ها، همتاها، و گواهی‌ها با استفاده از ابزار `cryptogen`.
- **`configtx.yaml`**: پیکربندی کانال‌ها، پروفایل‌ها، و ترتیب‌دهنده برای تولید آرتیفکت‌های کانال و بلاک جنسیس.
- **`docker-compose.yaml`**: تعریف سرویس‌های شبکه شامل ۱ ترتیب‌دهنده، ۱۰ همتا، و ۱۰ کانتینر CLI (یکی برای هر سازمان).
- **`core-org1.yaml` تا `core-org10.yaml`**: فایل‌های پیکربندی برای CLI هر سازمان.
- **`setup_network.sh`**: اسکریپت راه‌اندازی شبکه و تولید آرتیفکت‌ها.
- **`generateCoreYamls.sh`**: تولید فایل‌های `core.yaml` برای هر سازمان.
- **`generateConnectionProfiles.sh`**: تولید پروفایل‌های اتصال JSON برای Caliper و Tape.
- **`generateChaincodes.sh`**: تولید ۷۰ قرارداد هوشمند Go.
- **`generateWorkloadFiles.sh`**: تولید فایل‌های workload برای تست‌های Caliper.
- **`generateTapeConfigs.sh`**: تولید فایل‌های پیکربندی Tape برای تست قراردادها.
- **`caliper/`**: شامل `benchmarkConfig.yaml` و `networkConfig.yaml` برای تست عملکرد با Caliper.
- **`tape/`**: شامل فایل‌های `tape-*.yaml` برای تست قراردادها با Tape.
- **`create_zip.sh`**: اسکریپت برای فشرده‌سازی پروژه.
- **`chaincode/`**: دایرکتوری قراردادهای هوشمند (مانند `GeoAssign`, `GeoUpdate`, و غیره).
- **`channel-artifacts/`**: آرتیفکت‌های کانال (مانند `genesis.block`, `generalchannel.tx`).
- **`crypto-config/`**: گواهی‌ها و کلیدهای تولیدشده توسط `cryptogen`.

## کانال‌ها
شبکه شامل **۱۴ کانال** است که به شرح زیر سازمان‌دهی شده‌اند:
1. **کانال‌های مشترک**:
   - **`generalchannelapp`**: برای عملیات عمومی مانند تخصیص جغرافیایی، احراز هویت کاربران، و مدیریت پهنای باند (شامل قراردادهایی مانند `GeoAssign`, `GeoUpdate`, `AuthUser`).
   - **`iotchannelapp`**: برای عملیات مربوط به دستگاه‌های IoT (مانند `AuthIoT`, `ConnectIoT`, `IoTBandwidth`).
   - **`securitychannelapp`**: برای عملیات امنیتی (مانند `IntrusionDetect`, `KeyManage`, `QuantumEncrypt`).
   - **`monitoringchannelapp`**: برای نظارت بر عملکرد شبکه (مانند `TrafficMonitor`, `NetworkPerf`, `RealTimeMonitor`).
2. **کانال‌های سازمانی**:
   - **`org1channelapp` تا `org10channelapp`**: هر سازمان یک کانال اختصاصی برای عملیات داخلی خود دارد (مانند مدیریت کاربران و دستگاه‌های خاص سازمان).

هر کانال از زیرمجموعه‌ای از ۷۰ قرارداد هوشمند پشتیبانی می‌کند که در فایل `generateTapeConfigs.sh` مشخص شده‌اند.

## قراردادهای هوشمند
پروژه شامل **۷۰ قرارداد هوشمند** است که در دایرکتوری `chaincode/` ذخیره شده‌اند. هر قرارداد شامل دو تابع اصلی است:
- **`AssignEntity`**: تخصیص یک کاربر یا دستگاه IoT به نزدیک‌ترین آنتن بر اساس فاصله اقلیدسی.
- **`QueryAssignment`**: بازیابی اطلاعات تخصیص برای یک موجودیت خاص.

لیست قراردادها به شرح زیر است (دسته‌بندی‌شده بر اساس نوع عملیات):
1. **تخصیص جغرافیایی**:
   - `GeoAssign`: تخصیص اولیه کاربران/IoT‌ها به آنتن‌ها.
   - `GeoUpdate`: به‌روزرسانی مختصات موجودیت‌ها.
   - `GeoHandover`: انتقال کاربران/IoT‌ها بین آنتن‌ها.
2. **احراز هویت و ثبت‌نام**:
   - `AuthUser`, `AuthIoT`, `AuthAntenna`: احراز هویت کاربران، دستگاه‌های IoT، و آنتن‌ها.
   - `RegisterUser`, `RegisterIoT`: ثبت‌نام کاربران و دستگاه‌های IoT.
   - `RevokeUser`, `RevokeIoT`: ابطال دسترسی کاربران و دستگاه‌های IoT.
3. **مدیریت منابع و پهنای باند**:
   - `BandwidthAlloc`, `IoTBandwidth`, `SpectrumShare`: تخصیص و اشتراک پهنای باند.
   - `ResourceRequest`, `ResourceAudit`: درخواست و ممیزی منابع.
4. **نظارت و تحلیل**:
   - `NetworkPerf`, `TrafficMonitor`, `LatencyTrack`, `EnergyMonitor`, `RealTimeMonitor`: نظارت بر عملکرد شبکه.
   - `IoTAnalytics`, `UserAnalytics`, `DataAnalytics`: تحلیل داده‌های کاربران و IoT.
5. **امنیت و حریم خصوصی**:
   - `DataEncrypt`, `IoTEncrypt`, `QuantumEncrypt`: رمزنگاری داده‌ها.
   - `IntrusionDetect`, `KeyManage`, `PrivacyPolicy`, `SecureChannel`: مدیریت امنیت و حریم خصوصی.
6. **مدیریت شبکه و بهینه‌سازی**:
   - `LoadBalance`, `DynamicAlloc`, `DynamicRouting`, `BandwidthShare`, `LatencyOptimize`: بهینه‌سازی منابع و مسیریابی.
   - `EnergyOptimize`, `NetworkOptimize`: بهینه‌سازی مصرف انرژی و عملکرد شبکه.
7. **تشخیص و مدیریت خطا**:
   - `FaultDetect`, `IoTFault`, `FaultPredict`: تشخیص و پیش‌بینی خطاها.
   - `NetworkHealth`, `IoTHealth`: نظارت بر سلامت شبکه و دستگاه‌ها.
8. **پیکربندی و ممیزی**:
   - `IoTConfig`, `UserConfig`, `AntennaConfig`: پیکربندی دستگاه‌ها و آنتن‌ها.
   - `PerformanceAudit`, `SecurityAudit`, `ConnectionAudit`: ممیزی عملکرد و امنیت.
9. **سایر عملیات**:
   - `Roaming`, `SessionTrack`, `IoTSession`, `Disconnect`: مدیریت جابجایی و جلسات.
   - `Billing`, `TransactionLog`, `AccessLog`: صورت‌حساب و ثبت تراکنش‌ها.

هر قرارداد در یکی از کانال‌های مشترک یا سازمانی مستقر می‌شود. برای جزئیات، به فایل‌های `caliper/benchmarkConfig.yaml` و `tape/tape-*.yaml` مراجعه کنید.

## پیش‌نیازها
برای اجرای پروژه، ابزارهای زیر مورد نیاز است:
- **Docker و Docker Compose** (نسخه 1.29 یا بالاتر)
- **Hyperledger Fabric 2.5** (شامل ابزارهای `cryptogen` و `configtxgen`)
- **Node.js و npm** (برای Caliper و Tape)
- **Go** (برای قراردادهای هوشمند)
- **Bash** (برای اجرای اسکریپت‌ها)

## نصب پیش‌نیازها
1. نصب Docker و Docker Compose:
   ```bash
   sudo apt-get update
   sudo apt-get install -y docker.io docker-compose
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

2. نصب ابزارهای Hyperledger Fabric:
   ```bash
   curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.5.0 1.5.2
   export PATH=$HOME/fabric-samples/bin:$PATH
   ```

3. نصب Node.js و npm:
   ```bash
   sudo apt-get install -y nodejs npm
   ```

4. نصب Caliper و Tape:
   ```bash
   npm install -g @hyperledger/caliper-cli
   npm install -g tape
   ```

5. نصب Go:
   ```bash
   sudo apt-get install -y golang-go
   export PATH=$PATH:/usr/lib/go/bin
   ```

## راه‌اندازی پروژه
### ۱. ایجاد ساختار دایرکتوری
```bash
mkdir -p 6g-fabric-project/{channel-artifacts,crypto-config,chaincode,workload,caliper,tape}
cd 6g-fabric-project
```

### ۲. ذخیره فایل‌های پروژه
فایل‌های زیر را در دایرکتوری پروژه ذخیره کنید:
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
- `caliper/benchmarkConfig.yaml`
- `caliper/networkConfig.yaml`
- `tape/tape-*.yaml`
- `create_zip.sh`
- `README.md`

### ۳. تنظیم مجوزهای اسکریپت‌ها
```bash
chmod +x setup_network.sh generateCoreYamls.sh generateConnectionProfiles.sh generateChaincodes.sh generateWorkloadFiles.sh generateTapeConfigs.sh create_zip.sh
```

### ۴. اجرای اسکریپت راه‌اندازی
```bash
./setup_network.sh
```
این اسکریپت:
- دایرکتوری‌های مورد نیاز را ایجاد می‌کند.
- گواهی‌ها را با `cryptogen` تولید می‌کند.
- فایل‌های `core.yaml` را برای هر سازمان تولید می‌کند.
- پروفایل‌های اتصال، قراردادهای هوشمند، و فایل‌های workload و Tape را تولید می‌کند.
- بلاک جنسیس و آرتیفکت‌های کانال را با `configtxgen` تولید می‌کند.

### ۵. راه‌اندازی شبکه
```bash
docker-compose -f docker-compose.yaml up -d
```
این دستور ۲۱ کانتینر را راه‌اندازی می‌کند:
- ۱ ترتیب‌دهنده: `orderer1.example.com`
- ۱۰ همتا: `peer0.org1.example.com` تا `peer0.org10.example.com`
- ۱۰ CLI: `cli-org1` تا `cli-org10`

بررسی کنید که تمام کانتینرها فعال هستند:
```bash
docker ps -a
```

### ۶. ایجاد کانال‌ها
برای هر سازمان، به کانتینر CLI مربوطه وارد شوید و کانال‌ها را ایجاد کنید. به‌عنوان مثال، برای `Org1`:
```bash
docker exec -it cli-org1 bash
```
سپس کانال‌های مشترک را ایجاد کنید:
```bash
export CHANNEL_NAME=generalchannelapp
peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/generalchannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel join -b ./channel-artifacts/generalchannel.block
```
این کار را برای `iotchannelapp`, `securitychannelapp`, و `monitoringchannelapp` تکرار کنید:
```bash
export CHANNEL_NAME=iotchannelapp
peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/iotchannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel join -b ./channel-artifacts/iotchannel.block

export CHANNEL_NAME=securitychannelapp
peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/securitychannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel join -b ./channel-artifacts/securitychannel.block

export CHANNEL_NAME=monitoringchannelapp
peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/monitoringchannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel join -b ./channel-artifacts/monitoringchannel.block
```
برای کانال سازمانی `org1channelapp`:
```bash
export CHANNEL_NAME=org1channelapp
peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/org1channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel join -b ./channel-artifacts/org1channel.block
```
برای سازمان‌های دیگر (`Org2` تا `Org10`)، به کانتینرهای `cli-org2` تا `cli-org10` وارد شوید و دستورات بالا را با نام کانال مربوطه (`org2channelapp` تا `org10channelapp`) تکرار کنید.

### ۷. نصب و فعال‌سازی قراردادهای هوشمند
برای هر قرارداد و کانال، قرارداد را نصب و فعال کنید. به‌عنوان مثال، برای `GeoAssign` در `generalchannelapp`:
```bash
peer lifecycle chaincode package geoassign.tar.gz --path /opt/gopath/src/github.com/chaincode/GeoAssign --lang golang --label geoassign_1
peer lifecycle chaincode install geoassign.tar.gz
peer lifecycle chaincode approveformyorg -o orderer1.example.com:7050 --channelID generalchannelapp --name GeoAssign --version 1.0 --package-id geoassign_1 --sequence 1 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer lifecycle chaincode commit -o orderer1.example.com:7050 --channelID generalchannelapp --name GeoAssign --version 1.0 --sequence 1 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
```
این مراحل را برای سایر قراردادها و کانال‌ها تکرار کنید. برای کانال‌های سازمانی، فقط سازمان مربوطه قرارداد را نصب و تأیید می‌کند.

### ۸. تست عملکرد
پروژه از دو ابزار برای تست عملکرد استفاده می‌کند: **Caliper** و **Tape**.

#### تست با Caliper
Caliper برای تست تمام ۷۰ قرارداد در کانال‌های مربوطه استفاده می‌شود. فایل `caliper/benchmarkConfig.yaml` شامل تنظیمات برای هر قرارداد است.
```bash
ENTITY_COUNT=1000 npx caliper launch manager --caliper-benchconfig caliper/benchmarkConfig.yaml --caliper-networkconfig caliper/networkConfig.yaml
```
- `ENTITY_COUNT=1000`: تعداد موجودیت‌ها (کاربران/IoT) برای تست.
- هر قرارداد ۱۰۰۰ تراکنش با نرخ ۱۰۰ TPS اجرا می‌کند.
- نتایج در دایرکتوری `caliper/` ذخیره می‌شوند.

#### تست با Tape
Tape برای تست فردی قراردادها در کانال‌های خاص استفاده می‌شود. فایل‌های `tape/tape-*.yaml` برای هر قرارداد و کانال تولید شده‌اند.
به‌عنوان مثال، برای تست `GeoAssign` در `generalchannelapp`:
```bash
ENTITY_COUNT=1000 tape --config tape/tape-geoassign-generalchannelapp.yaml
```
برای تست سایر قراردادها، فایل `tapeConfig.yaml` مربوطه را مشخص کنید (مانند `tape/tape-authiot-iotchannelapp.yaml`).

#### سناریوهای تست
1. **تست کامل شبکه**:
   - تمام قراردادها را در تمام کانال‌ها با Caliper تست کنید.
   - از `benchmarkConfig.yaml` استفاده کنید که شامل تمام ۷۰ قرارداد است.
2. **تست قراردادهای خاص**:
   - برای تست یک قرارداد خاص (مانند `GeoAssign`)، فایل `tape/tape-geoassign-generalchannelapp.yaml` را با Tape اجرا کنید.
3. **تست کانال‌های سازمانی**:
   - برای تست قراردادها در کانال‌های سازمانی (مانند `org1channelapp`)، از `cli-org1` و فایل `tape/tape-geoassign-org1channelapp.yaml` استفاده کنید.
4. **تست مقیاس‌پذیری**:
   - تعداد موجودیت‌ها (`ENTITY_COUNT`) را به ۵۰۰۰ یا ۱۰۰۰۰ افزایش دهید و عملکرد را با Caliper بررسی کنید:
     ```bash
     ENTITY_COUNT=5000 npx caliper launch manager --caliper-benchconfig caliper/benchmarkConfig.yaml --caliper-networkconfig caliper/networkConfig.yaml
     ```

### ۹. فشرده‌سازی پروژه
برای ایجاد فایل زیپ پروژه:
```bash
./create_zip.sh
```
این اسکریپت فایل‌های غیرضروری (مانند `.git`, `node_modules`, `channel-artifacts`, `crypto-config`) را حذف کرده و فایل `6g-fabric-project.zip` را تولید می‌کند.

## رفع اشکال
### خطای `No such container: cli`
- **علت**: کانتینرهای CLI در `docker-compose.yaml` تعریف نشده‌اند یا اجرا نشده‌اند.
- **راه‌حل**:
  - اطمینان حاصل کنید که `docker-compose.yaml` شامل سرویس‌های `cli-org1` تا `cli-org10` است.
  - بررسی کنید که دستور `docker-compose -f docker-compose.yaml up -d` اجرا شده است.
  - خروجی `docker ps -a` را بررسی کنید تا مطمئن شوید تمام کانتینرها فعال هستند.

### خطای `Config File "core" Not Found`
- **علت**: فایل‌های `core-org1.yaml` تا `core-org10.yaml` در دایرکتوری پروژه وجود ندارند یا به درستی مپ نشده‌اند.
- **راه‌حل**:
  - اسکریپت `generateCoreYamls.sh` را اجرا کنید:
    ```bash
    ./generateCoreYamls.sh
    ```
  - اطمینان حاصل کنید که فایل‌های `core-orgX.yaml` به مسیر `/opt/gopath/src/github.com/hyperledger/fabric/peer/config/core.yaml` در کانتینرهای CLI مپ شده‌اند.

### خطای `etcdraft configuration missing`
- **علت**: بخش `EtcdRaft` در `configtx.yaml` ناقص است.
- **راه‌حل**:
  - بررسی کنید که بخش `EtcdRaft` در `configtx.yaml` شامل تعریف `Consenters` و مسیرهای TLS باشد:
    ```yaml
    EtcdRaft:
      Consenters:
        - Host: orderer1.example.com
          Port: 7050
          ClientTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.crt
          ServerTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.crt
    ```

### خطاهای عمومی
- **کانتینرها اجرا نمی‌شوند**:
  - لاگ‌ها را بررسی کنید:
    ```bash
    docker logs cli-org1
    docker logs orderer1.example.com
    docker logs peer0.org1.example.com
    ```
  - اطمینان حاصل کنید که پورت‌ها (7050, 7051, 8051, ..., 16051) آزاد هستند:
    ```bash
    netstat -tuln | grep 7050
    ```
- **خطای نصب قرارداد**:
  - بررسی کنید که دایرکتوری `chaincode/` شامل فایل‌های Go قراردادها باشد.
  - اسکریپت `generateChaincodes.sh` را دوباره اجرا کنید:
    ```bash
    ./generateChaincodes.sh
    ```

## پاکسازی محیط
برای توقف و حذف شبکه:
```bash
docker-compose -f docker-compose.yaml down
docker volume prune -f
rm -rf channel-artifacts crypto-config
```

## بررسی نسخه‌ها
اطمینان حاصل کنید که نسخه‌های درست نصب شده‌اند:
```bash
peer version
configtxgen --version
docker --version
docker-compose --version
node --version
npm --version
go version
```

## پشتیبانی
برای مشکلات، اطلاعات زیر را بررسی یا ارائه دهید:
1. خروجی `docker ps -a`.
2. لاگ‌های کانتینرها (`docker logs cli-org1`, `docker logs orderer1.example.com`).
3. خروجی دستورات `peer version` و `configtxgen --version`.
4. هرگونه تغییر دستی در فایل‌ها یا اسکریپت‌ها.

## نکات اضافی
- **مقیاس‌پذیری**: برای تست مقیاس‌پذیری، تعداد همتاها یا سازمان‌ها را می‌توانید با ویرایش `crypto-config.yaml` و `docker-compose.yaml` افزایش دهید.
- **شبیه‌سازی مختصات**: برای شبیه‌سازی واقعی‌تر، می‌توانید مختصات آنتن‌ها را در قراردادهای هوشمند تغییر دهید.
- **اتوماسیون**: برای خودکارسازی نصب قراردادها در تمام سازمان‌ها و کانال‌ها، می‌توانید اسکریپت‌های اضافی بنویسید. در صورت نیاز، درخواست کنید.

این پروژه یک زیرساخت قوی برای شبیه‌سازی شبکه 6G با استفاده از Hyperledger Fabric فراهم می‌کند و برای تست‌های عملکرد و توسعه بیشتر مناسب است.


---

### نحوه ذخیره و دانلود فایل `README.md`
برای ذخیره فایل به‌صورت جداگانه، یکی از روش‌های زیر را دنبال کنید:

1. **ذخیره دستی**:
   - محتوای بالا را کپی کنید.
   - در سیستم خود یک فایل جدید ایجاد کنید:
     ```bash
     nano README.md
     ```
   - محتوای کپی‌شده را جای‌گذاری کنید، سپس ذخیره کنید (Ctrl+O، Enter، Ctrl+X).
   - فایل `README.md` را می‌توانید به سیستم دیگر منتقل کنید (مثلاً با `scp`):
     ```bash
     scp README.md user@your-local-machine:/path/to/destination
     ```

2. **ذخیره با استفاده از دستورات لینوکس**:
   اگر در محیط لینوکس یا مک هستید، می‌توانید محتوای فایل را مستقیماً ذخیره کنید:
   ```bash
   cat << 'EOF' > README.md
   # پروژه 6G Fabric
   این پروژه یک شبکه بلاکچین مبتنی بر **Hyperledger Fabric 2.5** را پیاده‌سازی می‌کند که برای شبیه‌سازی تخصیص کاربران و دستگاه‌های IoT به آنتن‌ها در یک شبکه 6G طراحی شده است. این شبکه شامل **۱۰ سازمان**، **۱ ترتیب‌دهنده**، **۱۴ کانال**، و **۷۰ قرارداد هوشمند** است که عملیات مختلفی مانند تخصیص جغرافیایی، احراز هویت، مدیریت پهنای باند، و نظارت بر عملکرد را انجام می‌دهند. قراردادهای هوشمند از منطق تخصیص مبتنی بر **فاصله اقلیدسی** برای اتصال کاربران یا دستگاه‌های IoT به نزدیک‌ترین آنتن استفاده می‌کنند.

   ## نمای کلی پروژه
   شبکه 6G Fabric برای شبیه‌سازی یک محیط 6G طراحی شده است که در آن کاربران و دستگاه‌های IoT به آنتن‌های متعلق به سازمان‌های مختلف (مانند اپراتورهای مخابراتی) متصل می‌شوند. هر سازمان یک همتا (peer) و یک کانتینر CLI دارد. قراردادهای هوشمند عملیات مختلفی از جمله تخصیص منابع، احراز هویت، و نظارت بر شبکه را مدیریت می‌کنند. شبکه از ۱۴ کانال برای جداسازی عملیات استفاده می‌کند: ۴ کانال مشترک (برای برنامه‌های عمومی، IoT، امنیت، و نظارت) و ۱۰ کانال سازمانی (یکی برای هر سازمان).

   ### مختصات آنتن‌ها
   هر سازمان یک آنتن با مختصات ثابت دارد که برای محاسبه فاصله اقلیدسی در قراردادهای هوشمند (مانند `GeoAssign`) استفاده می‌شود:
   - **Org1**: (100, 100)
   - **Org2**: (200, 100)
   - **Org3**: (300, 100)
   - **Org4**: (100, 200)
   - **Org5**: (200, 200)
   - **Org6**: (300, 200)
   - **Org7**: (100, 300)
   - **Org8**: (200, 300)
   - **Org9**: (300, 300)
   - **Org10**: (400, 300)

   این مختصات برای تخصیص کاربران/IoT‌ها به نزدیک‌ترین آنتن استفاده می‌شوند. مختصات کاربران/IoT‌ها به‌صورت تصادفی در محدوده (0 تا 500) تولید می‌شوند.

   ## ساختار پروژه
   پروژه شامل فایل‌ها و دایرکتوری‌های زیر است:
   - **`crypto-config.yaml`**: تعریف سازمان‌ها، همتاها، و گواهی‌ها با استفاده از ابزار `cryptogen`.
   - **`configtx.yaml`**: پیکربندی کانال‌ها، پروفایل‌ها، و ترتیب‌دهنده برای تولید آرتیفکت‌های کانال و بلاک جنسیس.
   - **`docker-compose.yaml`**: تعریف سرویس‌های شبکه شامل ۱ ترتیب‌دهنده، ۱۰ همتا، و ۱۰ کانتینر CLI (یکی برای هر سازمان).
   - **`core-org1.yaml` تا `core-org10.yaml`**: فایل‌های پیکربندی برای CLI هر سازمان.
   - **`setup_network.sh`**: اسکریپت راه‌اندازی شبکه و تولید آرتیفکت‌ها.
   - **`generateCoreYamls.sh`**: تولید فایل‌های `core.yaml` برای هر سازمان.
   - **`generateConnectionProfiles.sh`**: تولید پروفایل‌های اتصال JSON برای Caliper و Tape.
   - **`generateChaincodes.sh`**: تولید ۷۰ قرارداد هوشمند Go.
   - **`generateWorkloadFiles.sh`**: تولید فایل‌های workload برای تست‌های Caliper.
   - **`generateTapeConfigs.sh`**: تولید فایل‌های پیکربندی Tape برای تست قراردادها.
   - **`caliper/`**: شامل `benchmarkConfig.yaml` و `networkConfig.yaml` برای تست عملکرد با Caliper.
   - **`tape/`**: شامل فایل‌های `tape-*.yaml` برای تست قراردادها با Tape.
   - **`create_zip.sh`**: اسکریپت برای فشرده‌سازی پروژه.
   - **`chaincode/`**: دایرکتوری قراردادهای هوشمند (مانند `GeoAssign`, `GeoUpdate`, و غیره).
   - **`channel-artifacts/`**: آرتیفکت‌های کانال (مانند `genesis.block`, `generalchannel.tx`).
   - **`crypto-config/`**: گواهی‌ها و کلیدهای تولیدشده توسط `cryptogen`.

   ## کانال‌ها
   شبکه شامل **۱۴ کانال** است که به شرح زیر سازمان‌دهی شده‌اند:
   1. **کانال‌های مشترک**:
      - **`generalchannelapp`**: برای عملیات عمومی مانند تخصیص جغرافیایی، احراز هویت کاربران، و مدیریت پهنای باند (شامل قراردادهایی مانند `GeoAssign`, `GeoUpdate`, `AuthUser`).
      - **`iotchannelapp`**: برای عملیات مربوط به دستگاه‌های IoT (مانند `AuthIoT`, `ConnectIoT`, `IoTBandwidth`).
      - **`securitychannelapp`**: برای عملیات امنیتی (مانند `IntrusionDetect`, `KeyManage`, `QuantumEncrypt`).
      - **`monitoringchannelapp`**: برای نظارت بر عملکرد شبکه (مانند `TrafficMonitor`, `NetworkPerf`, `RealTimeMonitor`).
   2. **کانال‌های سازمانی**:
      - **`org1channelapp` تا `org10channelapp`**: هر سازمان یک کانال اختصاصی برای عملیات داخلی خود دارد (مانند مدیریت کاربران و دستگاه‌های خاص سازمان).

   هر کانال از زیرمجموعه‌ای از ۷۰ قرارداد هوشمند پشتیبانی می‌کند که در فایل `generateTapeConfigs.sh` مشخص شده‌اند.

   ## قراردادهای هوشمند
   پروژه شامل **۷۰ قرارداد هوشمند** است که در دایرکتوری `chaincode/` ذخیره شده‌اند. هر قرارداد شامل دو تابع اصلی است:
   - **`AssignEntity`**: تخصیص یک کاربر یا دستگاه IoT به نزدیک‌ترین آنتن بر اساس فاصله اقلیدسی.
   - **`QueryAssignment`**: بازیابی اطلاعات تخصیص برای یک موجودیت خاص.

   لیست قراردادها به شرح زیر است (دسته‌بندی‌شده بر اساس نوع عملیات):
   1. **تخصیص جغرافیایی**:
      - `GeoAssign`: تخصیص اولیه کاربران/IoT‌ها به آنتن‌ها.
      - `GeoUpdate`: به‌روزرسانی مختصات موجودیت‌ها.
      - `GeoHandover`: انتقال کاربران/IoT‌ها بین آنتن‌ها.
   2. **احراز هویت و ثبت‌نام**:
      - `AuthUser`, `AuthIoT`, `AuthAntenna`: احراز هویت کاربران، دستگاه‌های IoT، و آنتن‌ها.
      - `RegisterUser`, `RegisterIoT`: ثبت‌نام کاربران و دستگاه‌های IoT.
      - `RevokeUser`, `RevokeIoT`: ابطال دسترسی کاربران و دستگاه‌های IoT.
   3. **مدیریت منابع و پهنای باند**:
      - `BandwidthAlloc`, `IoTBandwidth`, `SpectrumShare`: تخصیص و اشتراک پهنای باند.
      - `ResourceRequest`, `ResourceAudit`: درخواست و ممیزی منابع.
   4. **نظارت و تحلیل**:
      - `NetworkPerf`, `TrafficMonitor`, `LatencyTrack`, `EnergyMonitor`, `RealTimeMonitor`: نظارت بر عملکرد شبکه.
      - `IoTAnalytics`, `UserAnalytics`, `DataAnalytics`: تحلیل داده‌های کاربران و IoT.
   5. **امنیت و حریم خصوصی**:
      - `DataEncrypt`, `IoTEncrypt`, `QuantumEncrypt`: رمزنگاری داده‌ها.
      - `IntrusionDetect`, `KeyManage`, `PrivacyPolicy`, `SecureChannel`: مدیریت امنیت و حریم خصوصی.
   6. **مدیریت شبکه و بهینه‌سازی**:
      - `LoadBalance`, `DynamicAlloc`, `DynamicRouting`, `BandwidthShare`, `LatencyOptimize`: بهینه‌سازی منابع و مسیریابی.
      - `EnergyOptimize`, `NetworkOptimize`: بهینه‌سازی مصرف انرژی و عملکرد شبکه.
   7. **تشخیص و مدیریت خطا**:
      - `FaultDetect`, `IoTFault`, `FaultPredict`: تشخیص و پیش‌بینی خطاها.
      - `NetworkHealth`, `IoTHealth`: نظارت بر سلامت شبکه و دستگاه‌ها.
   8. **پیکربندی و ممیزی**:
      - `IoTConfig`, `UserConfig`, `AntennaConfig`: پیکربندی دستگاه‌ها و آنتن‌ها.
      - `PerformanceAudit`, `SecurityAudit`, `ConnectionAudit`: ممیزی عملکرد و امنیت.
   9. **سایر عملیات**:
      - `Roaming`, `SessionTrack`, `IoTSession`, `Disconnect`: مدیریت جابجایی و جلسات.
      - `Billing`, `TransactionLog`, `AccessLog`: صورت‌حساب و ثبت تراکنش‌ها.

   هر قرارداد در یکی از کانال‌های مشترک یا سازمانی مستقر می‌شود. برای جزئیات، به فایل‌های `caliper/benchmarkConfig.yaml` و `tape/tape-*.yaml` مراجعه کنید.

   ## پیش‌نیازها
   برای اجرای پروژه، ابزارهای زیر مورد نیاز است:
   - **Docker و Docker Compose** (نسخه 1.29 یا بالاتر)
   - **Hyperledger Fabric 2.5** (شامل ابزارهای `cryptogen` و `configtxgen`)
   - **Node.js و npm** (برای Caliper و Tape)
   - **Go** (برای قراردادهای هوشمند)
   - **Bash** (برای اجرای اسکریپت‌ها)

   ## نصب پیش‌نیازها
   1. نصب Docker و Docker Compose:
      ```bash
      sudo apt-get update
      sudo apt-get install -y docker.io docker-compose
      sudo systemctl start docker
      sudo systemctl enable docker
      ```

   2. نصب ابزارهای Hyperledger Fabric:
      ```bash
      curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.5.0 1.5.2
      export PATH=$HOME/fabric-samples/bin:$PATH
      ```

   3. نصب Node.js و npm:
      ```bash
      sudo apt-get install -y nodejs npm
      ```

   4. نصب Caliper و Tape:
      ```bash
      npm install -g @hyperledger/caliper-cli
      npm install -g tape
      ```

   5. نصب Go:
      ```bash
      sudo apt-get install -y golang-go
      export PATH=$PATH:/usr/lib/go/bin
      ```

   ## راه‌اندازی پروژه
   ### ۱. ایجاد ساختار دایرکتوری
   ```bash
   mkdir -p 6g-fabric-project/{channel-artifacts,crypto-config,chaincode,workload,caliper,tape}
   cd 6g-fabric-project
   ```

   ### ۲. ذخیره فایل‌های پروژه
   فایل‌های زیر را در دایرکتوری پروژه ذخیره کنید:
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
   - `caliper/benchmarkConfig.yaml`
   - `caliper/networkConfig.yaml`
   - `tape/tape-*.yaml`
   - `create_zip.sh`
   - `README.md`

   ### ۳. تنظیم مجوزهای اسکریپت‌ها
   ```bash
   chmod +x setup_network.sh generateCoreYamls.sh generateConnectionProfiles.sh generateChaincodes.sh generateWorkloadFiles.sh generateTapeConfigs.sh create_zip.sh
   ```

   ### ۴. اجرای اسکریپت راه‌اندازی
   ```bash
   ./setup_network.sh
   ```
   این اسکریپت:
   - دایرکتوری‌های مورد نیاز را ایجاد می‌کند.
   - گواهی‌ها را با `cryptogen` تولید می‌کند.
   - فایل‌های `core.yaml` را برای هر سازمان تولید می‌کند.
   - پروفایل‌های اتصال، قراردادهای هوشمند، و فایل‌های workload و Tape را تولید می‌کند.
   - بلاک جنسیس و آرتیفکت‌های کانال را با `configtxgen` تولید می‌کند.

   ### ۵. راه‌اندازی شبکه
   ```bash
   docker-compose -f docker-compose.yaml up -d
   ```
   این دستور ۲۱ کانتینر را راه‌اندازی می‌کند:
   - ۱ ترتیب‌دهنده: `orderer1.example.com`
   - ۱۰ همتا: `peer0.org1.example.com` تا `peer0.org10.example.com`
   - ۱۰ CLI: `cli-org1` تا `cli-org10`

   بررسی کنید که تمام کانتینرها فعال هستند:
   ```bash
   docker ps -a
   ```

   ### ۶. ایجاد کانال‌ها
   برای هر سازمان، به کانتینر CLI مربوطه وارد شوید و کانال‌ها را ایجاد کنید. به‌عنوان مثال، برای `Org1`:
   ```bash
   docker exec -it cli-org1 bash
   ```
   سپس کانال‌های مشترک را ایجاد کنید:
   ```bash
   export CHANNEL_NAME=generalchannelapp
   peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/generalchannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
   peer channel join -b ./channel-artifacts/generalchannel.block
   ```
   این کار را برای `iotchannelapp`, `securitychannelapp`, و `monitoringchannelapp` تکرار کنید:
   ```bash
   export CHANNEL_NAME=iotchannelapp
   peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/iotchannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
   peer channel join -b ./channel-artifacts/iotchannel.block

   export CHANNEL_NAME=securitychannelapp
   peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/securitychannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
   peer channel join -b ./channel-artifacts/securitychannel.block

   export CHANNEL_NAME=monitoringchannelapp
   peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/monitoringchannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
   peer channel join -b ./channel-artifacts/monitoringchannel.block
   ```
   برای کانال سازمانی `org1channelapp`:
   ```bash
   export CHANNEL_NAME=org1channelapp
   peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/org1channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
   peer channel join -b ./channel-artifacts/org1channel.block
   ```
   برای سازمان‌های دیگر (`Org2` تا `Org10`)، به کانتینرهای `cli-org2` تا `cli-org10` وارد شوید و دستورات بالا را با نام کانال مربوطه (`org2channelapp` تا `org10channelapp`) تکرار کنید.

   ### ۷. نصب و فعال‌سازی قراردادهای هوشمند
   برای هر قرارداد و کانال، قرارداد را نصب و فعال کنید. به‌عنوان مثال، برای `GeoAssign` در `generalchannelapp`:
   ```bash
   peer lifecycle chaincode package geoassign.tar.gz --path /opt/gopath/src/github.com/chaincode/GeoAssign --lang golang --label geoassign_1
   peer lifecycle chaincode install geoassign.tar.gz
   peer lifecycle chaincode approveformyorg -o orderer1.example.com:7050 --channelID generalchannelapp --name GeoAssign --version 1.0 --package-id geoassign_1 --sequence 1 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
   peer lifecycle chaincode commit -o orderer1.example.com:7050 --channelID generalchannelapp --name GeoAssign --version 1.0 --sequence 1 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
   ```
   این مراحل را برای سایر قراردادها و کانال‌ها تکرار کنید. برای کانال‌های سازمانی، فقط سازمان مربوطه قرارداد را نصب و تأیید می‌کند.

   ### ۸. تست عملکرد
   پروژه از دو ابزار برای تست عملکرد استفاده می‌کند: **Caliper** و **Tape**.

   #### تست با Caliper
   Caliper برای تست تمام ۷۰ قرارداد در کانال‌های مربوطه استفاده می‌شود. فایل `caliper/benchmarkConfig.yaml` شامل تنظیمات برای هر قرارداد است.
   ```bash
   ENTITY_COUNT=1000 npx caliper launch manager --caliper-benchconfig caliper/benchmarkConfig.yaml --caliper-networkconfig caliper/networkConfig.yaml
   ```
   - `ENTITY_COUNT=1000`: تعداد موجودیت‌ها (کاربران/IoT) برای تست.
   - هر قرارداد ۱۰۰۰ تراکنش با نرخ ۱۰۰ TPS اجرا می‌کند.
   - نتایج در دایرکتوری `caliper/` ذخیره می‌شوند.

   #### تست با Tape
   Tape برای تست فردی قراردادها در کانال‌های خاص استفاده می‌شود. فایل‌های `tape/tape-*.yaml` برای هر قرارداد و کانال تولید شده‌اند.
   به‌عنوان مثال، برای تست `GeoAssign` در `generalchannelapp`:
   ```bash
   ENTITY_COUNT=1000 tape --config tape/tape-geoassign-generalchannelapp.yaml
   ```
   برای تست سایر قراردادها، فایل `tapeConfig.yaml` مربوطه را مشخص کنید (مانند `tape/tape-authiot-iotchannelapp.yaml`).

   #### سناریوهای تست
   1. **تست کامل شبکه**:
      - تمام قراردادها را در تمام کانال‌ها با Caliper تست کنید.
      - از `benchmarkConfig.yaml` استفاده کنید که شامل تمام ۷۰ قرارداد است.
   2. **تست قراردادهای خاص**:
      - برای تست یک قرارداد خاص (مانند `GeoAssign`)، فایل `tape/tape-geoassign-generalchannelapp.yaml` را با Tape اجرا کنید.
   3. **تست کانال‌های سازمانی**:
      - برای تست قراردادها در کانال‌های سازمانی (مانند `org1channelapp`)، از `cli-org1` و فایل `tape/tape-geoassign-org1channelapp.yaml` استفاده کنید.
   4. **تست مقیاس‌پذیری**:
      - تعداد موجودیت‌ها (`ENTITY_COUNT`) را به ۵۰۰۰ یا ۱۰۰۰۰ افزایش دهید و عملکرد را با Caliper بررسی کنید:
        ```bash
        ENTITY_COUNT=5000 npx caliper launch manager --caliper-benchconfig caliper/benchmarkConfig.yaml --caliper-networkconfig caliper/networkConfig.yaml
        ```

   ### ۹. فشرده‌سازی پروژه
   برای ایجاد فایل زیپ پروژه:
   ```bash
   ./create_zip.sh
   ```
   این اسکریپت فایل‌های غیرضروری (مانند `.git`, `node_modules`, `channel-artifacts`, `crypto-config`) را حذف کرده و فایل `6g-fabric-project.zip` را تولید می‌کند.

   ## رفع اشکال
   ### خطای `No such container: cli`
   - **علت**: کانتینرهای CLI در `docker-compose.yaml` تعریف نشده‌اند یا اجرا نشده‌اند.
   - **راه‌حل**:
     - اطمینان حاصل کنید که `docker-compose.yaml` شامل سرویس‌های `cli-org1` تا `cli-org10` است.
     - بررسی کنید که دستور `docker-compose -f docker-compose.yaml up -d` اجرا شده است.
     - خروجی `docker ps -a` را بررسی کنید تا مطمئن شوید تمام کانتینرها فعال هستند.

   ### خطای `Config File "core" Not Found`
   - **علت**: فایل‌های `core-org1.yaml` تا `core-org10.yaml` در دایرکتوری پروژه وجود ندارند یا به درستی مپ نشده‌اند.
   - **راه‌حل**:
     - اسکریپت `generateCoreYamls.sh` را اجرا کنید:
       ```bash
       ./generateCoreYamls.sh
       ```
     - اطمینان حاصل کنید که فایل‌های `core-orgX.yaml` به مسیر `/opt/gopath/src/github.com/hyperledger/fabric/peer/config/core.yaml` در کانتینرهای CLI مپ شده‌اند.

   ### خطای `etcdraft configuration missing`
   - **علت**: بخش `EtcdRaft` در `configtx.yaml` ناقص است.
   - **راه‌حل**:
     - بررسی کنید که بخش `EtcdRaft` در `configtx.yaml` شامل تعریف `Consenters` و مسیرهای TLS باشد:
       ```yaml
       EtcdRaft:
         Consenters:
           - Host: orderer1.example.com
             Port: 7050
             ClientTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.crt
             ServerTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.crt
       ```

   ### خطاهای عمومی
   - **کانتینرها اجرا نمی‌شوند**:
     - لاگ‌ها را بررسی کنید:
       ```bash
       docker logs cli-org1
       docker logs orderer1.example.com
       docker logs peer0.org1.example.com
       ```
     - اطمینان حاصل کنید که پورت‌ها (7050, 7051, 8051, ..., 16051) آزاد هستند:
       ```bash
       netstat -tuln | grep 7050
       ```
   - **خطای نصب قرارداد**:
     - بررسی کنید که دایرکتوری `chaincode/` شامل فایل‌های Go قراردادها باشد.
     - اسکریپت `generateChaincodes.sh` را دوباره اجرا کنید:
       ```bash
       ./generateChaincodes.sh
       ```

   ## پاکسازی محیط
   برای توقف و حذف شبکه:
   ```bash
   docker-compose -f docker-compose.yaml down
   docker volume prune -f
   rm -rf channel-artifacts crypto-config
   ```

   ## بررسی نسخه‌ها
   اطمینان حاصل کنید که نسخه‌های درست نصب شده‌اند:
   ```bash
   peer version
   configtxgen --version
   docker --version
   docker-compose --version
   node --version
   npm --version
   go version
   ```

   ## پشتیبانی
   برای مشکلات، اطلاعات زیر را بررسی یا ارائه دهید:
   1. خروجی `docker ps -a`.
   2. لاگ‌های کانتینرها (`docker logs cli-org1`, `docker logs orderer1.example.com`).
   3. خروجی دستورات `peer version` و `configtxgen --version`.
   4. هرگونه تغییر دستی در فایل‌ها یا اسکریپت‌ها.

   ## نکات اضافی
   - **مقیاس‌پذیری**: برای تست مقیاس‌پذیری، تعداد همتاها یا سازمان‌ها را می‌توانید با ویرایش `crypto-config.yaml` و `docker-compose.yaml` افزایش دهید.
   - **شبیه‌سازی مختصات**: برای شبیه‌سازی واقعی‌تر، می‌توانید مختصات آنتن‌ها را در قراردادهای هوشمند تغییر دهید.
   - **اتوماسیون**: برای خودکارسازی نصب قراردادها در تمام سازمان‌ها و کانال‌ها، می‌توانید اسکریپت‌های اضافی بنویسید. در صورت نیاز، درخواست کنید.

   این پروژه یک زیرساخت قوی برای شبیه‌سازی شبکه 6G با استفاده از Hyperledger Fabric فراهم می‌کند و برای تست‌های عملکرد و توسعه بیشتر مناسب است.
   EOF
   ```

3. **دانلود فایل در محیط‌های مختلف**:
   - **لینوکس/مک**:
     پس از ذخیره فایل، می‌توانید آن را به سیستم محلی خود منتقل کنید:
     ```bash
     scp README.md user@your-local-machine:/path/to/destination
     ```
   - **ویندوز (با WSL یا Git Bash)**:
     فایل را ذخیره کرده و از ابزارهایی مانند WinSCP برای انتقال استفاده کنید.
   - **محیط‌های وب (مانند Jupyter Notebook)**:
     اگر در محیط وب هستید، فایل `README.md` را ذخیره کرده و از رابط کاربری برای دانلود استفاده کنید (مثلاً گزینه "Download" در Jupyter).
   - **سرور ابری**:
     اگر روی سرور ابری کار می‌کنید، فایل را به یک مکان قابل دسترسی (مانند Google Drive یا سرور FTP) آپلود کنید:
     ```bash
     curl -T README.md ftp://your-ftp-server.com/path/to/destination --user username:password
     ```

---

### نکات اضافی
- **تأیید فایل**: پس از ذخیره، محتوای فایل را بررسی کنید:
  ```bash
  cat README.md
  ```
  اطمینان حاصل کنید که ساختار و محتوا درست است.

- **رفع اشکال**: اگر در ذخیره یا انتقال فایل مشکلی داشتید، موارد زیر را بررسی کنید:
  - خروجی `ls -l` برای تأیید وجود فایل `README.md`.
  - مجوزهای فایل:
    ```bash
    ls -l README.md
    chmod 644 README.md
    ```
  - اگر فایل به درستی ذخیره نشده، محتوای بالا را دوباره کپی کنید.

- **درخواست فایل‌های دیگر**: اگر نیاز به فایل‌های دیگر پروژه (مانند `docker-compose.yaml`, `crypto-config.yaml`, یا اسکریپت‌ها) به‌صورت جداگانه دارید، لطفاً مشخص کنید تا محتوای آن‌ها را ارائه کنم.

---

### اگر مشکل ادامه داشت
لطفاً اطلاعات زیر را ارائه دهید:
1. محیطی که در آن کار می‌کنید (لینوکس، مک، ویندوز، سرور ابری، یا رابط وب).
2. روش دانلود مورد نظر (مثلاً مستقیم، FTP، یا لینک اشتراک).
3. هرگونه خطا در ذخیره یا انتقال فایل.
4. خروجی دستور `ls -l` در دایرکتوری پروژه.

این فایل `README.md` به‌صورت جداگانه ارائه شده و آماده ذخیره و دانلود است. اگر نیاز به روش خاصی برای دانلود یا افزودن به پروژه دارید، لطفاً جزئیات بیشتری ارائه دهید.
