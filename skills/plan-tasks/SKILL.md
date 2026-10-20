---
name: plan-tasks
description: Chẻ một spec đã duyệt (Ready/As-built) hoặc tài liệu thiết kế thành đồ thị các task triển khai dạng lát cắt dọc (Tracer-Bullet Vertical Slices) kèm cạnh phụ thuộc (Blocked by) và danh sách Frontier có thể giao cho nhiều subagent làm song song trên git worktree riêng. Với thay đổi diện rộng (wide refactor), tự động lập chuỗi Expand → Migrate theo batch → Contract. Dùng ở Bước 7.5 (sau Cổng 3, trước khi code) hoặc khi người dùng nói "lập plan", "chia task", "chẻ ticket từ spec".
---

# Plan tasks — chẻ Spec thành Đồ thị Task & Tracer Bullets (Bước 7.5)

Đầu vào: `SPEC-<TÊN>` đã duyệt (và `DESIGN-<TÊN>` nếu có) + `docs/glossary.md`, `docs/decisions.md`.
Đầu ra: file kế hoạch `docs/plans/<nn>-<tên-spec>-plan.md` theo `templates/docs/plans/_plan-template.md` (hoặc xuất ra danh sách ticket cho issue tracker / `.scratch/<slug>/issues/`).

> Nguồn kế thừa: `to-tickets`, `implement-spec`, `planning-and-task-breakdown`, `migration`, `blast-radius`.

## 1. Nguyên tắc lát cắt dọc (Tracer-Bullet Vertical Slices)

Không chia task theo tầng ngang (*"Task 1: làm hết DB, Task 2: làm hết API, Task 3: làm hết UI"* — chỉ đến task cuối mới biết ghép vào bị lệch). Mọi task thông thường phải là một **Tracer Bullet**:

- **Đi xuyên đủ các tầng** (schema → logic/API → UI/CLI → test nghiệm thu `AC-ID`) cho một hành vi hẹp nhưng **chạy được trọn vẹn từ đầu tới cuối**.
- **Kích thước vừa một phiên sạch:** mỗi task sửa tối đa `~5` file, có thể hoàn tất và chứng minh xanh trong một phiên.
- **Ưu tiên dọn đường trước (Prefactoring):** *"Make the change easy, then make the easy change"* — nếu cần tách hàm/module để lát cắt chính dễ lắp, đặt task prefactoring lên đầu.

## 2. Ngoại lệ: Thay đổi diện rộng (Wide Blast Radius → Expand–Contract)

Khi một thay đổi cơ học (đổi tên cột, đổi chữ ký hàm/type dùng chung ở hàng chục nơi) làm vỡ hàng loạt file cùng lúc khiến lát cắt dọc không thể xanh:

1. **Task 1 — Expand:** Thêm cấu trúc/cột/hàm mới bên cạnh cái cũ; giữ cả hai cùng sống để CI vẫn xanh.
2. **Task 2..N — Migrate theo Batch:** Chuyển đổi các nơi gọi theo từng cụm thư mục/module (mỗi batch 1 task, `Blocked by: Task 1`).
3. **Task cuối — Contract:** Xoá cấu trúc/cột/hàm cũ sau khi không còn nơi nào gọi (`Blocked by: tất cả các task Migrate`).

## 3. Đồ thị phụ thuộc (Task Graph) & Frontier

Các task không phải danh sách phẳng mà là một **đồ thị có hướng (DAG)**:

- Mỗi task khai báo rõ **`Blocked by:`** (danh sách mã task phải xong trước; ghi `None` nếu làm được ngay).
- **Frontier (Mặt trận sẵn sàng):** tập hợp mọi task có toàn bộ `Blocked by` đã hoàn tất. Các task cùng nằm trên Frontier và không chạm trùng file có thể giao cho nhiều **implementer subagent** chạy song song trên các `git worktree` riêng biệt, chỉ truyền **context pointers** (link tới `SPEC-xx`, mã `AC-ID`, commit nền).

## 4. Mẫu trình bày một Task trong Plan

```markdown
### T-01: <Tên hành vi đầu-cuối ngắn gọn, đúng thuật ngữ glossary>
- **REQ / AC nghiệm thu:** `<TÊN>-R01`, `<TÊN>-AC01`, `<TÊN>-AC02`
- **Blocked by:** `None` (hoặc `T-01, T-02`)
- **Phạm vi file dự kiến (≤ 5 file):** `<đường dẫn>`
- **Lệnh kiểm chứng (Verify):** `<lệnh chạy đúng test chứa AC-ID>`
- **Trạng thái:** `[ ]`
```

## 5. Hỏi xác nhận trước khi chốt Plan

Trình bảng tóm tắt đồ thị task (`Mã | Tên hành vi | Blocked by | AC-ID`) và hỏi người dùng:
1. Độ mịn của từng lát cắt đã vừa chưa (có task nào cần gộp hoặc tách nhỏ hơn không)?
2. Các cạnh `Blocked by` đã tối giản chưa (tránh khoá tuần tự giả tạo)?

## Kiểm tra trước khi xong

- [ ] Mọi `REQ` và `AC` trong phạm vi của Spec đều thuộc về ít nhất một task.
- [ ] Mỗi task là một lát cắt dọc kiểm chứng được (hoặc một bước trong chuỗi Expand–Migrate–Contract).
- [ ] Mỗi task có `Blocked by` tường minh và có lệnh Verify gắn với `AC-ID`.
- [ ] Không có vòng lặp phụ thuộc trong đồ thị task.
