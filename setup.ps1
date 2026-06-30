# ============================================
#  Hermes AI 系统 · Windows 一键部署脚本
#  安装Hermes + 克隆技能 + DeepSeek + 微信 + 知识库
# ============================================
# 用法：右键 → 使用 PowerShell 运行
# 或者：powershell -ExecutionPolicy Bypass -File setup.ps1

Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Hermes AI 系统 · Windows 部署    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$HERMES_HOME = "$env:USERPROFILE\.hermes"
$SKILLS_REPO = "https://github.com/wangzf001/hermes-skills.git"
$DOCUMENTS = [Environment]::GetFolderPath("MyDocuments")

# ── Step 1: 安装 Hermes Agent ──
Write-Host "📦 [1/6] 安装 Hermes Agent..." -ForegroundColor Yellow
$hermesCmd = Get-Command hermes -ErrorAction SilentlyContinue
if ($hermesCmd) {
    Write-Host "  ✅ Hermes 已安装" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Hermes 未安装" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  安装步骤：" -ForegroundColor White
    Write-Host "  1. 打开浏览器访问: https://hermes-agent.nousresearch.com/docs/"
    Write-Host "  2. 下载 Windows 安装包"
    Write-Host "  3. 运行安装程序"
    Write-Host "  4. 安装完成后重新运行本脚本"
    Write-Host ""
    Read-Host "  按回车退出"
    exit
}

# ── Step 2: 克隆技能包 ──
Write-Host ""
Write-Host "📦 [2/6] 克隆 AI 技能包..." -ForegroundColor Yellow
$SKILLS_DIR = "$DOCUMENTS\hermes-skills-repo"
if (Test-Path $SKILLS_DIR) {
    Write-Host "  ✅ 技能包已存在，更新中..." -ForegroundColor Green
    Set-Location $SKILLS_DIR
    git pull
} else {
    git clone $SKILLS_REPO $SKILLS_DIR
    Write-Host "  ✅ 技能包克隆完成" -ForegroundColor Green
}

Write-Host "  安装技能到 Hermes..." -ForegroundColor White
New-Item -ItemType Directory -Force -Path "$HERMES_HOME\skills" | Out-Null
Copy-Item -Recurse -Force "$SKILLS_DIR\skills\*" "$HERMES_HOME\skills\"
Copy-Item -Recurse -Force "$SKILLS_DIR\framework\*" "$HERMES_HOME\skills\" -ErrorAction SilentlyContinue
Write-Host "  ✅ 技能安装完成" -ForegroundColor Green

# ── Step 3: 配置 DeepSeek Pro ──
Write-Host ""
Write-Host "📦 [3/6] 配置 DeepSeek Pro..." -ForegroundColor Yellow
$envFile = "$HERMES_HOME\.env"
if (Test-Path $envFile) {
    $hasKey = Select-String -Path $envFile -Pattern "DEEPSEEK_API_KEY" -Quiet
    if ($hasKey) {
        Write-Host "  ✅ DeepSeek API Key 已配置" -ForegroundColor Green
    }
} else {
    Write-Host "  ⚠️  需要 DeepSeek API Key" -ForegroundColor Yellow
    Write-Host "  获取地址: https://platform.deepseek.com/api_keys" -ForegroundColor White
    $apiKey = Read-Host "  请输入 DeepSeek API Key"
    "DEEPSEEK_API_KEY=$apiKey" | Out-File -Append -FilePath $envFile -Encoding UTF8
    Write-Host "  ✅ API Key 已保存" -ForegroundColor Green
}

Write-Host "  设置默认模型为 deepseek-v4-pro..." -ForegroundColor White
hermes config set model.default deepseek-v4-pro 2>$null
hermes config set model.provider deepseek 2>$null
Write-Host "  ✅ DeepSeek Pro 配置完成" -ForegroundColor Green

# Step 4: 微信（跳过，你自己控制）
Write-Host ""
Write-Host "📦 [4/6] 微信连接 — 跳过" -ForegroundColor Yellow
Write-Host "  由你决定何时连接。需要时在 Hermes 中执行:" -ForegroundColor White
Write-Host "    hermes gateway setup" -ForegroundColor Cyan
Write-Host "  选择 Weixin，扫码即可。" -ForegroundColor White

# ── Step 5: 创建知识库 ──
Write-Host ""
Write-Host "📦 [5/6] 创建知识库目录..." -ForegroundColor Yellow
$KB_DIR = "$DOCUMENTS\obsidian_projects\知识体系库"
New-Item -ItemType Directory -Force -Path "$KB_DIR\wiki" | Out-Null
New-Item -ItemType Directory -Force -Path "$KB_DIR\raw" | Out-Null

@"
# 知识库规则
## 核心操作
- Ingest: 摄入 raw/ 素材 → 更新 wiki/
- Query: 搜索 wiki/ 综合回答
- Lint: 检查矛盾/孤立/过时

## 知识库边界
① AI技术实战 ② 产业财经研究 ③ 自媒体实操

## 可复用标准
三个月后回看还有价值吗？
"@ | Out-File -FilePath "$KB_DIR\CLAUDE.md" -Encoding UTF8

@"
# 知识条目索引
> 由 AI 自动维护
"@ | Out-File -FilePath "$KB_DIR\wiki\index.md" -Encoding UTF8

Write-Host "  ✅ 知识库创建完成" -ForegroundColor Green
Write-Host "  用 Obsidian 打开: $KB_DIR" -ForegroundColor White
Write-Host "  Obsidian 下载: https://obsidian.md" -ForegroundColor White

# ── Step 6: 验证 ──
Write-Host ""
Write-Host "📦 [6/6] 验证部署..." -ForegroundColor Yellow

Write-Host ""
Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   🎉 部署完成！                    ║" -ForegroundColor Cyan
Write-Host "║                                    ║"
Write-Host "║   试试这些命令:                     ║" -ForegroundColor White
Write-Host "║   · 基金经理，展示能力              ║" -ForegroundColor White
Write-Host "║   · 生成今日盘前报告               ║" -ForegroundColor White
Write-Host "║   · 来条财经口播文案               ║" -ForegroundColor White
Write-Host "║                                    ║" -ForegroundColor White
Write-Host "║   💡 建议：用语音沟通，不打字     ║" -ForegroundColor Green
Write-Host "║   Windows终端支持语音输入         ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan

Read-Host "按回车退出"
