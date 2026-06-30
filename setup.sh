#!/bin/bash
# ============================================
#  Hermes AI 系统 · 一键部署脚本
#  安装Hermes + 克隆技能 + 连接微信
# ============================================
set -e

echo "╔══════════════════════════════════════╗"
echo "║   Hermes AI 系统 · 一键部署        ║"
echo "╚══════════════════════════════════════╝"
echo ""

HERMES_HOME="${HOME}/.hermes"
SKILLS_REPO="https://github.com/wangzf001/hermes-skills.git"

# ── Step 1: 安装 Hermes Agent ──
echo "📦 [1/5] 安装 Hermes Agent..."
if command -v hermes &>/dev/null; then
    echo "  ✅ Hermes 已安装: $(hermes --version 2>/dev/null || echo 'ok')"
else
    echo "  ⚠️  请先安装 Hermes Agent: https://hermes-agent.nousresearch.com/docs"
    echo "  macOS: brew install nousresearch/hermes/hermes"
    echo "  或访问官网下载安装包"
    read -p "  安装完成后按回车继续..."
fi

# ── Step 2: 克隆技能包 ──
echo ""
echo "📦 [2/5] 克隆 AI 技能包..."
SKILLS_DIR="${HOME}/Documents/hermes-skills-repo"
if [ -d "$SKILLS_DIR" ]; then
    echo "  ✅ 技能包已存在，更新中..."
    cd "$SKILLS_DIR" && git pull
else
    git clone "$SKILLS_REPO" "$SKILLS_DIR"
    echo "  ✅ 技能包克隆完成"
fi

echo "  安装技能到 Hermes..."
mkdir -p "${HERMES_HOME}/skills"
cp -r "${SKILLS_DIR}/skills/"* "${HERMES_HOME}/skills/" 2>/dev/null || true
cp -r "${SKILLS_DIR}/framework/"* "${HERMES_HOME}/skills/" 2>/dev/null || true
echo "  ✅ 技能安装完成"

# ── Step 3: 配置微信连接 ──
echo ""
echo "📦 [3/5] 配置微信连接..."
echo "  在 Hermes 中执行: hermes setup weixin"
echo "  扫码后即可在微信中使用 Hermes"
echo ""
read -p "  是否现在启动微信配置？(y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    hermes setup weixin 2>/dev/null || echo "  ⚠️ 请手动执行: hermes setup weixin"
fi

# ── Step 4: 创建知识库目录 ──
echo ""
echo "📦 [4/5] 创建知识库目录..."
KB_DIR="${HOME}/Documents/obsidian_projects/知识体系库"
mkdir -p "${KB_DIR}/wiki" "${KB_DIR}/raw" "${KB_DIR}/.obsidian"

# 创建 CLAUDE.md
cat > "${KB_DIR}/CLAUDE.md" << 'EOF'
# 知识库规则
## 核心操作
- Ingest: 摄入 raw/ 素材 → 更新 wiki/
- Query: 搜索 wiki/ 综合回答
- Lint: 检查矛盾/孤立/过时

## 知识库边界
① AI技术实战 ② 产业财经研究 ③ 自媒体实操

## 可复用标准
三个月后回看还有价值吗？
EOF

# 创建 index.md
cat > "${KB_DIR}/wiki/index.md" << 'EOF'
# 知识条目索引
> 由 AI 自动维护
EOF

echo "  ✅ 知识库目录创建完成"
echo "  用 Obsidian 打开: ${KB_DIR}"

# ── Step 5: 验证 ──
echo ""
echo "📦 [5/5] 验证部署..."
echo ""
echo "  技能列表:"
ls "${HERMES_HOME}/skills/"*/SKILL.md 2>/dev/null | while read f; do
    name=$(head -5 "$f" | grep "name:" | sed 's/name: //')
    echo "    ✅ $name"
done

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   🎉 部署完成！                    ║"
echo "║                                    ║"
echo "║   试试这些命令:                     ║"
echo "║   • 基金经理，展示能力              ║"
echo "║   • 生成今日盘前报告               ║"
echo "║   • 来条财经口播文案               ║"
echo "║                                    ║"
echo "║   💡 建议：用语音沟通，不打字     ║"
echo "╚══════════════════════════════════════╝"
