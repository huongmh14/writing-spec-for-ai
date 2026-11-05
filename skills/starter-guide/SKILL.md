---
name: starter-guide
description: Hướng dẫn nhanh cho người mới bắt đầu với bộ skill - nhóm theo mức độ và tình huống sử dụng. AI tự động đề xuất skill phù hợp.
license: MIT
---

# Starter Guide - Hướng Dẫn Nhanh Cho Người Mới

# Starter Guide - Hướng Dẫn Nhanh Cho Người Mới

**Dành cho:** Người mới bắt đầu sử dụng AI agents để làm việc với code hoặc muốn nắm nhanh cách phối hợp các skill khi dự án lớn dần.

**Quan trọng nhất:** Bạn **KHÔNG** cần thuộc lòng tên skill. Skill `auto-guide` sẽ tự động phát hiện tình huống và đề xuất chuỗi skill phù hợp kèm lý do. Bạn chỉ cần mô tả bài toán của mình.

---

## 1. AI Tự Động Điều Hướng (`auto-guide`) - Bạn Chỉ Cần Nói

| Bạn nói với AI | AI tự động đề xuất | Lý do |
|---|---|---|
| *"Fix lỗi này"* / *"Test bị fail"* | `systematic-debugging` → `verification-before-completion` | Tìm nguyên nhân gốc (root cause) trước khi sửa, sau đó chạy test xác nhận |
| *"Lần đầu vào project này"* (< 50 files) | `explore` → `writing-spec-simple` | Hiểu kiến trúc codebase + tạo `AGENTS.md` gọn nhẹ cho AI |
| *"Lần đầu vào project lớn"* (>= 50 files) | `explore` → `writing-spec-for-ai` | Khảo sát + chuẩn hoá docs đầy đủ theo Profile M/L |
| *"Implement tính năng X"* (nhiều bước) | `writing-plans` → code → `verification-before-completion` | Chia nhỏ task từ spec/requirements trước khi viết code |
| *"Review nhánh / PR này"* | `code-review` | Kiểm tra song song 2 trục: **Standards** (chuẩn code) và **Spec** (đúng yêu cầu) |
| *"Refactor đoạn code này"* | `safe-refactor` | Tái cấu trúc nhưng giữ nguyên hành vi, có test chặn trước/sau |
| *"Viết test trước rồi mới code"* | `tdd` | Quy trình RED → GREEN → REFACTOR |
| *"Đã xong, kiểm tra giúp tôi"* | `verification-before-completion` | Chạy lệnh kiểm chứng thực tế trước khi báo hoàn thành |

---

## 2. Ba Mức Độ Skill Cốt Lõi

### Mức Cơ Bản (Beginner) - Dùng hàng ngày
| Skill | Khi nào dùng | Ví dụ câu nói |
|---|---|---|
| `explore` | Lần đầu xem code, chưa biết file nào chứa logic cần tìm | *"Luồng đăng nhập hoạt động thế nào trong repo này?"* |
| `systematic-debugging` | Gặp bug, lỗi runtime, hoặc test đỏ | *"Test `test_checkout` bị fail, tìm nguyên nhân giúp tôi"* |
| `code-review` | Review PR/branch trước khi merge | *"Review branch `feat/login` đối chiếu với spec"* |
| `verification-before-completion` | Sắp xong task, cần bằng chứng test/build trước khi commit | *"Kiểm tra xem mọi tiêu chí AC đã pass chưa"* |

### Mức Trung Bình (Intermediate) - Khi cần quy trình chuẩn
| Skill | Khi nào dùng | Ví dụ câu nói |
|---|---|---|
| `writing-spec-simple` | Dự án mới hoặc nhỏ (`< 50` files) chưa có `AGENTS.md` / spec | *"Viết AGENTS.md và spec cơ bản cho dự án này"* |
| `writing-plans` | Có spec/requirements, cần chia nhỏ task trước khi code | *"Lập kế hoạch implement API quản lý đơn hàng"* |
| `tdd` | Muốn viết test trước khi viết code | *"Dùng TDD cho tính năng tính phí vận chuyển"* |
| `git-workflow-and-versioning` | Tách working tree lộn xộn thành các commit nguyên tử, xử lý conflict | *"Tách các thay đổi hiện tại thành các commit theo đúng chuẩn"* |

