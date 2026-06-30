# Hermes Skills · 完整 AI 团队系统

> 克隆即用的 AI 技能包。内含三层十人基金经理、自媒体团队、知识库系统。把你的 Hermes Agent 变成一个完整的 AI 公司。

---

## 快速开始

→ **[人工搭建指南 (SETUP.md)](SETUP.md)** — macOS / Windows 分步教程

> 💡 **AMD/Intel 都可以。** Hermes 只运行 Python 命令行工具，推理在云端。

部署完成后，在微信里对 Hermes 说「基金经理，展示能力」测试。

> 💡 **建议：日常用语音沟通，不需要打字。** 语音降低了使用门槛，提升了交互频率——这是搭建 AI 能力系统的实用技巧。

---

## 技能清单

### 🏦 基金经理系统（三层十人制）

| 技能 | 触发 | 功能 |
|------|------|------|
| `fund-manager-team` | "分析XX" / "打分" | 四层十二人团队：采集→分析→决策→反馈 |
| `stock-deep-analysis` | "深挖XX" | 12维深度框架 + 七因子打分 |
| `sector-analysis` | "分析XX板块" | 产业链地图 + 白毛魔女五维卡口 |
| `a-share-market-data` | 自动 | A股实时数据 API |
| `portfolio-management` | "调仓" / "审视" | 低频组合规则 |
| `pre-post-market-report` | "盘前报告" / "盘后" | 盘前盘后报告 + 预判闭环 |
| `ai-investment-system` | 自动 | 五层架构低频理财系统 |

### 🎬 自媒体系统

| 技能 | 触发 | 功能 |
|------|------|------|
| `content-supervisor` | "来条文案" / 每日 7:00 | 热点猎手→文案师→质检官→数据官 |
| `douyin-script-generator` | "生成口播" | 10铁律 + 8项质检 + 合规扫描 |
| `finance-content-workflow` | "财经分析" | 行情→叙事→口播 一站式 |
| `benchmark-discovery` | "找对标" | 抖音/B站/知乎 对标账号发现 |

### 📚 知识库系统

| 技能 | 触发 | 功能 |
|------|------|------|
| `knowledge-base-management` | 自动摄入 | Obsidian wiki + 双向链接 |
| `knowledge-base-lint` | 每日 8:00 | 条目完整性 + 死链 + 过时检查 |

### 🧬 通用框架

| 技能 | 用途 |
|------|------|
| `agentic-workflow-template` | 任何领域的 AI 团队搭建说明书 |

---

## 定时任务配置

```bash
# 每日 7:00 — 自媒体口播文案
hermes cron create "0 7 * * *" --skill content-supervisor --prompt "按轮换表生成今日口播文案"

# 每日 8:00 — 知识库巡检
hermes cron create "0 8 * * *" --skill knowledge-base-lint --prompt "执行知识库巡检"

# 工作日 15:30 — 持仓波动预警
hermes cron create "30 15 * * 1-5" --skill fund-manager-team --prompt "检查持仓波动，超阈值告警"

# 每月 1日+15日 9:00 — 因子打分
hermes cron create "0 9 1,15 * *" --skill fund-manager-team --prompt "运行七因子打分，输出持仓评估"
```

---

## 用户投资方法论

系统内置以下投资规则（自动在分析中引用）：

```
板块选择铁则（5条）
  1. 新兴但临近爆发 | 2. 快且持久 | 3. 可复制低成本
  4. 需求性强绕不开 | 5. 鱼身阶段（渗透率5-30%，CAGR≥30%）

选股新则（3条）
  1. 核心标的强者恒强 | 2. 市值200-500亿 | 3. 连续3季利润增长

加仓铁则
  只在下跌企稳处加仓——等市场确认底部，不接飞刀

操作纪律
  4-5只集中持仓 | 双周一审 | 月交易≤10次 | 现金≥20%
  止损-15% | 止盈+40%减半
```

---

## 相关仓库

- [agentic-workflow-template](https://github.com/wangzf001/agentic-workflow-template) — 通用团队搭建框架 v1.3
