# DenysGranevych: Поясни мені цей скрипт, що робить кожен оператор, я майже не знаю повершшел

GitHub Copilot: Я поясню скрипт покроково:

### 1. Коментарі та параметри
```powershell
<#
    Це блок коментарів, який пояснює призначення скрипта
    та як його запускати
#>

param(
    [switch]$Force  # Параметр, який можна передати при запуску скрипта
)
```
- `param()` визначає параметри скрипта
- `[switch]$Force` - це спеціальний тип параметра, який працює як прапорець (так/ні)

### 2. Логування початку роботи
```powershell
$startTime = Get-Date  # Зберігає поточний час
Write-Host "=== Cleanup build artifacts started ==="  # Виводить текст в консоль
Write-Host "Start time: $startTime`n"  # `n додає новий рядок
```

### 3. Пошук папок
```powershell
$foldersToDelete = Get-ChildItem -Path . -Directory -Recurse |
    Where-Object {
        ($_.Name -in "bin","obj") -and (-not ($_.FullName -like "*\.git*"))
    }
```
- `Get-ChildItem` - шукає файли та папки
- `-Path .` - шукає в поточній директорії
- `-Directory` - шукає тільки папки
- `-Recurse` - шукає у всіх підпапках
- `Where-Object` - фільтрує результати
- `$_.Name -in "bin","obj"` - вибирає папки з назвою "bin" або "obj"
- `-not ($_.FullName -like "*.git*")` - виключає папки всередині .git

### 4. Перевірка результатів
```powershell
if ($foldersToDelete.Count -eq 0) {
    Write-Host "No folders to delete."
} else {
    Write-Host "Folders to be deleted:"
    $foldersToDelete | ForEach-Object { Write-Host $_.FullName }
```
- Перевіряє, чи знайдено папки
- Виводить список знайдених папок

### 5. Логіка видалення
```powershell
$delete = $false

if ($Force) {
    $delete = $true
    Write-Host "`nForce switch detected. Deleting without confirmation..."
} else {
    $confirmation = Read-Host "`nDo you want to delete these folders? (Y/N)"
    if ($confirmation -match "^[Yy]$") {
        $delete = $true
    }
}
```
- Перевіряє, чи вказано параметр `-Force`
- Якщо ні, запитує підтвердження у користувача
- `Read-Host` - очікує введення від користувача
- `-match "^[Yy]$"` - перевіряє, чи введено "Y" або "y"

### 6. Видалення папок
```powershell
if ($delete) {
    foreach ($folder in $foldersToDelete) {
        Write-Host "Deleting: $($folder.FullName)"
        Remove-Item $folder.FullName -Recurse -Force
    }
}
```
- Якщо отримано дозвіл, видаляє кожну папку
- `Remove-Item` - видаляє файл або папку
- `-Recurse` - видаляє вміст папок
- `-Force` - примусове видалення

### 7. Завершення роботи
```powershell
$endTime = Get-Date
Write-Host "`n=== Cleanup build artifacts finished ==="
Write-Host "End time: $endTime"
```
- Зберігає час завершення
- Виводить фінальне повідомлення

Цей скрипт використовується для очищення тимчасових файлів збірки (.NET проекту), які знаходяться в папках bin та obj. Він може працювати в двох режимах:
1. Звичайний режим - показує список папок і запитує підтвердження
2. Примусовий режим (з параметром `-Force`) - видаляє папки без підтвердження
