پروژه شبکه 6G Fabric با Hyperledger Fabric
این پروژه یک شبکه بلاک‌چین مبتنی بر Hyperledger Fabric نسخه 2.5 را پیاده‌سازی می‌کند که برای شبیه‌سازی یک شبکه 6G طراحی شده است. سازمان‌ها به عنوان آنتن‌های اصلی (Org1 تا Org10)، دستگاه‌های IoT به عنوان آنتن‌های پشتیبانی، و کاربران به عنوان اعضای سازمان‌ها تعریف شده‌اند. تخصیص کاربران و دستگاه‌های IoT به نزدیک‌ترین آنتن بر اساس فاصله اقلیدسی انجام می‌شود. پروژه شامل ۷۰ قرارداد هوشمند، چندین کانال برای جداسازی تراکنش‌ها، و ابزارهای تست عملکرد (Caliper و Tape) با پشتیبانی از موقعیت‌های تصادفی است.
ویژگی‌های کلیدی

سازمان‌ها (آنتن‌ها): ۱۰ سازمان (Org1 تا Org10)، هر کدام با یک همتا (peer) و یک CA.
کاربران و IoT‌ها: تخصیص به نزدیک‌ترین آنتن بر اساس مختصات جغرافیایی (x, y) با استفاده از فاصله اقلیدسی.
کانال‌ها:
GeneralChannel: برای همکاری بین تمام ۱۰ آنتن.
IoTChannel: برای مدیریت تراکنش‌های دستگاه‌های IoT.
SecurityChannel: برای تراکنش‌های امنیتی مانند تشخیص نفوذ و رمزنگاری کوانتومی.
MonitoringChannel: برای نظارت بلادرنگ و گزارش‌گیری شبکه.
Org1Channel تا Org10Channel: کانال‌های اختصاصی برای هر آنتن.


قراردادهای هوشمند: ۷۰ قرارداد هوشمند برای مدیریت تخصیص، احراز هویت، نظارت، بهینه‌سازی، و امنیت شبکه.
تست عملکرد:
Caliper: تست بار با موقعیت‌های تصادفی و سناریوهای مختلف.
Tape: تست تراکنش‌ها با پیکربندی‌های انعطاف‌پذیر.


موقعیت‌های تصادفی: مختصات تصادفی در محدوده 0 تا 500 برای کاربران و IoT‌ها.

ساختار پروژه

channel-artifacts/: شامل آرتیفکت‌های کانال‌ها (مانند genesis.block و فایل‌های tx).
crypto-config/: گواهی‌ها و کلیدهای رمزنگاری برای سازمان‌ها.
chaincode/: کد منبع ۷۰ قرارداد هوشمند (به زبان Go).
workload/: فایل‌های workload برای Caliper (به زبان JavaScript).
caliper/: پیکربندی‌های Caliper (networkConfig.yaml و benchmarkConfig.yaml).
tape/: پیکربندی Tape (tapeConfig.yaml).
اسکریپت‌ها:
setup_network.sh: تولید آرتیفاکت‌ها و راه‌اندازی اولیه.
generateConnectionProfiles.sh: تولید پروفایل‌های اتصال.
generateChaincodes.sh: تولید قراردادها.
generateWorkloadFiles.sh: تولید فایل‌های workload برای.
create_zip.sh: ایجاد فایل ZIP از پروژه.


فایل‌های پیکربندی:
crypto-config.yaml: تعریف سازمان‌ها و CAها.
configtx.yaml: تعریف کانال‌ها و سیاست‌ها.
docker-compose.yaml: راه‌اندازی سرویس‌های شبکه.



مختصات آنتن‌ها
آنتن‌ها (سازمان‌ها) دارای مختصات ثابت زیر هستند:

Org1: (100, 100)
Org2: (200, 100)
Org3: (300, 100)
Org4: (100, 200)
Org5: (200, 200)
Org6: (300, 200)
Org7: (100, 300)
Org8: (200, 300)
Org9: (300, 300)
Org10: (400, 300)

