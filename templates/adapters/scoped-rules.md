# Luật theo phạm vi — một nội dung, bốn vị trí

Chỉ nạp khi agent chạm file trong phạm vi. Chọn **một** nguồn nội dung (khuyên: `AGENTS.md` thư mục con) rồi cho các công cụ khác trỏ tới, tránh chép bốn lần.

## 1. AGENTS.md thư mục con (Codex, Copilot agent, Cursor, Antigravity)

`<thư-mục>/AGENTS.md` — file gần nhất thắng / nối sau file gốc.

```markdown
# Luật cho <thư-mục>

- <luật chuyên sâu, kèm lý do một dòng>
```

## 2. Claude Code

`<thư-mục>/CLAUDE.md` chỉ chứa:

```markdown
@AGENTS.md
```

## 3. GitHub Copilot — `.github/instructions/<tên>.instructions.md`

```markdown
---
applyTo: "<thư-mục>/**"
---
Tuân thủ `<thư-mục>/AGENTS.md`.
```

## 4. Cursor — `.cursor/rules/<tên>.mdc`

```markdown
---
description: Luật cho <thư-mục>
globs: <thư-mục>/**
alwaysApply: false
---
Tuân thủ `<thư-mục>/AGENTS.md`.
```
