# Writing Spec for AI (Tiếng Việt — v1.2.0)

<p align="center">
  <a href="./README.md">English</a> · <strong>Tiếng Việt</strong>
</p>

Bộ skill & plugin `writing-spec-for-ai`: AI khảo sát dự án (`spec-surveyor`) → trình **đề xuất thiết kế docs + Capability Map** → làm rõ theo **Frontier + HYPOTHESIS/GUESS** → viết docs (`AGENTS.md`, `CONSTRAINTS.md`, `SPEC-xx`, `DESIGN-xx`) → phản biện đối kháng trong context sạch (`spec-challenger`) → thử docs bằng task mẫu trong phòng sạch (`doc-tester`) → chẻ đồ thị Tracer-Bullet tasks (`plan-tasks`) & sinh skill tự kiểm (`generate-verify-harness`) → chỉ sau 3 cổng duyệt của bạn mới code.

## Cấu trúc (`v1.2.0`)

```text
SKILL.md                                 # Bộ điều phối: 8 bước, 3 cổng duyệt, bàn giao 9 sub-skill & 3 subagent
CHANGELOG.md                             # Phiên bản base (git tag), ID luật đổi mỗi bản
profiles.md                              # Preset Profile S / M / L
skills/                                  # 9 Sub-skill chuyên biệt theo từng bước
  survey-project/SKILL.md                #   1–2. Khảo sát, Knowledge Graph, Ratchets, mức 0/1/2 & Pack
  propose-doc-design/SKILL.md            #   3–4. Đề xuất thiết kế + Capability Map + Frontier Q&A (Cổng 1)
  write-spec/SKILL.md                    #   5b.  Viết 1 spec: EARS, NFR 8 dòng, biên, AC Cho/Khi/Thì
  write-design-doc/SKILL.md              #   5c.  Thiết kế Deep Modules, Seams, Design It Twice, C25, C27
  change-spec/SKILL.md                   #        Spec con vs CHG-xx; vòng đời P-xx → D-xx
  review-docs/SKILL.md                   #   6.   Phản biện đối kháng & chấm checklist (Cổng 2)
  test-docs/SKILL.md                     #   7.   Thử docs bằng task mẫu trong phiên sạch (Cổng 3)
  plan-tasks/SKILL.md                    #   7.5. Chẻ Spec thành đồ thị Tracer-Bullet Slices (Blocked by)
  generate-verify-harness/SKILL.md       #        Sinh skill kiểm chứng runtime (.agents/skills/verify-<app>/)
agents/                                  # 3 Subagents chạy trong context cô lập
  spec-surveyor.md                       #   Khảo sát repo chỉ đọc (read-only), trả về bảng path:line nén gọn
  spec-challenger.md                     #   Phản biện đối kháng ở Cổng 2 (chỉ nhận ARTIFACT + CONTRACT)
  doc-tester.md                          #   Đóng vai dev mới trong phòng sạch ở Cổng 3
packs/                                   # 8 Domain Packs kế thừa theo tín hiệu
  PK-API.md                              #   HTTP API, error envelope, phân trang, CORS, health check
  PK-AUTH.md                             #   Token, khoá, chữ ký constant-time, log redaction
  PK-RELEASE.md                          #   Docker hardening, SemVer, đồng bộ artifact build
  PK-DB.md                               #   Schema, Expand–Contract migration, idempotent seed, chống N+1
  PK-OBS.md                              #   Structured JSON log, correlationId + entryPoint, RED metrics, runbook
  PK-FE.md                               #   UI 4 trạng thái, Design Tokens, WCAG 2.2 AA, Playwright E2E
  PK-JOB.md                              #   Job nền lũy đẳng, backoff + DLQ, CAS lease lock, SIGTERM
  PK-AGENT.md                            #   Điều phối AI agent, hard-refuse policy, sandbox, chống prompt injection
references/
  principles.md                          #   Mô hình, bộ kỹ năng mức 0/1/2, EARS, ma trận công cụ
  examples.md                            #   Ví dụ chuẩn từ dự án thật
  review-checklist.md                    #   Checklist chấm Cổng 2 & Cổng 3
  base-kit.md                            #   Sổ đăng ký luật Core (C01–C27), 8 Pack (PK-*), Profile S/M/L
templates/
  doc-design-proposal.md                 #   Mẫu đề xuất Cổng 1
  AGENTS.md                              #   Mẫu AGENTS.md (≤ 150 dòng, Context Pointers C24)
  CONSTRAINTS.md                         #   Mẫu sàn chất lượng cưỡng chế bằng lệnh máy & Ratchets (C23)
  docs/                                  #   specs/, changes/, plans/, adr/, reference/, upgrade/, changelog/
  adapters/                              #   CLAUDE.md, copilot-instructions.md, scoped-rules.md, claude-settings.json
  project-skill/SKILL.md                 #   Mẫu skill dự án
```

## Cài đặt (1 dòng lệnh — cài đồng thời 9 Skills + 3 Subagents cho 7 công cụ)

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.ps1 | iex
```

**macOS / Linux / WSL:**
```bash
curl -fsSL https://raw.githubusercontent.com/huongmh14/writing-spec-for-ai/main/install.sh | bash
```

## Cách dùng

> Dùng skill `writing-spec-for-ai` khảo sát và thiết kế bộ docs cho dự án này.

Hoặc gọi trực tiếp từng sub-skill khi cần:
- `survey-project` / `propose-doc-design` / `write-spec` / `write-design-doc` / `review-docs` / `test-docs` / `plan-tasks` / `generate-verify-harness` / `change-spec`.
