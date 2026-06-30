---
name: finance-content-workflow
description: Scan A-share market + hot news, extract core narrative, generate Douyin oral scripts in 邻家财经大哥 style. Covers market data APIs, script generation rules, and compliance checks.
version: 1.0.0
platforms: [macos, linux]
metadata:
  hermes:
    tags: [finance, A股, douyin, script, content, market]
---

# Finance Market → Douyin Script Workflow

End-to-end pipeline: pull A-share market data → extract the core market narrative → generate a Douyin-optimized oral script.

## Trigger conditions
- User asks to "find today's finance hot topics"
- "analyze market and generate douyin script"
- "生成抖音口播" / "财经分析"
- Any request combining market data + content creation

## Step 1: Pull Market Data

### A-share indices (Sina Finance API — reliable)
```bash
curl -s "https://hq.sinajs.cn/list=sh000001,sz399001,sz399006,sh000688" \
  -H "Referer: https://finance.sina.com.cn"
```
Parses to: name, open, prev_close, price, high, low, volume, amount, date, time.

### Stock-level data (EastMoney push2 API)
```
https://push2.eastmoney.com/api/qt/stock/get?secid=0.{code}&fields=f43,f170,f20,f162,f167,f48,f168,f50,f51,f52,f57,f58
```
Key fields: f43=price/100, f170=change%/100, f20=market_cap/1e8, f162=PE/100, f167=PB/100, f48=turnover

### Sector ranking (EastMoney sector list)
```
https://push2.eastmoney.com/api/qt/clist/get?fid=f3&po=1&pz=10&pn=1&fs=m:90+t2&fields=f2,f3,f4,f12,f14
```
po=1 for top gainers, po=0 for top losers.

### Note on web scraping
- eastmoney.com pages are dynamic (JS-rendered) — prefer API endpoints, not HTML scraping
- Sina Finance API requires `Referer` header to avoid 403
- macOS `grep` lacks `-P` (Perl regex); use Python `re` instead

## Step 2: Extract Core Narrative

From the data, identify:
1. **The day's dominant move** — broad rally? rotation? selloff? Who led, who lagged?
2. **The headline number** — the single most impactful stat (e.g. "创业板 -4.07%", "4000点险守")
3. **The contradiction** — what looks counterintuitive? (e.g. "放量下跌 but 4000点有人接")

## Step 3: Generate Douyin Script

### Style: 邻家财经大哥 (Neighborhood Finance Big Brother)
- Oral to the extreme — like chatting with a friend on WeChat
- Let the data/logic speak; don't posture as "I'm telling you"
- Calm but firm; when bearish, use "需要留意的是" not "我不碰"/"不值得"
- Short sentences, one sentence per breath

### The 10 Style Rules (附对比示例)

核心公式：**钩子开场 + 简单逻辑链(≤3环) + 对比建立认知 + 数据随口说 + 温和收尾**

| # | 铁律 | ❌ 不可以 | ✅ 可以 |
|:--:|------|------|------|
| 1 | **钩子开场** | "今天跟大家聊聊稀土" | "半导体最关键的环节，不再是光刻机，而是封装" |
| 2 | **口语化极致** | "价格出现环比上行" | "涨了大概50%到80%左右" |
| 3 | **让逻辑说话** | "我判断""我不碰""我建议" | "市场在炒它三个逻辑""需要留意的是" |
| 4 | **对比建立认知** | 纯说理无参照 | "黄金涨了一倍，但已不是最优质的资产" |
| 5 | **数据随口说** | 罗列精确数据表格 | "大概""左右"，像随口提但显内行 |
| 6 | **逻辑链≤3环** | A→B→C→D→E | "需求增长→稀缺性加大→走新巅峰" |
| 7 | **200-350字** | 超400或不到150 | 每条逻辑独立成段，短句一屏一换气 |
| 8 | **温和不唱衰** | "必涨""我不碰""风险大" | "可能刚开始""需要留意的是""市场在纠结" |
| 9 | **个人经验背书** | 纯客观分析 | "我在里面确实看到了这个变化" |
| 10 | **收尾在核心逻辑** | "这是我的判断"式收尾 | 一句话核心洞察，可温和预告后续 |

### Length control
| Spec | Characters | Duration | When |
|------|-----------|----------|------|
| Short (preferred) | 200-260 | 60-75s | Daily updates |
| Standard | 260-320 | 75-90s | Deeper analysis |
| Long (avoid) | 320-380 | 90-110s | Hardcore industry only |

### 8-Point Scoring Checklist (≥7分合格，<7分针对性重写，最多3轮)

| # | 检查项 | 0分（❌） | 1分（✅） |
|:--:|--------|------|------|
| 1 | 开头有钩子？ | 平淡开头 | 数据冲击/反常识/反问 |
| 2 | 口语化像聊天？ | 书面语 | 读出来不拗口 |
| 3 | 逻辑链≤3环？ | 说教感 | 一条主线清晰 |
| 4 | 200-350字？ | 超了/不够 | 精炼合身 |
| 5 | 给出明确结论？ | 模糊收尾 | 一句话核心洞察 |
| 6 | 合规通过？ | 有敏感词 | 全部替换 |
| 7 | 有对比参照物？ | 纯说理 | 熟悉→不熟悉 |
| 8 | 收尾有记忆点？ | "以上就是今天的分享" | 金句/核心逻辑 |

**不合格分支（找最低分项打回）**：
- #1钩子弱 → 重写开头（3轮）
- #2书面语 → 口语化重写（2轮）
- #6敏感词 → 替换（1轮）
- #4超字数 → 精简（2轮）
- 3轮仍<7分 → 输出+标注"AI尽力了"

### Compliance (完整版)

| ❌ 禁用词 | ✅ 替换词 |
|------|------|
| 买入/卖出/梭哈/目标价/内幕/庄家 | —（禁出现） |
| 必涨/翻倍/稳赚 | 增长/接近翻倍/持续 |
| 暴涨/暴跌/疯涨/疯狂 | 增长/回调/持续 |
| 我不碰/风险很大/不值得 | 需要留意的是/市场在纠结 |
| 推荐/主力/出货 | 值得留意/大资金/兑现 |
| 妖股/底部 | 高辨识度标的/企稳信号 |
| 这是我的判断/这是我的态度 | 收在核心逻辑一句话 |

## Step 4: Save Output
- Market brief → any path the user specifies; default `~/Documents/hermes_output/YYYYMMDD-行情速报.md`
- Douyin script → same directory, `YYYYMMDD-抖音口播.md`


### Length control
This skill is part of the integrated finance toolkit:
- **`a-share-market-data`** — API reference for index/stock/sector data
- **`pre-post-market-report`** — Full pre/post-market report format with Top10 news, event chains, sector pools
- **`stock-deep-analysis`** — 12-dimension deep stock analysis with 7-factor scoring
- **`douyin-script-generator`** — Standalone script generator with full 10-rule table + 8-point QA
- **`sector-analysis`** — Sector chain analysis + 白毛魔女 bottleneck detection
- **`fund-manager-team`** — Full portfolio management with team workflow
- **`content-supervisor`** — Daily content pipeline with 3-track rotation

## Pitfalls
- EastMoney API field `f52` (总股本) can return garbage values — compute total shares from market_cap ÷ price instead
- The `f116` market cap field is in raw units (×1), not 亿; divide by 1e8
- Sina API returns GBK-encoded data; decode as `.decode('gbk')`
- Don't fabricate news when web scraping fails — work with the market data you have
- Weekend/non-trading days: use last trading day's data, note the date clearly
