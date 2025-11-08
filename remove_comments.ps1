Write-Host "🧹 Removing all // comments (full-line + inline) from Dart files..."

# يبحث عن كل الملفات .dart في كل المجلدات
Get-ChildItem -Path . -Recurse -Include *.dart | ForEach-Object {
    $file = $_.FullName
    $content = Get-Content $file -Raw

    # استخدم Regex لحذف كل شيء بعد //
    # (?<!:) يعني لا يحذف الروابط مثل https://
    $cleaned = [regex]::Replace($content, '(?<!:)//.*', '')

    # احفظ التعديلات مكان الملف
    Set-Content -Path $file -Value $cleaned -Encoding UTF8
    Write-Host "Cleaned: $file"
}

Write-Host "✅ All Dart files cleaned successfully!"
