---
name: knowledge-base-management
description: Manage a markdown knowledge base with CLAUDE.md-driven auto-ingest, content boundary filtering, cross-linked wiki entries, and index/log maintenance.
platforms: [macos, linux]
---

# Knowledge Base Management

Use this skill when the user has a markdown-based knowledge base (typically an Obsidian vault) governed by a root-level `CLAUDE.md` that defines ingest/query/lint rules, content boundaries, and automatic ingestion behavior.

## When to load

Load this skill when:
- The working directory is inside a vault that has a `CLAUDE.md` at its root
- The user says "ingest", "知识库", "knowledge base", "wiki", "入库"
- You're about to create or update structured wiki entries with frontmatter and wikilinks
- A conversation produces substantive knowledge that should be persisted

## Core workflow

### 1. Load the rules first

On entering a vault, immediately read `CLAUDE.md`. It defines:
- **Directory structure**: where `raw/` (read-only sources) and `wiki/` (managed entries) live
- **Operations**: Ingest, Query, Lint — each with specific steps
- **Content boundaries**: what qualifies for ingestion (often expressed as capability lines or topic filters)
- **Automatic vs. manual mode**: whether you should auto-ingest or wait for commands

### 2. Content boundary filtering

When CLAUDE.md defines scoped capability lines (e.g., "AI技术实战 / 产业财经研究 / 自媒体实操"), filter every piece of incoming material against them BEFORE writing entries:

```
For each source item:
  Does it serve, extend, or supplement any of the defined lines?
    YES → Continue to reusability check
    NO  → Skip (note count in log)
```

Examples of what passes: a new investment framework → 产业财经线. A content creation hack → 自媒体线.
Examples of what skips: health tips, movie reviews, one-off purchase notes, personal anecdotes outside the lines.

### 2.1. Reusability filter (second gate)

After passing the boundary filter, apply the **"三个月后回看" test**:

```
Would this content still have value in 3 months?
  ✅ YES → Ingest (create/update wiki entry)
  ❌ NO  → Skip — it's temporary/ephemeral
```

**Save**: frameworks, methodologies, rules, processes, templates, principles, mental models
**Skip**: daily market data, one-off task results, stale numbers, temporary checklists

This filter keeps the wiki clean of noise. The knowledge base is a methodology library, not a log of everything that happened.

### 3. Wiki entry structure

Every wiki entry gets YAML frontmatter:

```yaml
---
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [URL, file path, or conversation description]
tags: [domain tags]
---
```

The body follows this pattern:
- `# Title` — the concept name
- One-sentence summary
- `## 详细说明` (or `## Details`) — structured sections with tables where appropriate
- `## 相关条目` — `[[wikilink]]` list of related entries

**Principles**:
- Summarize in your own words, don't copy-paste source material
- Build bidirectional links aggressively — every entry should link to and be linked from others
- Incrementally update existing entries rather than creating duplicates
- Keep entries concise and judgment-oriented, not raw data dumps

### 4. Raw material persistence (always do this)

Before or alongside wiki entry creation, save the original source material to `raw/`:

- Web articles → save as `raw/source-name.md`
- Browser-extracted content → pipe to `raw/yuque-notes.md` or similar
- Claude skills → copy entire skill directory to `raw/claude-skills/`
- User conversations → save the transcript or key excerpts

This preserves provenance. Wiki entries are summaries; raw/ is the unalterable original. Never modify raw/ files after saving.

### 5. Index and log maintenance

After every ingest session:

**Update `wiki/index.md`**: Add new entries under their domain section with a one-line description. Group by the CLAUDE.md's defined categories.

**Update `wiki/log.md`**: Prepend a dated entry:
```markdown
## [YYYY-MM-DD] ingest | source description
- 新增：[[NewEntry]] — one-line summary
- 更新：[[ExistingEntry]]（what changed）
- 跳过：X items outside boundary
```
- 原始素材：list all new files saved to raw/

### 6. Automatic ingestion mode

When CLAUDE.md specifies automatic ingestion: evaluate every substantive exchange. When content falls within the boundary, create or update entries without prompting the user. Log everything so they can audit later.

When the mode is manual: wait for the user to say "摄入" or similar before acting.

### 6. Dual-directory bridge (production ↔ knowledge base)

When the user has both a production project (Claude/Hermes with skills/scripts) and a knowledge base vault, bridge them:

1. **Production project** gets an `AGENTS.md` that:
   - References the knowledge base's `CLAUDE.md` for methodology
   - Lists production skills and scripts
   - States: "reusable methodology from production → auto-sync to knowledge base"

2. **Knowledge base** `CLAUDE.md` reciprocally references the production project path

3. **Auto-sync rule**: When executing production tasks, if a new reusable framework/methodology emerges, automatically write it to the knowledge base wiki. One-off outputs (daily reports, stock prices) never sync.

4. **Working directory switching**: Switch `cwd` based on task type — production → project dir, knowledge → vault dir.

### 7. Infrastructure files (do NOT check as entries)

These are vault infrastructure, not wiki entries. Exclude from quality checks:

| File | Role |
|------|------|
| `CLAUDE.md` | Vault rules/config |
| `wiki/index.md` | Auto-maintained index |
| `wiki/log.md` | Auto-maintained changelog |

### 8. Scheduled linting (cron-based quality check)

Set up a daily cron job to auto-audit the wiki. See `references/knowledge-base-cron-lint.md` for the exact cron command and inspection checklist. The cron runs every morning and delivers a concise report to the user's messaging platform.

## Extracting content from authenticated SPAs

When source material lives behind a login wall (Yuque, Notion, Feishu, etc.) and the user has it open in Chrome:

1. Confirm Chrome is running with the target page in the active tab.
2. Have the user enable **View → Developer → "Allow JavaScript from Apple Events"** (one-time, per-Chrome-profile).
3. Execute extraction via AppleScript:

```bash
osascript -e '
tell application "Google Chrome"
    tell active tab of front window
        execute javascript "
            document.body.innerText.substring(0, 8000);
        "
    end tell
end tell'
```

4. Parse the returned text for wiki-worthy content.
5. For long pages, run multiple extractions with targeted DOM selectors to avoid truncation.

**Pitfalls**:
- `System Events` keystroke simulation (`keystroke`, `key code`) fails with error -1002 under default macOS permissions. Use `execute javascript` instead — it's faster and doesn't need accessibility grants.
- If the page is a React SPA, `document.body.innerText` may include UI chrome text. Use more specific selectors (e.g., `document.querySelector('.note-content').innerText`) when available.
- The 8000-char substring limit is arbitrary; adjust based on content density. For very large pages, paginate with multiple JS calls.

## User interaction preferences

### Numeric confirmations (1/0)

When giving the user a binary choice (proceed/skip), use numeric choices so they can reply with a single digit — never make them type words:

```
choices: ["1 — 继续/装/要", "0 — 跳过/不要/等等"]
```

Use `clarify(question="...", choices=["1 — ...", "0 — ..."])`. The user explicitly prefers tapping digits over typing "approve", "yes", "deny", or sentences.

### Concise replies

Keep WeChat replies compact — one screen, no walls of text. Use tables and bullet points. The user values speed over completeness.

### Hermes approval friction

If command-approval prompts become repetitive, switch to smart mode:
```bash
hermes config set approvals.mode smart
```
This auto-approves low-risk operations. Requires session restart.