قراردادهای هوشمند
هر قرارداد شامل دو تابع اصلی است:

AssignEntity(entityID, x, y): تخصیص کاربر یا دستگاه IoT به نزدیک‌ترین آنتن بر اساس مختصات.
QueryAssignment(entityID): بازیابی اطلاعات تخصیص.

لیست قراردادها

GeoAssign: تخصیص کاربر/IoT به نزدیک‌ترین آنتن.
GeoUpdate: به‌روزرسانی مختصات کاربر/IoT.
GeoHandover: انتقال کاربر/IoT بین آنتن‌ها.
AuthUser: احراز هویت کاربران.
AuthIoT: احراز هویت دستگاه‌های IoT.
ConnectUser: اتصال کاربران به آنتن.
ConnectIoT: اتصال IoT‌ها به آنتن.
BandwidthAlloc: تخصیص پهنای باند.
AuthAntenna: احراز هویت آنتن‌ها.
RegisterUser: ثبت‌نام کاربران.
RegisterIoT: ثبت‌نام IoT‌ها.
RevokeUser: لغو دسترسی کاربران.
RevokeIoT: لغو دسترسی IoT‌ها.
RoleAssign: تخصیص نقش‌ها.
AccessControl: کنترل دسترسی.
AuditIdentity: حسابرسی هویت‌ها.
IoTBandwidth: مدیریت پهنای باند IoT.
AntennaLoad: نظارت بر بار آنتن‌ها.
ResourceRequest: درخواست منابع.
QoSManage: مدیریت کیفیت خدمات.
SpectrumShare: اشتراک‌گذاری طیف.
PriorityAssign: تخصیص اولویت.
ResourceAudit: حسابرسی منابع.
LoadBalance: تعادل بار.
DynamicAlloc: تخصیص پویا.
AntennaStatus: نظارت بر وضعیت آنتن‌ها.
IoTStatus: نظارت بر وضعیت IoT‌ها.
NetworkPerf: نظارت بر عملکرد شبکه.
UserActivity: نظارت بر فعالیت کاربران.
FaultDetect: تشخیص خطا در سیستم.
IoTFault: تشخیص خطای IoT.
TrafficMonitor: نظارت بر ترافیک شبکه.
ReportGenerate: تولید گزارش‌های تحلیلی.
LatencyTrack: ردیابی تأخیر شبکه.
EnergyMonitor: نظارت بر مصرف انرژی.
Roaming: مدیریت رومینگ کاربران/IoT.
SessionTrack: ردیابی جلسات کاربران.
IoTSession: ردیابی جلسات IoT.
Disconnect: قطع اتصال کاربران/IoT.
Billing: مدیریت صورت‌حساب.
TransactionLog: ثبت لاگ تراکنش‌ها.
ConnectionAudit: حسابرسی اتصالات.
DataEncrypt: رمزنگاری داده‌ها.
IoTEncrypt: رمزنگاری داده‌های IoT.
AccessLog: ثبت لاگ دسترسی.
IntrusionDetect: تشخیص نفوذ.
KeyManage: مدیریت کلیدهای رمزنگاری.
PrivacyPolicy: اجرای سیاست‌های حریم خصوصی.
SecureChannel: ایجاد کانال امن.
AuditSecurity: حسابرسی امنیتی.
EnergyOptimize: بهینه‌سازی مصرف انرژی.
NetworkOptimize: بهینه‌سازی عملکرد شبکه.
IoTAnalytics: تحلیل داده‌های IoT.
UserAnalytics: تحلیل داده‌های کاربران.
SecurityMonitor: نظارت امنیتی بلادرنگ.
QuantumEncrypt: رمزنگاری کوانتومی.
MultiAntenna: مدیریت چندین آنتن.
EdgeCompute: محاسبات لبه.
IoTHealth: نظارت بر سلامت IoT.
NetworkHealth: نظارت بر سلامت شبکه.
DataIntegrity: تضمین یکپارچگی داده‌ها.
PolicyEnforce: اجرای سیاست‌های شبکه.
DynamicRouting: مسیریابی پویا.
BandwidthShare: اشتراک‌گذاری پهنای باند.
LatencyOptimize: بهینه‌سازی تأخیر.
FaultPredict: پیش‌بینی خطا.
IoTConfig: پیکربندی دستگاه‌های IoT.
UserConfig: پیکربندی کاربران.
AntennaConfig: پیکربندی آنتن‌ها.
PerformanceAudit: حسابرسی عملکرد شبکه.
SecurityAudit: حسابرسی امنیتی پیشرفته.
DataAnalytics: تحلیل داده‌های کلان.
RealTimeMonitor: نظارت بلادرنگ شبکه.

