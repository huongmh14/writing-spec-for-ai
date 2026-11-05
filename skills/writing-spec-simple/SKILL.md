---
name: writing-spec-simple
description: Phiên bản đơn giản hóa của writing-spec-for-ai - dành cho người mới bắt đầu hoặc dự án nhỏ (< 50 files) muốn chuẩn hoá docs cho AI agent nhanh chóng. AI tự động đề xuất khi phát hiện signal phù hợp.
license: MIT
---

# Writing Spec Simple - Chuẩn Hoá Docs Nhanh Cho Dự Án Nhỏ

**Mục tiêu:** Tạo bộ tài liệu gọn nhẹ (`AGENTS.md`, `docs/decisions.md`, `docs/specs/SPEC-xxx.md`, `docs/conflicts-and-bugs.md`) giúp AI agent hiểu đúng dự án và code chính xác mà không cần quy trình 3 cổng phức tạp.

**Khi nào kích hoạt:**
- Lần đầu làm việc với dự án mới hoặc repo chưa có `AGENTS.md`
- Dự án quy mô nhỏ (`< 50` files, 1–2 người) cần chuẩn hoá tài liệu trong 15–30 phút
- User nói: *"viết AGENTS.md"*, *"chuẩn hoá docs cho AI"*, *"viết spec đơn giản"*

## When NOT to Use

- Chỉ cần sửa 1 bug đơn lẻ hoặc thay đổi nhỏ đã rõ vị trí → dùng `systematic-debugging` hoặc sửa trực tiếp
- Dự án đã có `AGENTS.md` và `docs/specs/` đầy đủ, hợp lệ
- Dự án lớn (`>= 50` files, team `>= 3` người, hoặc cần chạy nhiều sub-agents song song) → dùng `writing-spec-for-ai` (Profile M/L)

---

## 1. Detection Rules & Mẫu Đề Xuất Tự Động

| Rule | Tín hiệu phát hiện (Signals) | Hành động của AI |
|---|---|---|
| **Rule 1: Lần đầu vào project** | User nói *"lần đầu vào project"*, *"xem giúp repo này"*, chưa có `AGENTS.md` | Đề xuất chuỗi: `explore` → `writing-spec-simple` |
| **Rule 2: Phân tầng theo quy mô** | Đếm số file code trong repo (bỏ qua `node_modules`, `.git`, `dist`, `build`) | `< 50` files → `writing-spec-simple`<br>`>= 50` files → `writing-spec-for-ai` |
| **Rule 3: Yêu cầu trực tiếp** | User nói *"viết AGENTS.md"*, *"chuẩn hoá docs"*, *"tạo spec cho dự án mới"* | Chạy ngay Bước 1 của `writing-spec-simple` |

### AI Response Template Khi Đề Xuất

```text
=== Tình Huống Của Bạn ===
Phát hiện: Dự án chưa có AGENTS.md / tài liệu chuẩn cho AI
Quy mô: <N> files (< 50 files → phù hợp bản rút gọn)

=== Đề Xuất Của Tôi ===
Skill: writing-spec-simple
Lý do:
- Chuẩn hoá AGENTS.md và Spec cơ bản trong 15–30 phút để AI không đoán mò khi code.
- Kế thừa cấu trúc từ writing-spec-for-ai nên sau này dự án lớn lên có thể nâng cấp không mất dữ liệu.

=== Bước Tiếp Theo ===
Tôi sẽ thực hiện 3 bước (dừng chờ bạn duyệt sau mỗi bước):
1. Khảo sát nhanh dự án (5 phút)
2. Đề xuất danh sách file docs cần tạo (3 phút)
3. Viết từng file từ templates/ (10–20 phút)

Bạn đồng ý bắt đầu Bước 1 chứ? (Hoặc chọn bỏ qua nếu muốn làm việc ngay)
```

---

## 2. Quy Trình 3 Bước Đơn Giản

### Bước 1: Khảo Sát Dự Án (5–10 phút)
AI tự quét nhanh cấu trúc thư mục, `package.json` / `pyproject.toml` / `Cargo.toml` và chỉ hỏi user những thông tin không thể tự đọc từ code:
- Mục tiêu cốt lõi của dự án là gì?
- Lệnh `build`, `test`, `lint`, `dev` chuẩn đang dùng là gì?
- Có quy tắc ngầm hoặc giới hạn kỹ thuật nào bắt buộc tuân thủ không?

