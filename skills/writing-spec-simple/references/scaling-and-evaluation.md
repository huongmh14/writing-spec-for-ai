# Kết Hợp Skills Khi Dự Án Mở Rộng & Đánh Giá Hiệu Quả Spec

Tài liệu tham chiếu cho `writing-spec-simple`, `auto-guide` và `writing-spec-for-ai`: hướng dẫn lộ trình mở rộng (Scaling Path), mẫu tích hợp (Integration Patterns), quy trình nâng cấp không mất dữ liệu (Zero-Loss Upgrade) và bộ chỉ số đánh giá sức khỏe Spec (Health Check).

---

## 1. Lộ Trình Mở Rộng (Scaling Path)

Khi dự án lớn dần theo số lượng file và quy mô thành viên, hệ thống skill nâng cấp theo 3 giai đoạn mà không phải viết lại tài liệu từ đầu:

```
Phase 1: < 50 files, 1–2 người (Khởi đầu nhanh / Prototype / Dự án nhỏ)
├── 1A (Mới bắt đầu): auto-guide → explore → writing-spec-simple → writing-plans → code → verification-before-completion
├── 1B (Cần hợp đồng chặt): writing-spec-for-ai (Profile S) + docs/conflicts-and-bugs.md (C18)
└── Quy trình: Duyệt từng bước nhẹ nhàng (3 bước), áp dụng 18 luật cốt lõi (references/base-simple.md)

Phase 2: 50–200 files, 3–5 người (Tăng trưởng / Team nhỏ)
├── Luồng chính: auto-guide → writing-spec-for-ai (Profile M) → writing-plans → code → code-review → verification-before-completion
├── Thêm skill: documentation-and-adrs (ghi ADR vào docs/decisions.md)
├── Thêm skill: safe-refactor (tái cấu trúc giữ nguyên hành vi, có test bảo vệ)
└── Bắt buộc: Bộ nhớ phiên docs/progress.md (C17) + Sổ tay lỗi & xung đột docs/conflicts-and-bugs.md (C18)

Phase 3: 200+ files, 5+ người (Hệ thống lớn / Production quy mô cao)
├── Luồng chính: auto-guide → writing-spec-for-ai (Profile L + Packs)
├── Bật Packs theo miền: PK-API, PK-DB, PK-AUTH, PK-OBS, PK-UI, PK-E2E, PK-SEC
├── Thêm skill: using-git-worktrees + dispatching-parallel-agents (chạy song song cô lập)
├── Thêm skill: incremental-implementation (rollout lớn có feature flag / canary / rollback)
├── Thêm skill: security-audit (kiểm toán bảo mật trước release)
└── Bắt buộc: 3 cổng duyệt formal (C02) + Phản biện chéo model/phiên sạch (C26) + Thẻ giải thích kỹ thuật (C31)
```

### Bảng So Sánh Nhanh 3 Giai Đoạn

| Tiêu chí | Phase 1 (`< 50` files, 1–2 người) | Phase 2 (`50–200` files, 3–5 người) | Phase 3 (`200+` files, 5+ người) |
|---|---|---|---|
| **Skill viết Spec** | `writing-spec-simple` *(hoặc Profile S)* | `writing-spec-for-ai` (**Profile M**) | `writing-spec-for-ai` (**Profile L + Packs**) |
| **Số luật áp dụng** | 18 luật cốt lõi (`base-simple.md`) | 31 luật đầy đủ (`base-kit.md`) | 31 luật + luật riêng của từng `PK-*` |
| **Cơ chế duyệt** | Duyệt trực tiếp sau mỗi bước (3 bước) | 3 cổng duyệt + `code-review` 2 trục | 3 cổng + phản biện chéo model (`C26`) |
| **Bộ nhớ & Sổ tay lỗi** | `AGENTS.md` + `decisions.md` *(khuyến khích `conflicts-and-bugs.md`)* | Bắt buộc `progress.md` (`C17`) + `conflicts-and-bugs.md` (`C18`) | Bắt buộc `C17` + `C18` + kiểm chứng tự động (`validate.ps1`) |