پیش‌نیازها

Docker و Docker Compose (آخرین نسخه پایدار)
Hyperledger Fabric 2.5 (شامل ابزارهای cryptogen، configtxgen، و CLI)
Node.js (نسخه 14 یا بالاتر برای Caliper و Tape)
Go (نسخه 1.17 یا بالاتر برای chaincodeها)
Python (برای اسکریپت‌های کمکی، اختیاری)
Git (برای کلون کردن پروژه)

نصب پیش‌نیازها

نصب Docker و Docker Compose:sudo apt update
sudo apt install docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker


نصب Hyperledger Fabric:curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.5.0 1.5.0
export PATH=$PATH:$PWD/bin


نصب Node.js:curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs


نصب Go:wget https://golang.org/dl/go1.17.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin



راه‌اندازی شبکه

کلون کردن پروژه:git clone <repository-url>
cd 6g-fabric-project


تولید آرتیفکت‌ها:chmod +x *.sh
./setup_network.sh

این اسکریپت:
گواهی‌ها را با cryptogen تولید می‌کند.
پروفایل‌های اتصال را با generateConnectionProfiles.sh ایجاد می‌کند.
قراردادهای هوشمند را با generateChaincodes.sh تولید می‌کند.
فایل‌های workload را با generateWorkloadFiles.sh ایجاد می‌کند.
بلاک جنسیس و آرتیفکت‌های کانال‌ها را با configtxgen تولید می‌کند.


راه‌اندازی شبکه با Docker:docker-compose -f docker-compose.yaml up -d

این دستور سرویس‌های زیر را راه‌اندازی می‌کند:
۱ ترتیب‌دهنده (orderer1.example.com)
۱۰ همتا (peer0.org1.example.com تا peer0.org10.example.com)
۱۰ CA (ca.org1.example.com تا ca.org10.example.com)


ایجاد کانال‌ها:از CLI Fabric برای ایجاد کانال‌ها استفاده کنید:docker exec -it cli bash
export CHANNEL_NAME=generalchannelapp
peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/generalchannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

این کار را برای سایر کانال‌ها (iotchannelapp, securitychannelapp, monitoringchannelapp, و org1channelapp تا org10channelapp) تکرار کنید.
نصب و تأیید قراردادهای هوشمند:برای نصب قرارداد مثلاً GeoAssign در GeneralChannel:peer lifecycle chaincode package geoassign.tar.gz --path /opt/gopath/src/github.com/chaincode/GeoAssign --lang golang --label geoassign_1
peer lifecycle chaincode install geoassign.tar.gz
peer lifecycle chaincode approveformyorg -o orderer1.example.com:7050 --channelID generalchannelapp --name GeoAssign --version 1.0 --package-id geoassign_1 --sequence 1 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer lifecycle chaincode commit -o orderer1.example.com:7050 --channelID generalchannelapp --name GeoAssign --version 1.0 --sequence 1 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

این مراحل را برای سایر قراردادها و کانال‌ها تکرار کنید.

