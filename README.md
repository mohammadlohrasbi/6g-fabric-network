پروژه 6G Fabric
این پروژه یک شبکه بلاکچین مبتنی بر Hyperledger Fabric برای شبیه‌سازی شبکه‌های 6G طراحی شده است. شامل ۱ ترتیب‌دهنده، ۱۰ سازمان، ۱۴ کانال، و ۷۰ قرارداد هوشمند است که در دسته‌های مختلف برای مدیریت، نظارت، امنیت، و تحلیل داده در شبکه‌های 6G طراحی شده‌اند.
پیش‌نیازها

سیستم‌عامل: اوبونتو 20.04 یا بالاتر
نرم‌افزارها:
Docker و Docker Compose
Node.js و npm
Go
Hyperledger Fabric 2.5
Hyperledger Fabric CA 1.5
Caliper و Tape



نصب پیش‌نیازها
در یک ماشین لینوکس (ترجیحاً اوبونتو)، دستورات زیر را اجرا کنید:
sudo apt-get update
sudo apt-get install -y docker.io docker-compose nodejs npm golang-go
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.5.0 1.5.2
export PATH=$HOME/fabric-samples/bin:$PATH
npm install -g @hyperledger/caliper-cli tape

ساختار پروژه

crypto-config/: گواهی‌ها و کلیدها (تولیدشده توسط cryptogen)
channel-artifacts/: آرتیفکت‌های کانال (تولیدشده توسط configtxgen)
chaincode/: قراردادهای هوشمند (۷۰ قرارداد در زیرپوشه‌ها)
workload/: فایل‌های ورک‌لود برای تست‌های Caliper و Tape
caliper/: پیکربندی‌های تست Caliper
tape/: پیکربندی‌های تست Tape
core-org[1-10].yaml: فایل‌های پیکربندی برای هر سازمان
اسکریپت‌ها: setup_network.sh, generateCoreYamls.sh, generateConnectionProfiles.sh, generateChaincodes.sh, generateWorkloadFiles.sh, generateTapeConfigs.sh, create_zip.sh

توضیحات قراردادهای هوشمند
قراردادهای هوشمند به ۷ دسته تقسیم شده‌اند:
۱. تخصیص منابع (Resource Allocation)
این قراردادها برای تخصیص منابع شبکه مانند پهنای باند، آنتن‌ها، و مسیریابی پویا طراحی شده‌اند.

GeoAssign: تخصیص دستگاه‌ها به نزدیک‌ترین آنتن بر اساس مختصات جغرافیایی.
توابع: AssignEntity(entityID, x, y, bandwidth), QueryAssignment(entityID)


GeoUpdate: به‌روزرسانی موقعیت دستگاه‌ها و تخصیص مجدد آنتن.
GeoHandover: مدیریت انتقال دستگاه بین آنتن‌ها.
BandwidthAlloc: تخصیص پهنای باند به دستگاه‌ها.
IoTBandwidth: تخصیص پهنای باند برای دستگاه‌های IoT.
SpectrumShare: اشتراک‌گذاری طیف فرکانسی بین سازمان‌ها.
ResourceRequest: ثبت درخواست منابع توسط دستگاه‌ها.
DynamicAlloc: تخصیص پویای منابع بر اساس نیاز.
BandwidthShare: اشتراک‌گذاری پهنای باند بین دستگاه‌ها.
DynamicRouting: مسیریابی پویا برای بهینه‌سازی ارتباطات.
LoadBalance: توزیع بار بین آنتن‌ها.
LatencyOptimize: بهینه‌سازی تأخیر شبکه.
EnergyOptimize: بهینه‌سازی مصرف انرژی.
NetworkOptimize: بهینه‌سازی کلی عملکرد شبکه.

۲. احراز هویت (Authentication)
این قراردادها برای مدیریت هویت و دسترسی کاربران و دستگاه‌ها استفاده می‌شوند.