---

## 2. Các Mẫu Kết Hợp Skill (Integration Patterns)

### Pattern 1: Sequential Chain (Luồng tuần tự chuẩn cho tính năng mới)

```
explore → writing-spec-simple → writing-plans → code (hoặc tdd) → verification-before-completion
```

- **Khi nào dùng:** Lần đầu vào dự án hoặc làm tính năng mới từ đầu đến cuối.
- **Điểm bàn giao (Handoff):**
  1. `explore` xuất cấu trúc thư mục + entry points.
  2. `writing-spec-simple` chuẩn hoá `AGENTS.md` và `docs/specs/SPEC-xxx.md` (có `REQ-xxx`, `AC-x`).
  3. `writing-plans` chia `SPEC-xxx` thành các task nhỏ có bước kiểm thử.
  4. `verification-before-completion` chạy lệnh build/test thực tế và xuất bảng bằng chứng `AC-x` (`C29`).

### Pattern 2: Parallel Dispatch (Chia nhánh chạy song song cô lập)

```
writing-plans → using-git-worktrees → dispatching-parallel-agents → code-review → verification-before-completion
```

- **Khi nào dùng:** Có từ `2+` task/spec độc lập không chạm chung file hoặc state.
- **Quy tắc an toàn:**
  - Mỗi subagent chạy trên 1 git worktree/nhánh riêng hoặc phạm vi file tách biệt, khởi tạo phiên sạch (`fork_turns="none"`).
  - Trước khi merge, chạy `code-review` kiểm tra cả 2 trục: **Standards** (tuân thủ `AGENTS.md`/`CONSTRAINTS.md`) và **Spec** (đạt đủ `AC-x`).

### Pattern 3: Feedback & Bug-Ledger Loop (Vòng lặp sửa lỗi chống tái phát)

```
code / test fail → systematic-debugging → fix + regression test → ghi docs/conflicts-and-bugs.md (C18) → cập nhật spec (nếu thiếu AC) → verification-before-completion
```

- **Khi nào dùng:** Bất kỳ khi nào test đỏ, lỗi runtime, lệch hợp đồng (enum/API/DB/port), hoặc phải revert/hotfix.
- **Luật cứng:**
  - **Không đoán mò sửa bừa:** Phải qua Phase 1 của `systematic-debugging` để tìm nguyên nhân gốc (root cause).
  - **Không để lỗi lặp lại lần 2 (`C18`):** Ghi vào `docs/conflicts-and-bugs.md` (triệu chứng, nguyên nhân gốc, commit SHA, diện ảnh hưởng, lệnh chặn tự động).
  - **Đồng bộ Spec (`C10`, `C11`):** Nếu lỗi do spec thiếu ràng buộc hoặc hotfix làm đổi hành vi, phải bổ sung `AC` vào spec trong vòng 1 ngày làm việc.

### Pattern 4: Zero-Loss Upgrade Path (`writing-spec-simple` → `writing-spec-for-ai`)

```
writing-spec-simple ──(vượt 50 files / ≥ 3 người / cần Packs)──► writing-spec-for-ai (Profile M/L)
```

- **Khi nào cần nâng cấp:**
  1. Repo vượt quá `50` files hoặc có từ `3+` thành viên cùng sửa.
  2. Cần nhiều AI agents chạy song song (`dispatching-parallel-agents`).
  3. Xuất hiện lỗi lệch hợp đồng API/DB/Auth cần bật `PK-API`, `PK-DB`, `PK-AUTH`.