### Mức Nâng Cao (Advanced) - Khi dự án mở rộng (Team / Production)
| Skill | Khi nào dùng | Ví dụ câu nói |
|---|---|---|
| `writing-spec-for-ai` | Dự án vừa và lớn (`>= 50` files, team `>= 3` người), cần 3 cổng duyệt + Packs | *"Chuẩn hoá bộ tài liệu AI theo Profile M cho hệ thống này"* |
| `documentation-and-adrs` | Ghi nhận quyết định kiến trúc (ADR) hoặc thay đổi API công khai | *"Ghi ADR cho quyết định chọn PostgreSQL thay vì MongoDB"* |
| `safe-refactor` | Tách module/class lớn mà không làm đổi hành vi hiện tại | *"Tách `PaymentService` ra khỏi `OrderController` an toàn"* |
| `dispatching-parallel-agents` | Chạy song song từ `2+` task độc lập không đụng chung state | *"Triển khai song song 2 module thông báo và báo cáo"* |
| `incremental-implementation` | Rollout thay đổi kiến trúc lớn qua nhiều pha kèm feature flag | *"Lên lộ trình chuyển đổi hệ thống xác thực từng giai đoạn"* |
| `security-audit` | Kiểm toán bảo mật toàn diện cho API, phân quyền, dữ liệu | *"Audit bảo mật cho luồng thanh toán và webhook"* |

---

## 3. Lộ Trình Mở Rộng (Scaling Path) & Các Mẫu Kết Hợp Skill

### 3.1 Kết Hợp Skills Khi Dự Án Lớn Dần
```text
Phase 1: < 50 files, 1–2 người
├── auto-guide → explore → writing-spec-simple → writing-plans → code → verification-before-completion
└── Quy trình nhẹ nhàng 3 bước, không cần 3 cổng formal

Phase 2: 50–200 files, 3–5 người
├── auto-guide → writing-spec-for-ai (Profile M) → writing-plans → code → code-review → verification-before-completion
├── Thêm: documentation-and-adrs (cho ADR) + safe-refactor (cho refactor an toàn)
└── Bắt buộc: docs/progress.md (bộ nhớ phiên C17) + docs/conflicts-and-bugs.md (sổ tay lỗi C18)

Phase 3: 200+ files, 5+ người
├── auto-guide → writing-spec-for-ai (Profile L + Packs: PK-API, PK-DB, PK-AUTH, PK-OBS, PK-SEC)
├── Thêm: using-git-worktrees + dispatching-parallel-agents (làm song song cô lập)
├── Thêm: incremental-implementation (rollout lớn) + security-audit (kiểm toán bảo mật)
└── Bắt buộc: 3 cổng duyệt formal (C02) + Phản biện chéo model (C26)
```

### 3.2 Bốn Mẫu Kết Hợp Phổ Biến (Integration Patterns)
1. **Sequential Chain (Luồng tuần tự):**
   `explore` → `writing-spec-simple` → `writing-plans` → `code` → `verification-before-completion`
2. **Parallel Dispatch (Thực thi song song):**
   `writing-plans` → `using-git-worktrees` → `dispatching-parallel-agents` → `code-review` → `verification-before-completion`
3. **Feedback & Bug-Ledger Loop (Vòng lặp sửa lỗi):**
   `code/test fail` → `systematic-debugging` → `fix` → ghi `docs/conflicts-and-bugs.md` (`C18`) → `verification-before-completion`
4. **Upgrade Path (Nâng cấp không mất dữ liệu):**
   `writing-spec-simple` → giữ nguyên `AGENTS.md` + `SPEC-*.md` → thêm `docs/specs/README.md`, `progress.md` (`C17`), `conflicts-and-bugs.md` (`C18`) → bật đủ 31 luật của `writing-spec-for-ai`.

---

## 4. Năm Quy Tắc Vàng & Quick Test Đánh Giá Spec

### 5 Quy Tắc Vàng
1. **KHÔNG** sửa bug trước khi tìm ra nguyên nhân gốc (`systematic-debugging`).
2. **KHÔNG** tự đoán khi yêu cầu mơ hồ — AI phải dừng lại hỏi (`C30`).
3. **LUÔN** chạy lệnh kiểm chứng và xuất bảng bằng chứng trước khi báo xong (`verification-before-completion`, `C29`).
4. **LUÔN** ghi lại bug/xung đột hợp đồng vào `docs/conflicts-and-bugs.md` (`C18`) để không lặp lại lỗi cũ.
5. **LUÔN** cập nhật Spec khi thay đổi hành vi code (`C11`).

### Quick Test 5 Câu (Biết Đang Đi Đúng Hướng)
1. AI có tự dừng lại hỏi khi spec mơ hồ thay vì tự bịa code không?
2. Code và test sinh ra có bám sát các `AC-x` trong Spec không?
3. Spec và `docs/conflicts-and-bugs.md` có được cập nhật khi code thay đổi không?
4. Team có duyệt Spec / Plan trước khi code không?
5. Bắt đầu phiên làm việc mới / onboarding người mới có nhanh hơn không?

> Nếu **`>= 4/5` câu trả lời là "Có"** → Dự án đang đi đúng hướng! Xem bảng **Monthly Health Check** chi tiết tại `writing-spec-simple/references/scaling-and-evaluation.md`.

## When NOT to Use

- Khi bạn đã biết chính xác tên skill cần gọi và muốn mở thẳng skill chuyên sâu đó
- Khi cần tra cứu danh sách đầy đủ hơn 50 skills theo từ khóa → mở `cheat-sheet`
