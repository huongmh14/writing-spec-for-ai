# Writing Spec for AI (Tiếng Việt — v1.3.0)

<p align="center">
  <a href="./README.md">English</a> · <strong>Tiếng Việt</strong>
</p>

**Bản sửa đang thử (2026-10-25):** mặc định mỗi đợt AI chỉ làm **1 spec + 1 task có thể kiểm**, báo bằng chứng rồi dừng. `Ready` xác nhận yêu cầu, chưa phải quyền chạy toàn bộ. Bạn duyệt hành vi/phạm vi qua ví dụ; AI phải tìm nguồn và kiểm kỹ thuật, ghi rõ điều chưa biết. Mỗi khẳng định quan trọng gắn 1 trong 4 nhãn: `Người dùng chốt` · `Đã xác minh` (con trỏ mở được + trích nguyên văn) · `AI đề xuất` · `Chưa biết`. Quyết định kỹ thuật bạn không tự thẩm định được đi kèm **thẻ quyết định**: bạn duyệt bước tự kiểm ≤ 5 phút, không duyệt lập luận; vùng bảo mật/thanh toán/pháp lý/dữ liệu cá nhân ghi "cần chuyên gia". Thuật ngữ kit: [references/glossary.md](references/glossary.md).

Đọc [nghiên cứu và nguồn sơ cấp](references/research-controlled-execution.md), [bản thử trước/sau và 6 tình huống kiểm](references/controlled-spec-demo.md), [mẫu spec đã sửa](templates/docs/specs/_template.md). Luật **Quyền thực thi theo đợt** (`C30`) và **Nguồn & giới hạn hiểu biết** (`C31`) ở [base-kit](references/base-kit.md); thay đổi chưa phát hành ở [CHANGELOG](CHANGELOG.md).

```text
Chỉ làm T-01 của SPEC-[tên], phạm vi AC-[01,02].
Kiểm ví dụ đã chốt, báo kết quả thật và điều chưa kiểm rồi dừng.
Chưa làm task/spec tiếp theo. Kỹ thuật cần có nguồn/phép kiểm.
```

Giao rõ toàn spec/batch hữu hạn thì AI làm hết phạm vi đó, không hỏi lại từng task. Chỉ viết chi tiết spec sắp làm. Markdown hướng dẫn; cưỡng chế thật cần quyền công cụ/sandbox và review diff phù hợp nền tảng.

Bộ skill & plugin `writing-spec-for-ai` giúp AI viết bộ tài liệu điều khiển agent theo trình tự, và **bạn duyệt ở 3 cổng trước khi có dòng code nào**:

1. AI khảo sát repo (`spec-surveyor`).
2. AI trình đề xuất: bảng phạm vi 🟢 làm ngay / 🟡 đợt sau / 🔴 không làm, các phương án vẽ trực quan kèm đánh đổi, và tối đa 3 câu hỏi chỉ bạn quyết được. → **Cổng 1**
3. AI viết docs, mỗi lượt một phần rồi dừng cho bạn xem: `AGENTS.md`, `CONSTRAINTS.md`, từng `SPEC-xx` (có ví dụ đầu vào/đầu ra cụ thể và bảng kiểm thử), design doc.
4. Một AI khác ở phiên sạch phản biện bộ docs (`spec-challenger`). → **Cổng 2**
5. Thử docs bằng 2–3 task mẫu (Profile S: 2; M/L: 3) ở phiên sạch (`doc-tester`). → **Cổng 3**
6. Chia việc thành lát cắt nhỏ (`plan-tasks`), sinh skill tự kiểm (`generate-verify-harness`), rồi mới code. Mỗi lần báo xong đều có bảng bằng chứng chạy test, ghi rõ có dùng mock hay không.

## Cấu trúc (`v1.3.0`)

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
  explore-options/SKILL.md               #        Khám phá 2–4 phương án đa góc nhìn, người dùng chọn → D-xx
agents/                                  # 3 Subagents chạy trong context cô lập
  spec-surveyor.md                       #   Khảo sát repo chỉ đọc (read-only), trả về bảng path:line nén gọn
  spec-challenger.md                     #   Phản biện đối kháng ở Cổng 2 (chỉ nhận ARTIFACT + CONTRACT)
  doc-tester.md                          #   Đóng vai dev mới trong phòng sạch ở Cổng 3
packs/                                   # 8 Domain Packs kế thừa theo tín hiệu
  PK-API.md                              #   HTTP API, error envelope, phân trang, CORS, health check
  PK-AUTH.md                             #   Token, khoá, chữ ký constant-time, log redaction
  PK-RELEASE.md                          #   Docker hardening, SemVer, đồng bộ artifact build
  PK-DB.md                               #   Schema, Expand–Migrate–Contract migration, idempotent seed, chống N+1
  PK-OBS.md                              #   Structured JSON log, correlationId + entryPoint, RED metrics, runbook
  PK-FE.md                               #   UI 4 trạng thái, Design Tokens, WCAG 2.2 AA, Playwright E2E
  PK-JOB.md                              #   Job nền lũy đẳng, backoff + DLQ, CAS lease lock, SIGTERM
  PK-AGENT.md                            #   Điều phối AI agent, hard-refuse policy, sandbox, chống prompt injection
references/
  principles.md                          #   Mô hình, bộ kỹ năng mức 0/1/2, EARS, ma trận công cụ
  examples.md                            #   Ví dụ chuẩn từ dự án thật (gồm Scope Radar & bảng test hiển thị)
  glossary.md                            #   Thuật ngữ kit bằng lời thường (Cổng, Profile, Pack, Frontier, EARS…)
  lenses.md                              #   Góc nhìn chuyên môn chọn theo tín hiệu (thay "đóng vai senior")
  review-checklist.md                    #   Checklist chấm Cổng 2 & Cổng 3
  base-kit.md                            #   Sổ đăng ký luật Core (C01–C31), 8 Pack (PK-*), Profile S/M/L
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
- `survey-project` / `propose-doc-design` / `write-spec` / `write-design-doc` / `review-docs` / `test-docs` / `plan-tasks` / `generate-verify-harness` / `explore-options` / `change-spec`.
