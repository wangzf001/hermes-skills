# Hermes AI System - Windows Setup
# Run: powershell -ExecutionPolicy Bypass -File setup.ps1

Write-Host "=== Hermes AI Setup ===" -ForegroundColor Cyan

$HOME_DIR = $env:USERPROFILE
$DOCS = [Environment]::GetFolderPath("MyDocuments")

# Step 1
Write-Host "[1/5] Check Hermes..." -ForegroundColor Yellow
$ok = Get-Command hermes -ErrorAction SilentlyContinue
if (-not $ok) {
    Write-Host "Install Hermes first: https://hermes-agent.nousresearch.com/docs/"
    Read-Host "Press Enter to exit"
    exit
}
Write-Host "  OK" -ForegroundColor Green

# Step 2
Write-Host "[2/5] Clone skills..." -ForegroundColor Yellow
$dir = Join-Path $DOCS "hermes-skills-repo"
if (-not (Test-Path $dir)) {
    git clone https://github.com/wangzf001/hermes-skills.git $dir
}
Write-Host "  OK" -ForegroundColor Green

Write-Host "  Copy skills..."
$skillDest = Join-Path $HOME_DIR ".hermes\skills"
New-Item -ItemType Directory -Force -Path $skillDest | Out-Null
Copy-Item -Recurse -Force (Join-Path $dir "skills\*") $skillDest
Write-Host "  OK" -ForegroundColor Green

# Step 3
Write-Host "[3/5] DeepSeek..." -ForegroundColor Yellow
$envFile = Join-Path $HOME_DIR ".hermes\.env"
$hasKey = $false
if (Test-Path $envFile) {
    $content = Get-Content $envFile -Raw
    $hasKey = $content -match "DEEPSEEK_API_KEY"
}
if (-not $hasKey) {
    Write-Host "  Get key: https://platform.deepseek.com/api_keys"
    $key = Read-Host "  Paste API Key"
    $line = "DEEPSEEK_API_KEY=" + $key
    Add-Content -Path $envFile -Value $line -Encoding UTF8
}
hermes config set model.default deepseek-v4-pro 2>$null
hermes config set model.provider deepseek 2>$null
Write-Host "  OK" -ForegroundColor Green

# Step 4
Write-Host "[4/5] WeChat - skipped (your control)" -ForegroundColor Yellow
Write-Host "  When ready: hermes gateway setup"

# Step 5
Write-Host "[5/5] Create knowledge base dirs..." -ForegroundColor Yellow
$kb = Join-Path $DOCS "obsidian_projects"
$kbWiki = Join-Path $kb "wiki"
$kbRaw = Join-Path $kb "raw"
New-Item -ItemType Directory -Force -Path $kbWiki | Out-Null
New-Item -ItemType Directory -Force -Path $kbRaw | Out-Null
Write-Host "  OK" -ForegroundColor Green
Write-Host "  Open in Obsidian: $kb"

Write-Host ""
Write-Host "=== DONE ===" -ForegroundColor Cyan
Write-Host "Try: fund manager, show your abilities"
Write-Host "Tip: use voice, no typing needed"
Read-Host "Press Enter"