- **Quy trình nâng cấp 4 bước (Không mất dữ liệu cũ):**
  1. **Giữ nguyên 100% file đã viết:** `AGENTS.md`, `docs/decisions.md`, `docs/glossary.md`, và `docs/specs/SPEC-*.md` được giữ nguyên vì `writing-spec-simple` dùng chung cấu trúc mẫu với `writing-spec-for-ai`.
  2. **Bổ sung 3 file điều phối của bản đầy đủ:**
     - `docs/specs/README.md`: Bảng mục lục và trạng thái toàn bộ `SPEC-xxx` (`Draft` / `Ready` / `In progress` / `Done`).
     - `docs/progress.md` (`C17`): Điểm dừng phiên hiện tại và quyền thực thi theo đợt (`C30`).
     - `docs/conflicts-and-bugs.md` (`C18`): Sổ tay lỗi và xung đột hợp đồng.
  3. **Nâng cấp bộ luật từ 18 → 31 luật (`base-simple.md` → `base-kit.md`):**
     - Kích hoạt 3 cổng duyệt (`C02`), quy trình đổi spec đã chạy (`C09`), ngoại lệ hotfix 1 ngày (`C10`), phản biện chéo model/phiên sạch (`C26`) và thẻ giải thích kỹ thuật (`C31`).
  4. **Chạy kiểm chứng tự động:**
     - Chạy `scripts/validate.ps1` để kiểm tra toàn bộ ID (`SPEC-xxx`, `AC-x`, `D-xx`), độ dài dòng và liên kết chéo.

---

## 3. Biết Đi Đúng Hướng & Cải Thiện Spec

### 3.1 Dấu Hiệu Đi Đúng Hướng (Positive Signals)

- ✅ **Spec có cấu trúc sống & kiểm chứng được:**
  - `AGENTS.md` có lệnh `build` / `test` / `lint` chạy được thật (`C19`).
  - Mỗi spec có mã định danh (`SPEC-001`), yêu cầu rõ ràng và tiêu chí nghiệm thu (`AC-1`, `AC-2`) theo dạng `GIVEN / WHEN / THEN` gắn với tên hàm test (`C04`).
  - Trạng thái spec được cập nhật đúng vòng đời (`Draft` → `Ready` → `In progress` → `Done`).
  - Quyết định kiến trúc được ghi vào `docs/decisions.md` (`D-xx`), lỗi lịch sử được ghi vào `docs/conflicts-and-bugs.md` (`C18`).
- ✅ **AI làm việc kỷ luật, không đoán mò:**
  - AI tự đọc `AGENTS.md`, `docs/decisions.md`, `docs/specs/` trước khi sửa code (`C01`).
  - Khi gặp yêu cầu mơ hồ hoặc thiếu dữ kiện, AI dừng lại hỏi hoặc nêu giả định chờ duyệt (`C30`), tuyệt đối không tự bịa requirement.
  - Khi báo xong, AI luôn xuất bảng bằng chứng test (`input / output / mock`, `C29`), không chỉ nói suông `"All tests passed"`.
- ✅ **Team đồng thuận & ít ma sát:**
  - Duyệt spec trước khi code; duyệt code đối chiếu với spec (`code-review` trục Spec).
  - Đổi hành vi thì cập nhật spec trước (`C09`); hotfix khẩn cấp thì cập nhật bù spec và `conflicts-and-bugs.md` trong 1 ngày (`C10`, `C18`).
- ✅ **Chỉ số chất lượng cải thiện:**
  - Tỷ lệ bug hồi quy và lệch hợp đồng giảm rõ rệt.
  - Thời gian onboarding người mới hoặc phiên AI mới giảm mạnh nhờ `AGENTS.md` + `progress.md`.
  - Code review tập trung vào thiết kế/kiến trúc thay vì bắt lỗi lệch logic cơ bản.

### 3.2 Dấu Hiệu Cảnh Báo (Negative Signals & Cách Khắc Phục)

