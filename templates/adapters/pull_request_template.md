<!-- Đặt tại .github/pull_request_template.md. Tiêu đề: <type>(<scope>): <mô tả> [SPEC-XXX] -->

## Spec liên quan

<!-- SPEC-XXX — XXX-R01, XXX-AC01; CHG-xx nếu có -->

Đợt thực thi (`C30`): <RUN-ID, link progress; phạm vi đã giao và điểm dừng>.

## Thay đổi

## Cách kiểm thử & Bảng Bằng chứng Chạy Test (`Visible Test Execution Ledger` — `C29`)

<!-- Không chỉ ghi "đã chạy test pass". Bắt buộc điền bảng dưới đây để người review nhìn thấy rõ từng AC đã được bơm dữ liệu gì và có dùng mock hay không. -->

| Mã AC | Kịch bản đã chạy | Đầu vào đã bơm (`Input`) | Kết quả & Tác dụng phụ thực tế (`Observed Output / DB / DOM`) | Tầng & Độ thật (`0 Mock` hay `Mock thành phần nào`) | Kết quả |
|---|---|---|---|---|---|
| `XXX-AC01` | | | | `integration` — **0 Mock** | ✅ PASS |

## Checklist

- [ ] Test mới chứa AC-ID trong tên và đã khai báo rõ `0 Mock` / `Mock gì` trong bảng Bằng chứng ở trên (`C29`)
- [ ] Lint, typecheck, test xanh
- [ ] AC `[x]` có bằng chứng; `[~]` ghi lý do/cách đóng và không dùng để chuyển `Done`
- [ ] Đổi schema/API công khai: có mục trong `docs/upgrade/`
- [ ] Thay đổi liên quan bảo mật đã nêu rõ ở "Thay đổi"
- [ ] `docs/progress.md` có dòng mới
- [ ] Điều chưa chứng minh và giới hạn mock được nêu rõ (`C31`); xong phạm vi thì dừng, không tự nhận task kế

<!-- ===== Chỉ điền khi PR vào nhánh môi trường (staging/production). Xoá với PR khác. ===== -->

## Tag/bản đã kiểm ở môi trường trước

## Migration trong đợt

<!-- "Không có" nếu không có -->

## Kế hoạch rollback