> **Điểm dừng 1:** Tóm tắt kết quả khảo sát và chờ user xác nhận trước khi sang Bước 2.

### Bước 2: Đề Xuất Cấu Trúc Docs (3–5 phút)
AI đề xuất danh sách file tối thiểu dựa trên nhu cầu thực tế:
- `AGENTS.md` *(Bắt buộc)* — Bản đồ dự án, lệnh chạy máy, thứ tự nguồn sự thật (`C01`), quy tắc làm việc.
- `docs/decisions.md` *(Khuyến nghị)* — Ghi lại các quyết định kỹ thuật đã chốt (`D-01`, `D-02`).
- `docs/specs/SPEC-001-<ten-tinh-nang>.md` *(Khi có tính năng cần làm)* — Yêu cầu và tiêu chí nghiệm thu (`AC-1`, `AC-2`).
- `docs/conflicts-and-bugs.md` *(Khuyến nghị, `C18`)* — Sổ tay ghi lại lỗi và xung đột hợp đồng để AI không lặp lại lỗi cũ.
- `docs/glossary.md` & `CONSTRAINTS.md` *(Tùy chọn)* — Chỉ tạo khi dự án có thuật ngữ nghiệp vụ riêng hoặc ràng buộc hạ tầng đặc biệt.

> **Điểm dừng 2:** Chờ user duyệt danh sách file trước khi viết.

### Bước 3: Viết Từng File & Kiểm Chứng (10–20 phút)
- Dùng mẫu chuẩn trong thư mục `templates/` (`AGENTS.simple.md`, `SPEC.simple.md`, `decisions.simple.md`).
- **Luật thực thi (`C30`):** Mỗi lượt chỉ viết **1 file**, dừng lại để user xem và duyệt rồi mới viết file tiếp theo.
- **Mọi tiêu chí nghiệm thu (`AC`) phải kiểm thử được (BDD `GIVEN / WHEN / THEN`):**

```markdown
### AC-1: Đăng nhập thành công với thông tin hợp lệ
- **GIVEN** tài khoản `user@example.com` đã kích hoạt trong hệ thống
- **WHEN** gửi `POST /api/login` với email và mật khẩu đúng
- **THEN** trả về HTTP `200`, body chứa `accessToken` (JWT) và ghi test `test_login_success_AC_1`
```

- **Sau khi viết xong:** Chạy thử các lệnh trong `AGENTS.md` (`C19`) và kiểm tra thử 1 yêu cầu mẫu (`C22`) để chắc chắn tài liệu hoạt động tốt.

---

## 3. Quy Tắc Cốt Lõi Khi Làm Việc Với Spec (`base-simple.md`)

Xem đầy đủ 19 luật kế thừa tại [`references/base-simple.md`](references/base-simple.md). Tóm tắt 5 nguyên tắc quan trọng nhất:
1. **Thứ tự nguồn sự thật (`C01`):** `docs/decisions.md` > `docs/specs/` > `docs/conflicts-and-bugs.md` > `AGENTS.md` > Code hiện có.
2. **Không đoán thay dữ kiện (`C30`):** Khi spec mơ hồ hoặc thiếu dữ kiện, AI bắt buộc phải dừng lại hỏi, không tự bịa requirement.
3. **Bằng chứng test hiển thị (`C13`, `C29`):** Trước khi báo xong, AI phải chạy test và xuất bảng `AC / Input / Output / Mock`, không chỉ báo `"All tests passed"`.
4. **Sổ tay lỗi & xung đột (`C18`):** Mọi bug, hotfix, hoặc lệch hợp đồng (enum/API/DB/port) phải ghi vào `docs/conflicts-and-bugs.md` kèm commit SHA và lệnh chặn.
5. **Đồng bộ tài liệu (`C11`):** Đổi hành vi code thì phải cập nhật `SPEC-xxx.md` trong cùng đợt làm việc.

---

## 4. Lộ Trình Mở Rộng (Scaling Path) & Nâng Cấp Lên Bản Đầy Đủ

