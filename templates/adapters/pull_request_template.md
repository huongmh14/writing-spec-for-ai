<!-- Đặt tại .github/pull_request_template.md. Tiêu đề: <type>(<scope>): <mô tả> [SPEC-XXX] -->

## Spec liên quan

<!-- SPEC-XXX — XXX-R01, XXX-AC01; CHG-xx nếu có -->

Đợt thực thi (quyền thực thi theo đợt): <RUN-ID, link progress; phạm vi đã giao và điểm dừng>.

## Thay đổi

## Cách kiểm thử & Bảng bằng chứng chạy test (Visible Test Execution Ledger)

<!-- Không chỉ ghi "đã chạy test pass". Bắt buộc điền bảng dưới đây để người review nhìn thấy rõ từng AC đã được bơm dữ liệu gì và có dùng mock hay không. -->

| Mã AC | Kịch bản đã chạy | Đầu vào đã bơm | Kết quả & tác dụng phụ thực tế (output / DB / DOM) | Tầng & độ thật (`0 Mock` hay mock thành phần nào) | Kết quả |
|---|---|---|---|---|---|
| `XXX-AC01` | | | | `integration` — **0 Mock** | ✅ PASS |

## Checklist

- [ ] Test mới chứa AC-ID trong tên và đã khai báo rõ `0 Mock` / `Mock gì` trong bảng bằng chứng ở trên
- [ ] Lint, typecheck, test xanh
- [ ] AC `[x]` có bằng chứng; `[~]` ghi lý do/cách đóng và không dùng để chuyển `Done`
- [ ] Đổi schema/API công khai: có mục trong `docs/upgrade/`
- [ ] Thay đổi liên quan bảo mật đã nêu rõ ở "Thay đổi"
- [ ] `docs/progress.md` có dòng mới
- [ ] Điều chưa chứng minh và giới hạn mock được nêu rõ (nguồn & giới hạn hiểu biết); kỳ vọng do AI tự viết thì ghi rõ, ưu tiên ví dụ người dùng đưa; xong phạm vi thì dừng, không tự nhận task kế

<!-- ===== Chỉ điền khi PR vào nhánh môi trường (staging/production). Xoá với PR khác. ===== -->

## Tag/bản đã kiểm ở môi trường trước

## Migration trong đợt

<!-- "Không có" nếu không có -->

## Kế hoạch rollback
