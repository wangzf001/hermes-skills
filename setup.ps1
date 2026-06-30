# ============================================
#  Hermes AI 系统 · Windows 一键部署脚本
# ============================================
# 用法：powershell -ExecutionPolicy Bypass -File setup.ps1

Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Hermes AI 系统 · Windows 部署    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$HERMES_HOME = "$env:USERPROFILE\.hermes"
$SKILLS_REPO = "https://github.com/wangzf001/hermes-skills.git"
$DOCUMENTS = [Environment]::GetFolderPath("MyDocuments")

# Step 1: Hermes
Write-Host "📦 [1/6] 检查 Hermes..." -ForegroundColor Yellow
$hermesCmd = Get-Command hermes -ErrorAction SilentlyContinue
if (-not $hermesCmd) {
    Write-Host "  Hermes 未安装，请先下载安装:" -ForegroundColor Red
    Write-Host "  https://hermes-agent.nousresearch.com/docs/"
    Read-Host "  按回车退出"
    exit
}
Write-Host "  ✅ Hermes 已安装" -ForegroundColor Green

# Step 2: 克隆技能
Write-Host ""
Write-Host "📦 [2/6] 克隆 AI 技能包..." -ForegroundColor Yellow
$SKILLS_DIR = "$DOCUMENTS\hermes-skills-repo"
if (Test-Path $SKILLS_DIR) {
    Write-Host "  技能包已存在，更新中..."
    Set-Location $SKILLS_DIR
    git pull
} else {
    git clone $SKILLS_REPO $SKILLS_DIR
}
Write-Host "  ✅ 技能包就绪" -ForegroundColor Green

Write-Host "  安装技能到 Hermes..."
New-Item -ItemType Directory -Force -Path "$HERMES_HOME\skills" | Out-Null
Copy-Item -Recurse -Force "$SKILLS_DIR\skills\*" "$HERMES_HOME\skills\"
Copy-Item -Recurse -Force "$SKILLS_DIR\framework\*" "$HERMES_HOME\skills\" -ErrorAction SilentlyContinue
Write-Host "  ✅ 技能安装完成" -ForegroundColor Green

# Step 3: DeepSeek
Write-Host ""
Write-Host "📦 [3/6] 配置 DeepSeek Pro..." -ForegroundColor Yellow
$envFile = "$HERMES_HOME\.env"
$hasKey = $false
if (Test-Path $envFile) {
    $hasKey = Select-String -Path $envFile -Pattern "DEEPSEEK_API_KEY" -Quiet
}
if (-not $hasKey) {
    Write-Host "  获取 Key: https://platform.deepseek.com/api_keys"
    $apiKey = Read-Host "  请输入 DeepSeek API Key"
    "DEEPSEEK_API_KEY=$apiKey" | Out-File -Append -FilePath $envFile -Encoding UTF8
    Write-Host "  ✅ API Key 已保存" -ForegroundColor Green
} else {
    Write-Host "  ✅ DeepSeek API Key 已配置" -ForegroundColor Green
}
hermes config set model.default deepseek-v4-pro 2>$null
hermes config set model.provider deepseek 2>$null
Write-Host "  ✅ DeepSeek Pro 配置完成" -ForegroundColor Green

# Step 4: 微信（跳过）
Write-Host ""
Write-Host "📦 [4/6] 微信连接 — 跳过" -ForegroundColor Yellow
Write-Host "  由你控制。需要时执行: hermes gateway setup"

# Step 5: 知识库
Write-Host ""
Write-Host "📦 [5/6] 创建知识库..." -ForegroundColor Yellow
$KB_DIR = "$DOCUMENTS\obsidian_projects\知识体系库"
New-Item -ItemType Directory -Force -Path "$KB_DIR\wiki" | Out-Null
New-Item -ItemType Directory -Force -Path "$KB_DIR\raw" | Out-Null

$claudeMd = "# 知识库规则`n## 核心操作`n- Ingest: 摄入 raw/ → wiki/`n- Query: 搜索 wiki/`n- Lint: 检查矛盾/孤立/过时`n`n## 边界`n① AI技术实战 ② 产业财经 ③ 自媒体`n`n## 标准`n三个月后回看还有价值吗？"
$claudeMd | Out-File -FilePath "$KB_DIR\CLAUDE.md" -Encoding UTF8

$indexMd = "# 知识条目索引`n> AI 自动维护"
$indexMd | Out-File -FilePath "$KB_DIR\wiki\index.md" -Encoding UTF8

Write-Host "  ✅ 知识库创建完成" -ForegroundColor Green
Write-Host "  Obsidian: https://obsidian.md"

# Step 6: 完成
Write-Host ""
Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   🎉 部署完成！                    ║" -ForegroundColor Cyan
Write-Host "║   试试: 基金经理，展示能力          ║" -ForegroundColor White
Write-Host "║   💡 用语音沟通，不打字           ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
Read-Host "按回车退出"
