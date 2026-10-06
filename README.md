# Shelter

کلاینت ویندوزی برای کاهش پینگ و پایدارکردن ترافیک بازی.

نسخهٔ فعلی: **1.0.0** — فقط **Windows x64**، حداقل **Windows 10**.

## مستندات فنی

[مستندات فنی DNSهای رفع تحریم و کاهش پینگ (PDF)](docs/Shelter-DNS-Ping-Technical-Guide.pdf) —
سازوکار DNS رفع تحریم، اصول کاهش پینگ، معماری Shelter، نصب و عیب‌یابی.
منبع سند در `docs/technical-guide` است و با `docs/technical-guide/build.sh` ساخته می‌شود.

## دانلود

آخرین نصب‌کننده از بخش [Releases](../../releases/latest) — فایل `Shelter-1.0.0.msi`.

بعد از دانلود، درستی فایل را بررسی کنید:

```powershell
Get-FileHash .\Shelter-1.0.0.msi -Algorithm SHA256
```

باید برابر باشد با:

```
a2a6487e71ba7b5b366b03440d482c46a62003abcb0e269e2d2701037ceadd83
```

## نصب

نصب معمولی: روی فایل `.msi` دوبار کلیک کنید.

نصب بی‌صدا (بدون هیچ پنجره‌ای):

```powershell
msiexec /i Shelter-1.0.0.msi /qn /norestart
```

برنامه در `C:\Program Files\Shelter` نصب می‌شود و میان‌بر در Start Menu و دسکتاپ می‌سازد.

## حذف

```powershell
msiexec /x Shelter-1.0.0.msi /qn /norestart
```

یا با کد محصول:

```powershell
msiexec /x {C1233F58-F2F3-44F6-96BF-981111C60865} /qn /norestart
```

## به‌روزرسانی

نصب‌کنندهٔ نسخهٔ جدید را مستقیم اجرا کنید. نسخهٔ قبلی خودکار حذف می‌شود و در
Programs & Features فقط یک رکورد Shelter می‌ماند. نیازی به حذف دستی نیست.

## چه چیزی روی سیستم نصب می‌شود

- برنامه و موتور تونل در `C:\Program Files\Shelter`
- درایور شبکهٔ **Wintun** (نسخهٔ 0.14.1، ساخت WireGuard LLC) برای ساخت آداپتور مجازی
- یک **سرویس ویندوز** که تونل را مدیریت می‌کند
- قواعد Windows Filtering Platform برای هدایت ترافیک

به همین دلیل برنامه هنگام اجرا دسترسی Administrator می‌خواهد. موقع حذف، نصب‌کننده
سرویس را متوقف و پاک می‌کند.

## هشدار SmartScreen

نصب‌کنندهٔ این نسخه هنوز امضای دیجیتال ندارد، بنابراین ویندوز موقع اجرا اخطار
SmartScreen نشان می‌دهد. تا زمانی که گواهی code signing اضافه شود این اخطار باقی می‌ماند.
همیشه فایل را فقط از همین صفحهٔ Releases بگیرید و SHA-256 بالا را بررسی کنید.
