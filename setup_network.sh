#!/bin/bash

# تابع بررسی خطا
check_error() {
    if [ $? -ne 0 ]; then
        echo "خطا: $1"
        exit 1
    fi
}

# بررسی پیش‌نیازها
command -v configtxgen >/dev/null 2>&1 || { echo "خطا: configtxgen نصب نشده است"; exit 1; }
command -v cryptogen >/dev/null 2>&1 || { echo "خطا: cryptogen نصب نشده است"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "خطا: docker نصب نشده است"; exit 1; }
#command -v docker-compose >/dev/null 2>&1 || { echo "خطا: docker-compose نصب نشده است"; exit 1; }

echo "شروع راه‌اندازی شبکه 6G Fabric..."

# ایجاد دایرکتوری‌های پروژه
echo "ایجاد دایرکتوری‌های پروژه..."
mkdir -p channel-artifacts crypto-config chaincode workload caliper tape
check_error "ایجاد دایرکتوری‌ها"

# تولید گواهی‌ها با cryptogen
echo "تولید گواهی‌ها..."
cryptogen generate --config=./crypto-config.yaml
check_error "تولید گواهی‌ها"

# تولید پروفایل‌های اتصال
echo "تولید پروفایل‌های اتصال..."
./generateConnectionProfiles.sh
check_error "تولید پروفایل‌های اتصال"

# تولید قراردادها
echo "تولید قراردادها..."
./generateChaincodes.sh
check_error "تولید قراردادها"

# تولید فایل‌های workload
echo "تولید فایل‌های workload..."
./generateWorkloadFiles.sh
check_error "تولید فایل‌های workload"

# تنظیم مسیر Fabric
export FABRIC_CFG_PATH=$PWD
check_error "تنظیم FABRIC_CFG_PATH"

# تولید بلاک جنسیس و آرتیفکت‌های کانال
echo "تولید بلاک جنسیس و آرتیفکت‌های کانال..."
configtxgen -profile GeneralChannel -outputBlock ./channel-artifacts/genesis.block -channelID system-channel
check_error "تولید بلاک جنسیس"
configtxgen -profile GeneralChannel -outputCreateChannelTx ./channel-artifacts/generalchannel.tx -channelID generalchannelapp
check_error "تولید GeneralChannel"
configtxgen -profile IoTChannel -outputCreateChannelTx ./channel-artifacts/iotchannel.tx -channelID iotchannelapp
check_error "تولید IoTChannel"
configtxgen -profile SecurityChannel -outputCreateChannelTx ./channel-artifacts/securitychannel.tx -channelID securitychannelapp
check_error "تولید SecurityChannel"
configtxgen -profile MonitoringChannel -outputCreateChannelTx ./channel-artifacts/monitoringchannel.tx -channelID monitoringchannelapp
check_error "تولید MonitoringChannel"
for i in {1..10}; do
    configtxgen -profile Org${i}Channel -outputCreateChannelTx ./channel-artifacts/org${i}channel.tx -channelID org${i}channelapp
    check_error "تولید Org${i}Channel"
done

# بررسی تولید آرتیفکت‌ها
echo "آرتیفکت‌های تولیدشده:"
ls -l ./channel-artifacts/
check_error "بررسی آرتیفکت‌های کانال"

echo "راه‌اندازی شبکه با موفقیت انجام شد!"