تست با Caliper
Caliper برای تست عملکرد شبکه با سناریوهای مختلف استفاده می‌شود. فایل caliper/benchmarkConfig.yaml شامل ۷۰ دور تست (یکی برای هر قرارداد) با ۱۰۰۰ تراکنش و نرخ ۱۰۰ تراکنش در ثانیه (tps) است.
پیش‌نیازهای Caliper

نصب Caliper:npm install -g @hyperledger/caliper-cli@0.4.2
npm install --save @hyperledger/fabric-sdk-node@2.2.0


تنظیم متغیرهای محیطی:export FABRIC_SDK_LOGLEVEL=info



حالت‌های تست Caliper

تست پیش‌فرض (تمام قراردادها):ENTITY_COUNT=1000 npx caliper launch manager --caliper-benchconfig caliper/benchmarkConfig.yaml --caliper-networkconfig caliper/networkConfig.yaml


توضیح: تست تمام ۷۰ قرارداد با ۱۰۰۰ موجودیت (کاربر/IoT) و مختصات تصادفی (0 تا 500).
خروجی: گزارش HTML در دایرکتوری report با معیارهای تأخیر، توان عملیاتی، و مصرف منابع.


تست با تعداد موجودیت‌های بیشتر:برای تست با ۱۰۰۰۰ موجودیت:ENTITY_COUNT=10000 npx caliper launch manager --caliper-benchconfig caliper/benchmarkConfig.yaml --caliper-networkconfig caliper/networkConfig.yaml


توضیح: افزایش تعداد موجودیت‌ها برای شبیه‌سازی بار سنگین‌تر.


تست با نرخ تراکنش بالاتر:فایل caliper/benchmarkConfig.yaml را ویرایش کنید و tps را به ۵۰۰ تغییر دهید:rateControl:
  type: fixed-rate
  opts:
    tps: 500

سپس تست را اجرا کنید:ENTITY_COUNT=1000 npx caliper launch manager --caliper-benchconfig caliper/benchmarkConfig.yaml --caliper-networkconfig caliper/networkConfig.yaml


توضیح: تست عملکرد شبکه تحت بار تراکنشی بالا.


تست یک قرارداد خاص:برای تست فقط قرارداد GeoAssign، بخش‌های دیگر را از benchmarkConfig.yaml حذف کنید و فقط دور زیر را نگه دارید:rounds:
  - label: GeoAssign
    txNumber: 1000
    rateControl:
      type: fixed-rate
      opts:
        tps: 100
    workload:
      module: workload/geoassign.js

سپس تست را اجرا کنید:npx caliper launch manager --caliper-benchconfig caliper/benchmarkConfig.yaml --caliper-networkconfig caliper/networkConfig.yaml


توضیح: مناسب برای دیباگ یا تحلیل یک قرارداد خاص.



نکات Caliper

ENTITY_COUNT: تعداد موجودیت‌ها (پیش‌فرض: ۱۰۰۰). برای تست‌های سنگین‌تر، آن را افزایش دهید.
موقعیت‌های تصادفی: مختصات x و y بین 0 تا 500 تولید می‌شوند.
گزارش‌ها: گزارش‌های HTML در دایرکتوری report ذخیره می‌شوند.
تنظیمات پیشرفته: برای تغییر تعداد کلاینت‌ها، number را در clients در benchmarkConfig.yaml ویرایش کنید.

تست با Tape
Tape برای تست تراکنش‌ها با پیکربندی‌های انعطاف‌پذیر استفاده می‌شود. فایل tape/tapeConfig.yaml برای تست قرارداد GeoAssign در GeneralChannel با ۱۰۰۰ موجودیت پیکربندی شده است.
پیش‌نیازهای Tape

نصب Tape:npm install -g tape


