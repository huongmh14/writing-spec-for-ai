---
name: plan-tasks
description: Dùng ở Bước 7.5 (sau Cổng 3, trước khi code) hoặc khi người dùng nói "lập plan", "chia task", "chẻ ticket từ spec". Chuyển hoá spec/design đã duyệt thành đồ thị task triển khai dạng lát cắt dọc (Tracer-Bullet Vertical Slices) hoặc chuỗi Expand–Migrate–Contract có cạnh phụ thuộc (Blocked by) rõ ràng.
---

# Plan tasks — chẻ Spec thành Đồ thị Task & Tracer Bullets (Bước 7.5)

Đầu vào: `SPEC-<TÊN>` đã duyệt (và `DESIGN-<TÊN>` nếu có) + `docs/glossary.md`, `docs/decisions.md`.
Đầu ra: file kế hoạch `docs/plans/<nn>-<tên-spec>-plan.md` theo `templates/docs/plans/_plan-template.md` (hoặc xuất ra danh sách ticket cho issue tracker / `.scratch/<slug>/issues/`).

Profile S dùng `docs/spec.md`/README và block đợt trong `AGENTS.md`; không cần plan/progress riêng, vẫn ghi hành vi/AC/kiểm chứng/điểm dừng.

**Quyền thực thi (**Quyền thực thi theo đợt**, `C30`):** `Ready` và plan chỉ chốt yêu cầu/công việc dự kiến. Đợt hiện tại ở `docs/progress.md` phải ghi chỉ dẫn thật của người dùng, SPEC/task/AC, vùng file, phần loại trừ và điểm dừng. Mặc định chưa nêu ranh giới: **1 SPEC + 1 task**, làm → kiểm → báo cáo → dừng. Yêu cầu rõ batch/toàn spec hữu hạn thì ghi và làm đủ phạm vi ấy; không hỏi lại từng task. Chỉ dẫn hiện hành của người dùng được ưu tiên; AI không tự cấp quyền khi sửa block.

> Gốc ý tưởng (skill tham khảo nội bộ, không phải bằng chứng): `to-tickets`, `implement-spec`, `planning-and-task-breakdown`, `migration`, `blast-radius`. Khái niệm mượn: Tracer Bullet (Hunt & Thomas, *The Pragmatic Programmer*); Expand–Migrate–Contract (Parallel Change — Danilo Sato, martinfowler.com/bliki/ParallelChange.html). Nghĩa ngắn: [glossary](../../references/glossary.md).

## 1. Nguyên tắc lát cắt dọc (Tracer Bullet — lát mỏng chạy xuyên mọi tầng)

Không chia task theo tầng ngang (*"Task 1: làm hết DB, Task 2: làm hết API, Task 3: làm hết UI"* — chỉ đến task cuối mới biết ghép vào bị lệch). Mọi task thông thường phải là một **Tracer Bullet**:

- **Đi xuyên đủ các tầng** (schema → logic/API → UI/CLI → test nghiệm thu `AC-ID`) cho một hành vi hẹp nhưng **chạy được trọn vẹn từ đầu tới cuối**.
- **Kích thước vừa một phiên sạch:** khoảng `5` file là dự kiến; task có thể hoàn tất và kiểm chứng trong một phiên. Sửa hàm chung/caller cần thiết trong cùng hành vi được phép; báo tác động, không tự thêm hành vi.
- **Ưu tiên dọn đường trước (Prefactoring):** *làm cho thay đổi trở nên dễ, rồi mới làm thay đổi dễ đó* — nếu cần tách hàm/module để lát cắt chính dễ lắp, đặt task prefactoring lên đầu.

## 2. Ngoại lệ: thay đổi lan rộng nhiều file → Expand–Migrate–Contract

Khi một thay đổi cơ học (đổi tên cột, đổi chữ ký hàm/type dùng chung ở hàng chục nơi) làm vỡ hàng loạt file cùng lúc khiến lát cắt dọc không thể xanh:

1. **Task 1 — Expand (Mở rộng):** Thêm cấu trúc/cột/hàm mới bên cạnh cái cũ; giữ cả hai cùng sống để CI vẫn xanh.
2. **Task 2..N — Migrate (Chuyển dữ liệu/nơi gọi) theo batch:** Chuyển các nơi gọi theo từng cụm thư mục/module, kiểm chứng ngay trong từng batch (mỗi batch 1 task, `Blocked by: Task 1`).
3. **Task cuối — Contract (Thu gọn):** Xoá cấu trúc/cột/hàm cũ sau khi không còn nơi nào gọi (`Blocked by: tất cả các task Migrate`).

