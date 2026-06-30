# Hermes AI 系统 · 人工搭建指南

## 前置准备

- Hermes Agent（[下载](https://hermes-agent.nousresearch.com/docs/)）
- Git（[下载](https://git-scm.com/download)）
- DeepSeek API Key（[获取](https://platform.deepseek.com/api_keys)）
- Obsidian（[下载](https://obsidian.md)，可选）

---

## macOS

### 1. 安装 Hermes

```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

### 2. 克隆技能包

```bash
git clone https://github.com/wangzf001/hermes-skills.git ~/Documents/hermes-skills-repo
```

### 3. 安装技能

```bash
mkdir -p ~/.hermes/skills
cp -r ~/Documents/hermes-skills-repo/skills/* ~/.hermes/skills/
```

### 4. 配置 DeepSeek

```bash
echo "DEEPSEEK_API_KEY=你的Key" >> ~/.hermes/.env
hermes config set model.default deepseek-v4-pro
hermes config set model.provider deepseek
```

### 5. 创建知识库目录

```bash
mkdir -p ~/Documents/obsidian_projects/知识体系库/wiki
mkdir -p ~/Documents/obsidian_projects/知识体系库/raw
```

### 6. 测试

```bash
hermes
# 输入: 基金经理，展示能力
```

### 7. （可选）连接微信

```bash
hermes gateway setup
# 选择 Weixin，扫码
```

---

## Windows

### 1. 安装 Hermes

浏览器访问 https://hermes-agent.nousresearch.com/docs/ ，下载 Windows 安装包并安装。

### 2. 克隆技能包

```powershell
git clone https://github.com/wangzf001/hermes-skills.git $env:USERPROFILE\Documents\hermes-skills-repo
```

### 3. 安装技能

```powershell
New-Item -ItemType Directory -Force -Path $env:USERPROFILE\.hermes\skills
Copy-Item -Recurse -Force $env:USERPROFILE\Documents\hermes-skills-repo\skills\* $env:USERPROFILE\.hermes\skills\
```

### 4. 配置 DeepSeek

```powershell
"DEEPSEEK_API_KEY=你的Key" | Out-File -Append -FilePath $env:USERPROFILE\.hermes\.env -Encoding UTF8
hermes config set model.default deepseek-v4-pro
hermes config set model.provider deepseek
```

### 5. 创建知识库目录

```powershell
New-Item -ItemType Directory -Force -Path $env:USERPROFILE\Documents\obsidian_projects\wiki
New-Item -ItemType Directory -Force -Path $env:USERPROFILE\Documents\obsidian_projects\raw
```

用 Obsidian 打开 `Documents\obsidian_projects` 目录。

### 6. 测试

```powershell
hermes
# 输入: 基金经理，展示能力
```

### 7. （可选）连接微信

```powershell
hermes gateway setup
# 选择 Weixin，扫码
```

---

## 验证清单

- [ ] `hermes` 能启动
- [ ] 输入「基金经理，展示能力」有回复
- [ ] Obsidian 能打开知识库目录
- [ ] 微信连接（可选）

> 💡 **日常使用建议：用语音沟通，不需要打字。**