| Nhóm triệu chứng | Biểu hiện cụ thể | Cách khắc phục ngay |
|---|---|---|
| ❌ **Spec rỗng / Lệch thực tế** | Spec chỉ có placeholder `[TODO]`; code đã đổi nhưng spec giữ nguyên; AI bỏ qua spec và code theo cảm tính. | Chạy `scripts/validate.ps1`; áp dụng luật `C01` (Spec > Code) và `C11` (sửa hành vi bắt buộc sửa Spec trong cùng PR). |
| ❌ **Spec quá nặng (Over-engineered)** | Spec dài hàng trăm dòng văn xuôi, đi sâu vào chi tiết cài đặt (HOW thay vì WHAT); viết spec tốn thời gian hơn viết code. | Rút gọn về đúng hành vi quan sát được (`GIVEN/WHEN/THEN`); chuyển luật lặp lại sang linter/test (`CONSTRAINTS.md`), xoá văn xuôi thừa. |
| ❌ **Spec không được dùng (Dead Docs)** | Code mới không gắn mã `[SPEC-xxx]`; AI không đọc spec khi bắt đầu task; review PR không đối chiếu `AC-x`. | Kiểm tra con trỏ điều kiện trong `AGENTS.md` (`C24`: *"Khi chạm X → đọc Y"*); dùng `code-review` trục Spec trước khi merge. |
| ❌ **Quy trình quá cồng kềnh (High Friction)** | Dự án nhỏ (`< 50` files) nhưng bắt chạy đủ 3 cổng formal + sub-agents gây nghẽn hàng đợi review, khiến team lách luật. | Hạ xuống **Phase 1 (`writing-spec-simple` hoặc `Profile S`)**; chỉ bật 3 cổng formal khi dự án thực sự sang Phase 2/3. |

---

## 4. Bảng Kiểm Tra Sức Khỏe Định Kỳ (Monthly Health Check)

Đánh giá định kỳ **1 tháng/lần** (hoặc sau mỗi cột mốc release):

| Metric | Good (Tốt) | Warning (Cần chú ý) | Bad (Báo động) | Cách đo thực tế trong Repo |
|---|---|---|---|---|
| **1. Spec coverage** | `> 80%` features có spec | `50–80%` | `< 50%` | Tỷ lệ tính năng/PR mới có file `SPEC-xxx` hoặc cập nhật `AC-x`. |
| **2. Spec-to-code sync** | `< 5%` lệch | `5–20%` lệch | `> 20%` lệch | Chạy `scripts/validate.ps1` + kiểm tra số `AC [x]` có test thực tế khớp hành vi hiện tại. |
| **3. AI spec adherence** | `> 90%` đúng spec | `70–90%` | `< 70%` | Tỷ lệ PR do AI code đạt trục Spec trong `code-review` ngay lần đầu và có bảng bằng chứng `C29`. |
| **4. Bug & Regression rate** | Giảm so với tháng trước | Không đổi | Tăng | Số lỗi mới / lỗi tái phát ghi nhận trong `docs/conflicts-and-bugs.md` (`C18`). |
| **5. Onboarding / Context time** | Giảm `> 50%` | Giảm `20–50%` | Không giảm | Thời gian (hoặc số lượt prompt) để thành viên mới / phiên AI mới hiểu repo và hoàn thành task đầu tiên. |
| **6. Team satisfaction** | `> 4/5` | `3–4/5` | `< 3/5` | Khảo sát nhanh các thành viên về độ rõ ràng và hữu ích của `AGENTS.md` + `docs/specs/`. |
| **7. Process friction** | Low (`15–30p`/spec) | Medium | High (`> 2h`/spec) | Thời gian chờ duyệt spec; nếu friction `High` ở dự án nhỏ → rút gọn về `writing-spec-simple`. |

---

## 5. Kế Hoạch Hành Động Định Kỳ (Periodic Action Plan)

### Hàng tuần (Weekly — 5 phút)
- [ ] **Đồng bộ Spec:** Các feature/hotfix trong tuần đã cập nhật trạng thái `AC` (`[ ]` → `[x]`) và `docs/conflicts-and-bugs.md` chưa?
- [ ] **Kỷ luật AI:** AI có đọc `AGENTS.md` + `SPEC-xxx` trước khi code và xuất bảng bằng chứng test (`C29`) trước khi báo xong không?
- [ ] **Gỡ vướng sớm:** Có bug nào xảy ra do spec thiếu trường hợp biên (edge case) hoặc viết mơ hồ không? Nếu có, bổ sung ngay `AC` mới.

