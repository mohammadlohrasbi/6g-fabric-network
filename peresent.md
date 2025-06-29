# ارائه پروژه شبکه بلاکچین 6G با Hyperledger Fabric

## اسلاید 1: مقدمه
- **هدف**: شبکه بلاکچین برای کاربردهای 6G.
- **اهمیت**: پشتیبانی از میلیاردها دستگاه IoT، تأخیر کم، امنیت بالا.
- **ویژگی‌ها**:
  - 10 سازمان، 14 کانال، 70 چین‌کد.
  - کاهش 20-30% مصرف دیسک (12GB به 8-10GB).
  - تست با Caliper و Tape.

## اسلاید 2: معماری شبکه
- **اجزا**:
  - 10 سازمان، 1 Orderer، 11 سرویس CA.
  - 14 کانال برای جداسازی تراکنش‌ها.
- **تصویر**: نمودار شبکه مربع (Mermaid, 800x800 پیکسل).
  - کد: [network_diagram.mmd](#4ff49853-1c14-47a4-98f3-c822b40e481c).
  - دستور: کد را در [mermaid.live](https://mermaid.live) با بوم 800x800 اجرا کنید.
- **شرح**: شبکه مقیاس‌پذیر با چیدمان مربع و تم سبز.

## اسلاید 3: دایرکتوری‌ها و فایل‌ها
- **`crypto-config/`**: گواهی‌های MSP و TLS.
- **`channel-artifacts/`**: بلاک جنسیس و فایل‌های تراکنش.
- **`chaincode/`**: 70 چین‌کد.
- **`caliper/`**, **`tape/`**, **`workload/`**: ابزارهای تست.
- **`config/`**, **`production/`**: تنظیمات و لجرها.

## اسلاید 4: کانال‌های عمومی
- **کانال‌ها**:
  - `generalchannelapp`: تراکنش‌های مشترک.
  - `iotchannelapp`: مدیریت IoT.
  - `securitychannelapp`: سیاست‌های امنیتی.
  - `monitoringchannelapp`: نظارت بر عملکرد.
- **تصویر**: نمودار کانال‌ها مربع (Mermaid, 800x800 پیکسل).
  - کد: [channels_diagram.mmd](#2e8ca050-b5fe-4b3b-9aa0-a0e1b20a7c6d).
  - دستور: تصویر را از [mermaid.live](https://mermaid.live) دانلود کنید.

## اسلاید 5: کانال‌های سازمانی
- **کانال‌ها**: `org1channelapp` تا `org10channelapp`.
- **وظیفه**: تراکنش‌های داخلی سازمان.
- **تصویر**: نمودار کانال‌ها مربع (Mermaid, 800x800 پیکسل).
  - کد: [org_channels_diagram.mmd](#ced7b5f0-e340-4d4e-aa40-44d35b7d747c).
  - دستور: تصویر را از [mermaid.live](https://mermaid.live) دانلود کنید.
- **مثال**: `{ "org": "Org1", "action": "allocateInternalResource" }`.

## اسلاید 6: جدول چین‌کدها - مدیریت منابع
- **چین‌کدها**: `ResourceAllocate`, `BandwidthShare`, `ResourceScale`, ...
- **تصویر**: جدول مربع (HTML, 800x800 پیکسل).
  - کد: [chaincode_table_management.html](#82814ebf-7610-4ca8-ae1a-0b0cf441a95e).
  - دستور: کد HTML را در مرورگر اجرا کرده یا در [tablesgenerator.com](https://www.tablesgenerator.com/markdown_tables) به PNG تبدیل کنید.
- **مثال**: `{ "deviceID": "IoT123", "bandwidth": "10Mbps" }`.

## اسلاید 7: جدول چین‌کدها - بهینه‌سازی شبکه
- **چین‌کدها**: `DynamicRouting`, `LoadBalance`, `LatencyOptimize`, ...
- **تصویر**: جدول مربع (HTML, 800x800 پیکسل).
  - کد: [chaincode_table_network.html](#b7a2c4e1-9f2a-4e7b-8c3d-6f8e9a0b1c2d).
  - دستور: کد HTML را در مرورگر اجرا کرده یا به PNG تبدیل کنید.
- **مثال**: `{ "source": "deviceA", "path": ["node1", "node2"] }`.

## اسلاید 8: جدول چین‌کدها - امنیت (بخش 1)
- **چین‌کدها**: `UserAuth`, `DeviceAuth`, `AccessControl`, ...
- **تصویر**: جدول مربع (HTML, 800x800 پیکسل).
  - کد: [chaincode_table_security1.html](#d3e5f7a2-0b3c-4f8d-9e4a-7b9c0d1e2f3a).
  - دستور: کد HTML را در مرورگر اجرا کرده یا به PNG تبدیل کنید.
- **مثال**: `{ "deviceID": "IoT123", "status": "authenticated" }`.

## اسلاید 9: جدول چین‌کدها - امنیت (بخش 2)
- **چین‌کدها**: `IdentityVerify`, `SessionAuth`, `MultiFactorAuth`, ...
- **تصویر**: جدول مربع (HTML, 800x800 پیکسل).
  - کد: [chaincode_table_security2.html](#a4b6c8e3-1c4d-5f9e-0a5b-8c0d1e2f3a4b).
  - دستور: کد HTML را در مرورگر اجرا کرده یا به PNG تبدیل کنید.
- **مثال**: `{ "userID": "User1@org1", "action": "login" }`.

## اسلاید 10: جدول چین‌کدها - نظارت و تحلیل (بخش 1)
- **چین‌کدها**: `NetworkMonitor`, `PerformanceMonitor`, ...
- **تصویر**: جدول مربع (HTML, 800x800 پیکسل).
  - کد: [chaincode_table_monitoring1.html](#e5f7a9b4-2d5e-6f0a-1b6c-9d0e2f3a4b5c).
  - دستور: کد HTML را در مرورگر اجرا کرده یا به PNG تبدیل کنید.
- **مثال**: `{ "node": "peer0.org1", "traffic": "500Mbps" }`.

## اسلاید 11: جدول چین‌کدها - نظارت و تحلیل (بخش 2)
- **چین‌کدها**: `AlertMonitor`, `LogMonitor`, ...
- **تصویر**: جدول مربع (HTML, 800x800 پیکسل).
  - کد: [chaincode_table_monitoring2.html](#f6a8b0c5-3e6f-7a1b-2c7d-0e1f3a4b5c6d).
  - دستور: کد HTML را در مرورگر اجرا کرده یا به PNG تبدیل کنید.
- **مثال**: `{ "alertID": "alert123", "issue": "high latency" }`.

## اسلاید 12: جدول چین‌کدها - نظارت و تحلیل (بخش 3)
- **چین‌کدها**: `DataAnalytics`, `PerformanceAnalytics`, ...
- **تصویر**: جدول مربع (HTML, 800x800 پیکسل).
  - کد: [chaincode_table_monitoring3.html](#a7b9c1d6-4f7a-8b2c-3d8e-1f2a4b5c6d7e).
  - دستور: کد HTML را در مرورگر اجرا کرده یا به PNG تبدیل کنید.
- **مثال**: `{ "analysisID": "data123", "result": "traffic pattern" }`.

## اسلاید 13: جدول چین‌کدها - نظارت و تحلیل (بخش 4)
- **چین‌کدها**: `EventAnalytics`, `LogAnalytics`.
- **تصویر**: جدول مربع (HTML, 800x800 پیکسل).
  - کد: [chaincode_table_monitoring4.html](#b8c0d2e7-5a8b-9c3d-4e9f-2a3b5c6d7e8f).
  - دستور: کد HTML را در مرورگر اجرا کرده یا به PNG تبدیل کنید.
- **مثال**: `{ "logID": "log123", "issue": "connection error" }`.

## اسلاید 14: جدول چین‌کدها - حسابرسی
- **چین‌کدها**: `TransactionAudit`, `ComplianceAudit`, ...
- **تصویر**: جدول مربع (HTML, 800x800 پیکسل).
  - کد: [chaincode_table_audit.html](#c9d1e3f8-6b9c-0d4e-5f0a-3b4c6d7e8f9a).
  - دستور: کد HTML را در مرورگر اجرا کرده یا به PNG تبدیل کنید.
- **مثال**: `{ "txID": "abc123", "action": "allocateResource" }`.

## اسلاید 15: جدول چین‌کدها - تشخیص و نگهداری
- **چین‌کدها**: `FaultDetect`, `AnomalyDetect`, ...
- **تصویر**: جدول مربع (HTML, 800x800 پیکسل).
  - کد: [chaincode_table_detection.html](#d0e2f4a9-7c0d-1e5f-6a1b-4c5d7e8f9a0b).
  - دستور: کد HTML را در مرورگر اجرا کرده یا به PNG تبدیل کنید.
- **مثال**: `{ "node": "peer0.org1", "status": "anomaly detected" }`.

## اسلاید 16: جریان تراکنش‌ها
- **تصویر**: نمودار جریان مربع (Mermaid, 800x800 پیکسل).
  - کد: [transaction_flow.mmd](#7fe1dd59-fdbb-4824-a4b8-5cd7f4d7be67).
  - دستور: تصویر را از [mermaid.live](https://mermaid.live) دانلود کنید.
- **شرح**: تراکنش‌ها با فونت‌های بزرگ‌تر و تم آبی-نارنجی.

## اسلاید 17: نتایج تست عملکرد
- **تصویر**: نمودار میله‌ای مربع (Chart.js, 800x800 پیکسل).
  - کد: [performance_chart.html](#cb4a8d64-b95a-4bc7-9cba-8becced0c06d).
  - دستور: کد HTML را اجرا کرده یا در Excel نمودار تولید کنید.
- **شرح**: نرخ تراکنش و تأخیر با گرادیان رنگی.

## اسلاید 18: عیب‌یابی و بهینه‌سازی
- **خطای MSP**:
  - مشکل: عدم وجود دایرکتوری `/etc/hyperledger/fabric/users/Admin@org1.example.com/msp`.
  - رفع: بازتولید `crypto-config`, اصلاح `docker-compose.yaml`.
- **دستورات**:
  ```bash
  cryptogen generate --config=./crypto-config.yaml
  find crypto-config -type f -name "*.gz" -exec gunzip {} \;
  ```
- **بهینه‌سازی**: کاهش دیسک از 12GB به 8-10GB.

## اسلاید 19: نتیجه‌گیری
- **مزایا**:
  - مقیاس‌پذیری برای 6G.
  - امنیت و شفافیت.
  - بهینه‌سازی منابع.
- **برنامه‌های آینده**:
  - افزودن چین‌کدهای جدید.
  - بهبود تست‌ها.

## اسلاید 20: سوالات و بحث
- آماده پاسخ به سؤالات فنی و نمایش لاگ‌ها.

**زمان ارائه**: 2025-06-29 18:22 CEST
