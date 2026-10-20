# Writing Spec for AI (Tiếng Việt)

<p align="center">
  <a href="./README.md">English</a> · <strong>Tiếng Việt</strong>
</p>

Bộ skill `writing-spec-for-ai`: AI khảo sát dự án → trình **đề xuất thiết kế docs** → làm rõ → viết docs → tự kiểm → thử docs bằng task mẫu → chỉ sau 3 cổng duyệt của bạn mới code.

Skill chính là **bộ điều phối**; mỗi bước triển khai chi tiết thành một sub-skill riêng (viết riêng cho từng loại việc: khảo sát, đề xuất, viết spec, viết design, thay đổi spec, review, thử docs).

## Cấu trúc

```
SKILL.md                         # bộ điều phối: 8 bước, 3 cổng duyệt, bàn giao sub-skill
CHANGELOG.md                     # phiên bản base (git tag), ID luật đổi mỗi bản
skills/                          # sub-skill chi tiết theo từng bước
  survey-project/SKILL.md        #   1–2. khảo sát, bằng chứng, mức 0/1/2
  propose-doc-design/SKILL.md    #   3–4. đề xuất thiết kế + chia bộ spec theo khu vực (Cổng 1)
  write-spec/SKILL.md            #   5b. viết 1 spec: EARS, NFR, biên, AC Cho/Khi/Thì
  write-design-doc/SKILL.md      #   5c. thiết kế khi spec > 2 PR / chạm schema, API, bảo mật
  change-spec/SKILL.md           #        spec con vs CHG-xx; vòng đời P-xx → D-xx
  review-docs/SKILL.md           #   6.   chấm checklist, báo cáo (Cổng 2)
  test-docs/SKILL.md             #   7.   thử docs bằng task mẫu, phiên mới (Cổng 3)
references/
  principles.md                  # mô hình, bộ kỹ năng mức 0/1/2, quy tắc spec, phong cách,
                                 # ma trận công cụ, skill dự án vs global, bài học, nguồn
  examples.md                    # ví dụ chuẩn từ dự án thật (REQ EARS, AC, NFR, decisions, plan)
  review-checklist.md            # chấm AGENTS.md, từng spec, trạng thái, vị trí, thử docs
  base-kit.md                    # sổ đăng ký luật Core (C-xx) / Pack (PK-…), Profile S-M-L,
                                 # luật ghi đè, lộ trình phát triển base
packs/                           # tầng Pack, mỗi pack một file (PK-API, PK-AUTH, PK-RELEASE…)
  PK-API.md                      # HTTP API
  PK-AUTH.md                     # Token, khoá, chữ ký
  PK-RELEASE.md                  # Docker, registry, phát hành
profiles.md                      # preset Profile S/M/L
templates/
  doc-design-proposal.md         # Cổng 1
  AGENTS.md
  docs/
    glossary.md
    decisions.md                 # + định danh hiện hành, P-xx
    adr/_template.md
    specs/README.md, _template.md, _design-template.md   # README: quyền AI theo trạng thái, hotfix, loại thay đổi → file
    changes/_proposal-template.md   # thay đổi spec dạng delta
    plans/_plan-template.md, HANDOFF.md
    progress.md
    upgrade/_template.md
    reference/config.md, error-codes.md   # biến môi trường, mã lỗi — mỗi thứ một chỗ
    changelog/_template.md
  adapters/
    CLAUDE.md, copilot-instructions.md, pull_request_template.md
    scoped-rules.md              # luật theo thư mục cho 4 công cụ
    claude-settings.json         # deny-rules + hook
    subagent.md
  project-skill/SKILL.md
```

## Cài đặt

### Tự động (1 dòng lệnh)

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.ps1 | iex
```

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.sh | bash
```

### Thủ công

Cài **nguyên bộ** (giữ nguyên cấu trúc — sub-skill trỏ nhau bằng đường dẫn tương đối). Sao chép thư mục thành `writing-spec-for-ai`:

| Agent | Global | Theo dự án |
|---|---|---|
| Antigravity | `~/.gemini/config/skills/writing-spec-for-ai/` | `<repo>/.agents/skills/writing-spec-for-ai/` |
| Claude Code | `~/.claude/skills/writing-spec-for-ai/` | `<repo>/.claude/skills/writing-spec-for-ai/` |
| Codex / OpenCode / Cursor / ZCode | `~/.agents/skills/writing-spec-for-ai/` | `<repo>/.agents/skills/writing-spec-for-ai/` |

```powershell
Copy-Item -Recurse D:\WrittingSpecForAI "$HOME\.gemini\config\skills\writing-spec-for-ai"
```

## Cách dùng

> Dùng skill writing-spec-for-ai thiết kế docs cho dự án này.

Có thể gọi trực tiếp sub-skill khi chỉ cần một việc:

> Dùng skill write-spec viết spec cho khu vực <X>.
> Dùng skill survey-project khảo sát repo này.
> Dùng skill change-spec xử lý yêu cầu đổi <…> vào SPEC-<…>.

AI dừng ở 3 chỗ: sau đề xuất thiết kế (Cổng 1), sau khi viết docs (Cổng 2), sau khi thử docs (Cổng 3) — bạn duyệt từng cổng mới sang bước sau; code chỉ bắt đầu sau Cổng 3.