AuthUser: احراز هویت کاربران.
توابع: RegisterUser(userID, role), QueryUser(userID)


AuthIoT: احراز هویت دستگاه‌های IoT.
AuthAntenna: احراز هویت آنتن‌ها.
RegisterUser: ثبت کاربر جدید.
RegisterIoT: ثبت دستگاه IoT جدید.
RevokeUser: لغو دسترسی کاربر.
RevokeIoT: لغو دسترسی دستگاه IoT.

۳. نظارت (Monitoring)
این قراردادها برای ثبت و نظارت بر متریک‌های شبکه استفاده می‌شوند.

NetworkPerf: ثبت عملکرد شبکه.
توابع: RecordMetric(metricID, value), QueryMetric(metricID)


TrafficMonitor: نظارت بر ترافیک شبکه.
LatencyTrack: ردیابی تأخیر شبکه.
EnergyMonitor: نظارت بر مصرف انرژی.
RealTimeMonitor: نظارت بلادرنگ شبکه.
NetworkHealth: بررسی سلامت شبکه.
IoTHealth: بررسی سلامت دستگاه‌های IoT.
NetworkMonitor: نظارت کلی شبکه.
IoTMonitor: نظارت بر دستگاه‌های IoT.
SecurityMonitor: نظارت بر امنیت شبکه.
PerformanceMonitor: نظارت بر عملکرد کلی.
LatencyMonitor: نظارت اختصاصی بر تأخیر.

۴. امنیت (Security)
این قراردادها برای رمزنگاری و امنیت داده‌ها طراحی شده‌اند.

DataEncrypt: رمزنگاری داده‌های عمومی.
توابع: StoreEncryptedData(dataID, owner, ciphertext), QueryEncryptedData(dataID)


IoTEncrypt: رمزنگاری داده‌های دستگاه‌های IoT.
QuantumEncrypt: رمزنگاری کوانتومی.
IntrusionDetect: تشخیص نفوذ.
KeyManage: مدیریت کلیدهای رمزنگاری.
PrivacyPolicy: مدیریت سیاست‌های حریم خصوصی.
SecureChannel: ایجاد کانال امن برای ارتباطات.

۵. حسابرسی (Audit)
این قراردادها برای ثبت و حسابرسی رویدادهای شبکه استفاده می‌شوند.

ResourceAudit: حسابرسی تخصیص منابع.
توابع: RecordAudit(logID, resource, status), QueryAudit(logID)


PerformanceAudit: حسابرسی عملکرد شبکه.
SecurityAudit: حسابرسی امنیت.
ConnectionAudit: حسابرسی اتصالات.
EnergyAudit: حسابرسی مصرف انرژی.
NetworkAudit: حسابرسی شبکه.
IoTAudit: حسابرسی دستگاه‌های IoT.
UserAudit: حسابرسی کاربران.
DataAudit: حسابرسی داده‌ها.
KeyAudit: حسابرسی کلیدهای رمزنگاری.
PrivacyAudit: حسابرسی حریم خصوصی.
RoutingAudit: حسابرسی مسیریابی.

۶. مدیریت (Management)
این قراردادها برای مدیریت تنظیمات و عملیات شبکه استفاده می‌شوند.

IoTConfig: تنظیمات دستگاه‌های IoT.
توابع: SetConfig(configID, key, value), QueryConfig(configID)


UserConfig: تنظیمات کاربران.
AntennaConfig: تنظیمات آنتن‌ها.
Roaming: مدیریت رومینگ دستگاه‌ها.
SessionTrack: ردیابی جلسات.
IoTSession: مدیریت جلسات IoT.
Disconnect: قطع اتصال دستگاه‌ها.
Billing: مدیریت صورت‌حساب.
TransactionLog: ثبت لاگ تراکنش‌ها.
AccessLog: ثبت لاگ دسترسی.
ConnectIoT: اتصال دستگاه‌های IoT.

