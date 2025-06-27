# راه‌اندازی شبکه Hyperledger Fabric برای 6G

این پروژه یک شبکه Hyperledger Fabric با 10 سازمان (Org1 تا Org10) و چندین کانال (General, IoT, Security, Monitoring, و کانال‌های اختصاصی برای هر سازمان) راه‌اندازی می‌کند. این شبکه شامل یک Orderer، چندین Peer، و مجموعه‌ای از چین‌کدها برای مدیریت منابع، امنیت، و نظارت است.

## پیش‌نیازها
- **نرم‌افزارها**:
  - Docker (نسخه 20.10 یا بالاتر)
  - Docker Compose (نسخه 1.29 یا بالاتر)
  - ابزارهای Hyperledger Fabric (`cryptogen`, `configtxgen`) نسخه 2.4.9
- **سیستم‌عامل**: لینوکس یا مک‌اواس توصیه می‌شود.
- **فایل‌های مورد نیاز**:
  - `crypto-config.yaml`
  - `configtx.yaml`
  - `docker-compose.yaml`
  - `setup_network.sh`

## ساختار پروژه
- **`crypto-config.yaml`**: تعریف سازمان‌ها و تولید گواهی‌ها.
- **`configtx.yaml`**: تعریف پروفایل‌های کانال و سیاست‌ها (شامل تنظیمات `etcdraft` برای Orderer و سیاست `Admins` به‌صورت `ANY Admins`).
- **`docker-compose.yaml`**: تنظیم کانتینرهای Orderer، Peerها، و CA.
- **`setup_network.sh`**: اسکریپت راه‌اندازی شبکه و نصب چین‌کدها.
- **`chaincode/`**: دایرکتوری برای ذخیره کدهای چین‌کد.

## دستورالعمل راه‌اندازی
1. **آماده‌سازی محیط**:
   ```bash
   cd ~/6g-fabric-network
   docker-compose -f docker-compose.yaml down
   docker rm -f $(docker ps -a -q)
   docker network rm 6g-fabric-network_fabric
   rm -rf channel-artifacts crypto-config production
   mkdir -p channel-artifacts production chaincode
   ```

2. **ذخیره فایل‌ها**:
   - فایل‌های زیر را در دایرکتوری پروژه ذخیره کنید:
     - `crypto-config.yaml`
     - `configtx.yaml`
     - `docker-compose.yaml`
     - `setup_network.sh`
   - اسکریپت را قابل اجرا کنید:
     ```bash
     chmod +x setup_network.sh
     dos2unix setup_network.sh
     ```

3. **آماده‌سازی چین‌کدها**:
   - اسکریپت به‌طور خودکار دایرکتوری‌های چین‌کد را بررسی و در صورت نبود ایجاد می‌کند.
   - برای جلوگیری از خطا، می‌توانید یک چین‌کد نمونه ایجاد کنید:
     ```bash
     mkdir -p ./chaincode/ResourceAllocate
     echo 'package main' > ./chaincode/ResourceAllocate/dummy.go
     ```
   - اطمینان حاصل کنید که تمام دایرکتوری‌های چین‌کد (مانند `ResourceAllocate`, `BandwidthShare`, و غیره) در `./chaincode` وجود دارند.

4. **اجرای اسکریپت**:
   ```bash
   ./setup_network.sh
   ```
   - این اسکریپت گواهی‌ها، آرتیفکت‌های کانال، و چین‌کدها را تولید و نصب می‌کند.
   - حدود 90 ثانیه برای پایداری شبکه صبر کنید.

5. **بررسی وضعیت**:
   ```bash
   docker ps
   docker logs orderer.example.com
   docker logs peer0.org1.example.com
   ```

## عیب‌یابی
### خطای `etcdraft configuration missing`
- **علت**: عدم وجود تنظیمات `EtcdRaft` در بخش `Orderer` فایل `configtx.yaml`.
- **راه‌حل**:
  - بررسی کنید که فایل `configtx.yaml` شامل بخش زیر در `OrdererDefaults` باشد:
    ```yaml
    EtcdRaft:
      Consenters:
        - Host: orderer.example.com
          Port: 7050
          ClientTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
          ServerTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
    ```
  - اطمینان حاصل کنید که گواهی‌های TLS در مسیر زیر موجود باشند:
    ```bash
    ls -l crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
    ```
  - فایل `configtx.yaml` را با نسخه ارائه‌شده جایگزین کنید.
  - دوباره اسکریپت را اجرا کنید:
    ```bash
    ./setup_network.sh
    ```

### خطای سیاست `/Channel/Application/Admins`
- **علت**: عدم وجود هویت معتبر مدیر در کانال.
- **راه‌حل**: سیاست `Admins` در `configtx.yaml` به `ANY Admins` اصلاح شده است. بررسی کنید که MSP مدیر برای `Org1` در دایرکتوری زیر موجود باشد:
  ```bash
  ls -l crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
  ```
- تست دستی ایجاد کانال:
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

### خطای نصب چین‌کد
- **علت**: عدم وجود دایرکتوری چین‌کد یا فایل‌های معتبر.
- **راه‌حل**:
  - بررسی دایرکتوری‌های چین‌کد:
    ```bash
    ls -l ./chaincode
    docker exec peer0.org1.example.com ls -l /opt/gopath/src/github.com/chaincode
    ```
  - تست نصب دستی:
    ```bash
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@org1.example.com/msp" \
               -e "CORE_PEER_LOCALMSPID=Org1MSP" \
               peer0.org1.example.com peer chaincode install \
               -n ResourceAllocate -v 1.0 -p "/opt/gopath/src/github.com/chaincode/ResourceAllocate"
    ```

### خطای اتصال به Orderer
- **علت**: Orderer در دسترس نیست یا TLS به درستی تنظیم نشده است.
- **راه‌حل**:
  - بررسی وضعیت Orderer:
    ```bash
    docker logs orderer.example.com | grep -i "error"
    ```
  - بررسی گواهی TLS:
    ```bash
    ls -l crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls
    ```

## نکات
- **چین‌کدها**: اسکریپت شامل نصب و نمونه‌سازی 50 چین‌کد در تمام کانال‌ها است. اطمینان حاصل کنید که دایرکتوری‌های چین‌کد در `./chaincode` وجود دارند.
- **پاک‌سازی**: برای شروع مجدد، از دستورات پاک‌سازی در مرحله آماده‌سازی استفاده کنید.
- **لاگ‌ها**: برای عیب‌یابی دقیق، لاگ‌های کانتینرها را بررسی کنید.

## پشتیبانی
در صورت بروز مشکل، لاگ‌های زیر را بررسی و با تیم پشتیبانی به اشتراک بگذارید:
```bash
docker logs orderer.example.com > orderer.log
docker logs peer0.org1.example.com > peer0.org1.log
```