Xem chi tiết tại [`references/scaling-and-evaluation.md`](references/scaling-and-evaluation.md).

### 4.1 Ba Giai Đoạn Mở Rộng Theo Quy Mô Dự Án
- **Phase 1 (`< 50` files, 1–2 người):** `auto-guide` → `explore` → `writing-spec-simple` → `writing-plans` → code → `verification-before-completion` (quy trình nhẹ nhàng, không cần 3 cổng formal).
- **Phase 2 (`50–200` files, 3–5 người):** Nâng lên `writing-spec-for-ai` (**Profile M**) + `documentation-and-adrs` + `safe-refactor` + bắt buộc `docs/progress.md` (`C17`) và `docs/conflicts-and-bugs.md` (`C18`).
- **Phase 3 (`200+` files, 5+ người):** Nâng lên `writing-spec-for-ai` (**Profile L + Packs**: `PK-API`, `PK-DB`, `PK-AUTH`, `PK-OBS`, `PK-SEC`) + `using-git-worktrees` + `dispatching-parallel-agents` + `incremental-implementation` + `security-audit`.

### 4.2 Quy Trình Nâng Cấp Không Mất Dữ Liệu (`writing-spec-simple` → `writing-spec-for-ai`)
Khi dự án vượt `50` files hoặc có từ `3+` thành viên, nâng cấp theo 4 bước:
1. **Giữ nguyên 100% file hiện có:** `AGENTS.md`, `docs/decisions.md`, `docs/specs/SPEC-*.md` giữ nguyên vì đã dùng chung khung template chuẩn.
2. **Thêm file điều phối:** Tạo `docs/specs/README.md` (bảng theo dõi trạng thái Spec/AC), `docs/progress.md` (`C17`) và `docs/conflicts-and-bugs.md` (`C18`).
3. **Bật đủ 31 luật (`base-kit.md`):** Kích hoạt 3 cổng duyệt (`C02`), phản biện chéo model/phiên sạch (`C26`) và thẻ giải thích kỹ thuật (`C31`).
4. **Kiểm chứng tự động:** Chạy `scripts/validate.ps1` để xác nhận toàn bộ ID và cấu trúc hợp lệ.

---

## 5. Quick Test 5 Câu: Biết Đang Đi Đúng Hướng

Tự kiểm tra nhanh sau mỗi tuần (chi tiết bảng **Monthly Health Check 7 chỉ số** xem tại [`references/scaling-and-evaluation.md`](references/scaling-and-evaluation.md)):

1. Khi gặp điểm mơ hồ, AI có dừng lại hỏi thay vì tự bịa code không? (`Có` = Good)
2. Code và test sinh ra có bám sát các `AC-x` trong Spec không? (`Có` = Good)
3. Khi sửa hành vi code hoặc hotfix, Spec và `docs/conflicts-and-bugs.md` có được cập nhật đi kèm không? (`Có` = Good)
4. Bạn/team có duyệt Spec & Plan trước khi cho AI viết code hàng loạt không? (`Có` = Good)
5. Bắt đầu phiên AI mới (hoặc thêm người mới) có nhanh hơn rõ rệt nhờ `AGENTS.md` không? (`Có` = Good)

> **Kết quả:** Đạt **`>= 4/5` câu "Có"** là đang đi đúng hướng; nếu **`<= 3/5`** hãy mở [`references/scaling-and-evaluation.md`](references/scaling-and-evaluation.md) mục 3.2 để chỉnh lại ngay.

---

## Cấu Trúc Thư Mục Của Skill

- `templates/AGENTS.simple.md` — Mẫu `AGENTS.md` kế thừa từ `writing-spec-for-ai`
- `templates/SPEC.simple.md` — Mẫu Spec tính năng có `REQ`, `AC` (`GIVEN/WHEN/THEN`)
- `templates/decisions.simple.md` — Mẫu sổ quyết định kiến trúc (`D-xx`)
- `references/base-simple.md` — 19 luật cốt lõi rút gọn từ `base-kit.md`
- `references/scaling-and-evaluation.md` — Scaling Path, 4 Integration Patterns, Health Check 7 metrics & Kế hoạch định kỳ