### Hàng tháng (Monthly — 15 phút)
- [ ] **Chạy Health Check:** Chấm bảng 7 chỉ số ở Mục 4 và chạy `scripts/skill-health-check.sh` + `scripts/validate.ps1`.
- [ ] **Đánh giá điều hướng (`auto-guide`):** AI tự động đề xuất skill có đúng tình huống không? Có chỗ nào user vẫn phải tự đoán skill không?
- [ ] **Thu thập phản hồi team:** Mục nào trong `AGENTS.md` hoặc `SPEC` bị dài dòng, không ai đọc → cắt bỏ hoặc chuyển thành lệnh kiểm tự động.

### Hàng quý (Quarterly — 30 phút)
- [ ] **Đánh giá nâng cấp (Scale-up):** Dự án đã vượt `50` files hoặc `3+` người chưa? Có cần nâng cấp từ `writing-spec-simple` lên `writing-spec-for-ai` (Profile M/L) theo **Pattern 4** không?
- [ ] **Đánh giá Domain Packs:** Có cần bật thêm Pack chuyên biệt (`PK-API`, `PK-DB`, `PK-AUTH`, `PK-OBS`, `PK-UI`, `PK-E2E`, `PK-SEC`) không?
- [ ] **Vệ sinh bộ nhớ dự án (`C17`):** Lưu trữ lịch sử cũ trong `docs/progress.md` sang `docs/progress-archive/` để giữ `progress.md <= 5 KB`.

---

## 6. Quick Test (5 Câu Tự Đánh Giá Trong 1 Phút)

Dùng 5 câu hỏi **Có / Không** dưới đây để kiểm tra nhanh bất kỳ lúc nào:

1. **Khi gặp yêu cầu mơ hồ hoặc thiếu dữ kiện, AI có dừng lại hỏi (hoặc ghi giả định chờ duyệt `C30`) thay vì tự đoán/bịa code không?**
   - `Có` → **Good** (AI tuân thủ ranh giới hiểu biết, không bịa requirement).
   - `Không` (AI tự đoán/bịa) → **Bad** (Cần siết lại luật không đoán mò trong `AGENTS.md`).
2. **Code và test sinh ra có bám sát các tiêu chí nghiệm thu (`AC-x`) trong Spec không?**
   - `Có` → **Good**
   - `Không` → **Bad** (Spec không được AI đọc hoặc `AC` viết quá chung chung, thiếu `GIVEN/WHEN/THEN`).
3. **Khi thay đổi hành vi code hoặc hotfix, Spec và `docs/conflicts-and-bugs.md` có được cập nhật đi kèm không?**
   - `Có` → **Good**
   - `Không` → **Bad** (Spec đang bị lão hoá thành tài liệu chết — vi phạm `C10`/`C11`/`C18`).
4. **Team (hoặc bạn) có duyệt Spec / Plan trước khi cho AI viết code hàng loạt không?**
   - `Có` → **Good**
   - `Không` → **Bad** (Bỏ qua cổng duyệt khiến chi phí sửa code sai lớn gấp nhiều lần sửa spec).
5. **Việc bắt đầu một phiên AI mới (hoặc thêm người mới vào dự án) có nhanh và ít phải giải thích lại từ đầu hơn trước không?**
   - `Có` → **Good**
   - `Không` → **Bad** (`AGENTS.md` hoặc `docs/progress.md` chưa cô đọng đúng thông tin cốt lõi).

### Kết luận Quick Test:
- **`4–5/5` câu trả lời "Có":** Hệ thống Spec & Skills đang vận hành rất tốt, giữ nguyên nhịp hiện tại.
- **`3/5` câu trả lời "Có":** Đang đi đúng hướng nhưng cần khắc phục ngay 1–2 điểm "Không" theo bảng Mục 3.2.
- **`0–2/5` câu trả lời "Có":** Cần dừng lại điều chỉnh — kiểm tra xem Spec có đang quá nặng (hạ về `writing-spec-simple`) hoặc quá sơ sài (bổ sung `AGENTS.md` + `AC` có test).
