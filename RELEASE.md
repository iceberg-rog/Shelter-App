# انتشار نسخهٔ جدید

## یک‌بار: اتصال مخزن

```powershell
cd "$env:USERPROFILE\Desktop\Shelter-App"
git push -u origin main
```

## ساخت Release و آپلود فایل

### راه اول — رابط وب (بدون ابزار اضافه)

1. برو به <https://github.com/iceberg-rog/Shelter-App/releases/new>
2. Choose a tag → بنویس `v1.0.0` → **Create new tag: v1.0.0 on publish**
3. Target: `main`
4. Release title: `Shelter 1.0.0`
5. فایل `Shelter-1.0.0.msi` را از پوشهٔ `Desktop\Shelter-App` بکش داخل کادر Attach binaries
6. Publish release

### راه دوم — GitHub CLI

```powershell
cd "$env:USERPROFILE\Desktop\Shelter-App"
gh release create v1.0.0 Shelter-1.0.0.msi SHA256SUMS.txt `
  --repo iceberg-rog/Shelter-App `
  --title "Shelter 1.0.0" `
  --notes-file RELEASE_NOTES.md
```

## لینک مستقیم دانلود

بعد از انتشار، این آدرس فعال می‌شود — همین را در فیلد Package URL پارتنر سنتر بگذار:

```
https://github.com/iceberg-rog/Shelter-App/releases/download/v1.0.0/Shelter-1.0.0.msi
```

بررسی کن که واقعاً کار می‌کند و اندازه‌اش `12783616` بایت است:

```powershell
$u = "https://github.com/iceberg-rog/Shelter-App/releases/download/v1.0.0/Shelter-1.0.0.msi"
(Invoke-WebRequest -Uri $u -Method Head).Headers
```

## برای نسخه‌های بعدی

فایل پشت این آدرس هرگز نباید عوض شود. برای `1.0.1` یک تگ تازه (`v1.0.1`) بساز و
آدرس جدید را به پارتنر سنتر بده.