کپی فایل‌های گواهی به دایرکتوری Tape:mkdir -p tape/crypto
cp -r crypto-config/* tape/crypto/



حالت‌های تست Tape

تست پیش‌فرض:ENTITY_COUNT=1000 tape --config tape/tapeConfig.yaml


توضیح: تست قرارداد GeoAssign با ۱۰۰۰ موجودیت و مختصات تصادفی (0 تا 500).
خروجی: گزارش متنی با معیارهای توان عملیاتی و تأخیر.


تست با تعداد موجودیت‌های بیشتر:ENTITY_COUNT=10000 tape --config tape/tapeConfig.yaml


توضیح: شبیه‌سازی بار سنگین‌تر با ۱۰۰۰۰ موجودیت.


تست قرارداد دیگر:برای تست قرارداد IntrusionDetect در SecurityChannel، فایل tapeConfig.yaml را ویرایش کنید:chaincode:
  id: IntrusionDetect
  version: v1
  language: golang
  path: chaincode/IntrusionDetect
channels:
  - name: securitychannelapp
    chaincodes:
      - id: IntrusionDetect
        version: v1
        language: golang
        path: chaincode/IntrusionDetect

سپس تست را اجرا کنید:ENTITY_COUNT=1000 tape --config tape/tapeConfig.yaml


توضیح: تست قرارداد امنیتی در کانال مربوطه.


تست با نرخ تراکنش بالاتر:در tapeConfig.yaml، مقدار rate را به ۵۰۰ تغییر دهید:rate: 500

سپس تست را اجرا کنید:ENTITY_COUNT=1000 tape --config tape/tapeConfig.yaml


توضیح: تست عملکرد تحت بار تراکنشی بالا.



نکات Tape

ENTITY_COUNT: تعداد موجودیت‌ها (پیش‌فرض: ۱۰۰۰). برای تست‌های سنگین‌تر، آن را افزایش دهید.
موقعیت‌های تصادفی: مختصات در فایل tapeConfig.yaml به‌صورت تصادفی تولید می‌شوند.
خروجی: گزارش‌های متنی در کنسول نمایش داده می‌شوند.
تنظیمات پیشرفته: برای تغییر تعداد کلاینت‌ها، clients را در tapeConfig.yaml ویرایش کنید.

ایجاد فایل ZIP
برای بسته‌بندی پروژه:
./create_zip.sh

این اسکریپت تمام فایل‌ها را در 6g_fabric_project.zip بسته‌بندی می‌کند.
نکات و توصیه‌ها

مقیاس‌پذیری: برای تست‌های مقیاس بزرگ، تعداد همتاها یا ترتیب‌دهنده‌ها را در docker-compose.yaml افزایش دهید.
دیباگ: لاگ‌های Docker را با docker logs <container-name> بررسی کنید.
بهینه‌سازی: برای بهبود عملکرد، سیاست‌های تأیید (endorsement policies) را در configtx.yaml تنظیم کنید.
امنیت: گواهی‌ها و کلیدها را در محیط عملیاتی با احتیاط مدیریت کنید.
سناریوهای پیشرفته:
برای شبیه‌سازی شبکه‌های پیچیده‌تر، تعداد آنتن‌ها را در crypto-config.yaml افزایش دهید.
قراردادهای جدید (مانند QuantumEncrypt) برای سناریوهای آینده‌نگرانه 6G طراحی شده‌اند.



محدودیت‌ها

قراردادها در حال حاضر فقط تخصیص مبتنی بر فاصله و پرس‌وجو را پیاده‌سازی کرده‌اند. برای منطق پیچیده‌تر، کد chaincode را گسترش دهید.
تست‌های Caliper و Tape برای محیط محلی بهینه شده‌اند. برای محیط‌های توزیع‌شده، پیکربندی شبکه را اصلاح کنید.
مصرف منابع (CPU و RAM) در تست‌های سنگین ممکن است بالا باشد.

پشتیبانی
برای سؤالات یا مشکلات، با تیم توسعه تماس بگیرید یا یک issue در مخزن پروژه باز کنید.