## 3. Đồ thị phụ thuộc (Task Graph) & task sẵn sàng

Các task không phải danh sách phẳng mà là một **đồ thị có hướng (DAG)**:

- Mỗi task khai báo rõ **`Blocked by:`** (danh sách mã task phải xong trước; ghi `None` nếu làm được ngay).
- **Task sẵn sàng:** mọi task trong `Blocked by` đã hoàn tất; đây chỉ là quan hệ phụ thuộc, không cấp quyền bắt đầu. Subagent chỉ chạy phần thuộc đợt đã giao, dùng context pointers (SPEC/AC, commit nền, link đợt); không tự chọn task/spec kế. Song song các task khác chỉ khi batch đó đã được người dùng giao rõ.

## 4. Mẫu trình bày một Task & Bảng Bằng chứng Kiểm thử (**Bằng chứng test hiển thị**, `C29`)

Mỗi task không chỉ ghi lệnh chạy test mà phải khai báo rõ **Ma trận test dự kiến trước khi code** và khi hoàn tất phải điền **Bảng bằng chứng chạy test** (`C29`) để lập trình viên thấy rõ AI đã bơm dữ liệu gì và có dùng mock hay không:

```markdown
### T-01: <Tên hành vi đầu-cuối ngắn gọn, đúng thuật ngữ glossary>
- **REQ / AC nghiệm thu:** `<TÊN>-R01`, `<TÊN>-AC01`, `<TÊN>-AC02`
- **Blocked by:** `None` (hoặc `T-01, T-02`)
- **Phạm vi file dự kiến (~5 file):** `<đường dẫn>`
- **Kế hoạch & Bằng chứng Kiểm thử Minh bạch (`C29`):**
  | AC-ID | Kịch bản | Input dự kiến | Output & Tác dụng phụ kỳ vọng | Tầng & Độ thật (`0 Mock` / `Mock gì`) | Trạng thái chạy |
  |---|---|---|---|---|---|
  | `<TÊN>-AC01` | <nhánh chính> | `<payload/tham số>` | `<HTTP 200 / DB row / DOM>` | `integration` (`0 Mock`) | `[ ]` |
- **Lệnh kiểm chứng (Verify):** `<lệnh chạy đúng test chứa AC-ID>`
- **Điểm dừng:** `<hành vi demo được / AC hoàn tất; không tự chuyển task>`
- **Trạng thái:** `[ ]`
```

## 5. Trình plan và xác định đợt được giao

Trình bảng `Mã | Hành vi nhìn thấy | Blocked by | AC-ID | Cách demo`. Người dùng chọn kết quả/phạm vi; AI chịu trách nhiệm kiểm cạnh phụ thuộc và tính khả thi bằng code/test, không bắt người dùng duyệt chi tiết kỹ thuật ngoài chuyên môn.

- Đã được giao phạm vi rõ thì ghi đợt và tiếp tục, không hỏi lại. Chưa có chỉ dẫn triển khai thì chỉ giao plan; plan được duyệt không tự cho phép chạy toàn bộ.
- Khi thực thi hết đợt: cập nhật `Chờ kiểm chứng`, báo **kết quả · demo/bằng chứng · điều chưa kiểm chứng · điểm đã dừng**, rồi dừng. `[~]` chưa kiểm chứng không đủ chuyển spec `Done`.
- Đổi hành vi/spec/rủi ro bảo mật hoặc schema ngoài phạm vi đã giao thì cập nhật phạm vi trước khi làm phần đó; không chặn phần độc lập được giao.

## Kiểm tra trước khi xong

- [ ] Mọi `REQ` và `AC` trong phạm vi của Spec đều thuộc về ít nhất một task.
- [ ] Mỗi task là một lát cắt dọc kiểm chứng được (hoặc một bước trong chuỗi Expand–Migrate–Contract).
- [ ] Mỗi task có `Blocked by` tường minh và có lệnh Verify gắn với `AC-ID`.
- [ ] Không có vòng lặp phụ thuộc trong đồ thị task.
- [ ] Plan link tới một đợt hiện tại trong `docs/progress.md`; không tự duyệt batch/task sẵn sàng hoặc suy quyền từ HANDOFF cũ.