۷. تحلیل داده (Analytics)
این قراردادها برای تحلیل داده‌های شبکه استفاده می‌شوند.

IoTAnalytics: تحلیل داده‌های IoT.
توابع: RecordAnalysis(analysisID, key, value), QueryAnalysis(analysisID)


UserAnalytics: تحلیل رفتار کاربران.
DataAnalytics: تحلیل داده‌های عمومی.

۸. تشخیص خطا (Fault Detection)
این قراردادها برای تشخیص و ثبت خطاها طراحی شده‌اند.

FaultDetect: تشخیص خطاهای عمومی.
توابع: RecordFault(faultID, component, severity), QueryFault(faultID)


IoTFault: تشخیص خطاهای دستگاه‌های IoT.
FaultPredict: پیش‌بینی خطاها.

راه‌اندازی پروژه
۱. ایجاد دایرکتوری پروژه
محل اجرا: محیط لینوکس (ترمینال)
mkdir -p 6g-fabric-project
cd 6g-fabric-project

۲. ذخیره فایل‌ها
محل اجرا: محیط لینوکس (ترمینال)

فایل‌های زیر را در دایرکتوری 6g-fabric-project ذخیره کنید:
crypto-config.yaml, configtx.yaml, docker-compose.yaml
core-org[1-10].yaml
setup_network.sh, generateCoreYamls.sh, generateConnectionProfiles.sh, generateChaincodes.sh, generateWorkloadFiles.sh, generateTapeConfigs.sh, create_zip.sh
caliper/benchmarkConfig.yaml, caliper/networkConfig.yaml
workload/callback.js, workload/*.yaml
tape/tape-*.yaml


برای ذخیره هر فایل:nano <filename>
# محتوای فایل را کپی و جای‌گذاری کنید
# ذخیره با Ctrl+O، Enter، Ctrl+X



۳. تنظیم مجوزها
محل اجرا: محیط لینوکس (ترمینال)
chmod +x *.sh

۴. تولید آرتیفکت‌ها و قراردادها
محل اجرا: محیط لینوکس (ترمینال)

اجرای اسکریپت‌های تولید:./generateCoreYamls.sh
./generateConnectionProfiles.sh
./generateChaincodes.sh
./generateWorkloadFiles.sh
./generateTapeConfigs.sh



۵. راه‌اندازی شبکه
محل اجرا: محیط لینوکس (ترمینال)

اجرای اسکریپت راه‌اندازی:./setup_network.sh


راه‌اندازی کانتینرها:docker-compose -f docker-compose.yaml up -d



۶. ثبت‌نام کاربران با CA
محل اجرا: داخل کانتینر cli-org1 (برای Org1) یا cli-orgX (برای سازمان‌های دیگر)

وارد کانتینر cli-org1 شوید:docker exec -it cli-org1 bash


ثبت‌نام ادمین:export FABRIC_CA_CLIENT_HOME=/opt/gopath/src/github.com/hyperledger/fabric/peer
fabric-ca-client enroll -u http://admin:adminpw@ca.org1.example.com:7054 --tls.certfiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem


ثبت‌نام کاربر نمونه:fabric-ca-client register -u http://admin:adminpw@ca.org1.example.com:7054 --id.name user1 --id.secret userpw --id.type client --tls.certfiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem
fabric-ca-client enroll -u http://user1:userpw@ca.org1.example.com:7054 --tls.certfiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem -M /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/user1@org1.example.com/msp


برای سازمان‌های دیگر (Org2 تا Org10)، دستورات مشابه را در cli-orgX با پورت CA مربوطه (8054 برای Org2، 9054 برای Org3، و غیره) اجرا کنید.

۷. ایجاد و پیوستن به کانال‌ها
محل اجرا: داخل کانتینر cli-orgX (برای سازمان مربوطه)

برای هر کانال (مثال برای generalchannelapp):export FABRIC_LOGGING_SPEC=INFO
export CHANNEL_NAME=generalchannelapp
peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/generalchannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel join -b ./channel-artifacts/generalchannel.block


برای کانال‌های orgXchannelapp، از cli-orgX مربوطه استفاده کنید:docker exec -it cli-orgX bash
export CHANNEL_NAME=orgXchannelapp
peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/orgXchannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer channel join -b ./channel-artifacts/orgXchannel.block



۸. نصب و اجرای قراردادهای هوشمند
محل اجرا: داخل کانتینر cli-orgX (برای سازمان مربوطه)

برای هر قرارداد (مثال برای GeoAssign در generalchannelapp):peer lifecycle chaincode package geoassign.tar.gz --path /opt/gopath/src/github.com/chaincode/GeoAssign --lang golang --label geoassign_1
peer lifecycle chaincode install geoassign.tar.gz
peer lifecycle chaincode approveformyorg -o orderer1.example.com:7050 --channelID generalchannelapp --name GeoAssign --version 1.0 --package-id geoassign_1 --sequence 1 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer lifecycle chaincode commit -o orderer1.example.com:7050 --channelID generalchannelapp --name GeoAssign --version 1.0 --sequence 1 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


این مراحل را برای هر قرارداد و کانال در cli-orgX مربوطه تکرار کنید.

۹. تست عملکرد
با Caliper
محل اجرا: محیط لینوکس (ترمینال)

اجرای تست برای تمام قراردادها:ENTITY_COUNT=1000 npx caliper launch manager --caliper-benchconfig caliper/benchmarkConfig.yaml --caliper-networkconfig caliper/networkConfig.yaml



با Tape
محل اجرا: محیط لینوکس (ترمینال)

برای هر قرارداد و کانال (مثال برای GeoAssign در generalchannelapp):ENTITY_COUNT=1000 tape --config tape/tape-geoassign-generalchannelapp.yaml


برای اجرای تمام تست‌ها:for config in tape/tape-*.yaml; do
    ENTITY_COUNT=1000 tape --config "$config"
done



۱۰. ایجاد فایل زیپ
محل اجرا: محیط لینوکس (ترمینال)
./create_zip.sh
scp 6g-fabric-project.zip user@your-local-machine:/path/to/destination

رفع اشکال
اگر با خطا مواجه شدید:

بررسی لاگ‌ها:
محل اجرا: محیط لینوکس (ترمینال)docker logs cli-org1
docker logs orderer1.example.com
docker logs ca.org1.example.com




بررسی نسخه‌ها:
محل اجرا: محیط لینوکس (ترمینال)peer version
configtxgen --version
docker --version
docker-compose --version




بررسی فایل‌های پیکربندی:
محل اجرا: محیط لینوکس (ترمینال)cat core-org1.yaml
cat caliper/networkConfig.yaml




بررسی دایرکتوری‌ها:
محل اجرا: محیط لینوکس (ترمینال)ls -l
ls -l chaincode/
ls -l workload/
ls -l tape/





نکات مهم

CAها: هر سازمان یک سرویس CA دارد (پورت‌های 7054 تا 16054). اطمینان حاصل کنید که پورت‌ها در دسترس هستند.
تست‌ها: فایل‌های Tape برای هر ترکیب قرارداد و کانال (۹۸۰ فایل) تولید شده‌اند. برای اجرای تست‌های خاص، فایل مربوطه را انتخاب کنید.
منابع سیستم: این پروژه به دلیل تعداد زیاد قراردادها و کانال‌ها به منابع سیستمی قابل‌توجهی نیاز دارد (حداقل 16GB RAM و 8 CPU cores توصیه می‌شود).

اگر مشکلی در اجرا وجود داشت یا نیاز به توضیحات بیشتری دارید، لطفاً خروجی دستورات زیر را ارائه دهید:

ls -l
docker logs cli-org1
docker logs orderer1.example.com
محتوای فایل‌های خاص (مانند core-org1.yaml)
