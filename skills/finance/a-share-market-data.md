---
name: a-share-market-data
description: "Fetch Chinese A-share real-time quotes, index data, and financials via free public APIs. Covers Eastmoney push2 and Sina hq endpoints with field reference and common pitfalls."
version: 1.0.0
platforms: [macos, linux]
metadata:
  hermes:
    tags: [a-share, stock, finance, data, api, eastmoney, sina]
---

# A-Share Market Data Fetching

Fetch real-time A-share stock quotes, index data, sector rankings, and financials using free public APIs. No API key required.

## Quick Start

### Single Stock Quote (Eastmoney push2)

```bash
python3 -c "
import urllib.request, json
code = '300476'  # 胜宏科技
url = f'https://push2.eastmoney.com/api/qt/stock/get?secid=0.{code}&fields=f43,f170,f20,f162,f167'
req = urllib.request.Request(url, headers={'User-Agent':'Mozilla/5.0'})
d = json.loads(urllib.request.urlopen(req, timeout=8).read())['data']
print(f'股价:{d[\"f43\"]/100:.2f} 涨跌:{d[\"f170\"]/100:.1f}% 市值:{d[\"f20\"]/1e8:.0f}亿 PE:{d[\"f162\"]/100:.1f}')
"
```

### Index Data (Eastmoney push2)

```bash
curl -s "https://push2.eastmoney.com/api/qt/ulist.np/get?fltt=2&invt=2&fields=f2,f3,f4,f12,f14&secids=1.000001,0.399001,0.399006,0.000688" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for i in d.get('data',{}).get('diff',[]):
    print(f'{i[\"f14\"]}: {i[\"f2\"]} ({i[\"f3\"]}%)')
"
```

### Simpler Alternative (Sina hq)

```bash
python3 -c "
import urllib.request
url='https://hq.sinajs.cn/list=sz300476,sh000001'
req=urllib.request.Request(url,headers={'Referer':'https://finance.sina.com.cn'})
data=urllib.request.urlopen(req,timeout=8).read().decode('gbk')
print(data[:300])
"
```

## Eastmoney push2 API Reference

**Base URL**: `https://push2.eastmoney.com/api/qt/stock/get`

**secid format**:
- Shanghai: `1.{code}` (e.g. `1.600519` for 贵州茅台)
- Shenzhen main board: `0.{code}` (e.g. `0.000001` for 平安银行)
- ChiNext (创业板): `0.{code}` (e.g. `0.300476` for 胜宏科技)
- STAR (科创板): `1.{code}` (e.g. `1.688256` for 寒武纪)

**Common field reference** (`fields=` parameter):

| Field | Description | Scale |
|-------|-------------|-------|
| f43 | Current price | ÷100 |
| f44 | High | ÷100 |
| f45 | Low | ÷100 |
| f46 | Open | ÷100 |
| f60 | Previous close | ÷100 |
| f48 | Turnover (volume × price) | Raw |
| f50 | 52-week low | ÷100 |
| f51 | 52-week high | ÷100 |
| f52 | Total shares | See note below |
| f57 | Stock code | String |
| f58 | Stock name | String |
| f116 | Total market cap | Raw (元) |
| f117 | Free-float market cap | Raw (元) |
| f20 | Total market cap | Raw (元) |
| f21 | Free-float market cap | Raw (元) |
| f162 | PE (dynamic) | ÷100 |
| f167 | PB | ÷100 |
| f168 | Turnover rate | ÷100 |
| f170 | Change % | ÷100 |
| f169 | Change % (5-day?) | ÷100 |

> ⚠️ `f20` and `f116` may not always be populated. `f116` (总市值) is the more reliable field. `f52` (总股本) can be unreliable — calculate shares from `f116 / (f43/100)` if needed.

## Sina hq API

**Base URL**: `https://hq.sinajs.cn/list={market}{code}`

**Format**: `sz{code}` for Shenzhen, `sh{code}` for Shanghai.

Response format (comma-separated):
```
var hq_str_sz300476="胜宏科技,今开,昨收,现价,最高,最低,...,日期,时间,...";
```

**Key fields** (0-indexed after stock name):
- [0]: 今开
- [1]: 昨收
- [2]: 现价
- [3]: 最高
- [4]: 最低
- [8]: 成交额 (元)

## Index secid Reference

| Index | secid |
|-------|-------|
| 上证指数 | 1.000001 |
| 深证成指 | 0.399001 |
| 创业板指 | 0.399006 |
| 科创50 | 1.000688 |

## Common Pitfalls

- **Wrong secid format**: ChiNext stocks use `0.{code}` NOT `1.{code}`. If you get bad data (wrong price, tiny shares), check the secid.
- **Sina needs Referer header**: Always include `Referer: https://finance.sina.com.cn` or the request will fail.
- **Financial data APIs**: Eastmoney's financial data APIs (`datacenter.eastmoney.com`, `emweb.securities.eastmoney.com`) frequently return empty or require complex parameters. For financials (revenue, profit, margins), prefer web search or use the simpler push2 endpoint for real-time quotes only.
- **52-week low anomaly**: The `f50` field sometimes returns garbage values (e.g. 1.16 for a 300+ yuan stock). Cross-check with judgment.
- **Sina returns GBK encoding**: Use `.decode('gbk')` when reading Sina responses.
- **Weekend data**: On weekends/holidays, APIs return the last trading day's closing data. The `date` field in the response tells you which trading day it's from.
- **EastMoney rate-limiting**: During heavy trading hours (9:30-15:00), EastMoney APIs frequently return `RemoteDisconnected` or `Connection aborted` errors. This is NOT a code bug — it's server-side throttling. **Fallback to Sina hq** (more reliable, always works with Referer header). If Sina also fails, accept partial data and note "API限流".
- **Sector ranking API (`fs=m:90+t2`)**: Often returns empty `data` or `null diff` during rate-limiting. Use Sina hq for individual stock quotes instead of relying on sector-level APIs during peak hours.
- **科创50 secid is `1.000688` NOT `0.000688`**: Using wrong prefix returns garbage (e.g. 国城矿业). All STAR Market indices use `1.` prefix.
- **Batch stock scoring**: When scoring many stocks (10+), APIs will rate-limit. Split into batches of 5-6, run in parallel terminal calls, accept default (50) for factors that fail to fetch.
