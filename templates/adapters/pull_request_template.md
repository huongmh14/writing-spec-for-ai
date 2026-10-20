<!-- Đặt tại .github/pull_request_template.md. Tiêu đề: <type>(<scope>): <mô tả> [SPEC-XXX] -->

## Spec liên quan

<!-- SPEC-XXX — XXX-R01, XXX-AC01; CHG-xx nếu có -->

## Thay đổi

## Cách kiểm thử

## Checklist

- [ ] Test mới chứa AC-ID trong tên
- [ ] Lint, typecheck, test xanh
- [ ] Đã đánh `[x]` AC trong PR này (hoặc `[~]` kèm lý do)
- [ ] Đổi schema/API công khai: có mục trong `docs/upgrade/`
- [ ] Thay đổi liên quan bảo mật đã nêu rõ ở "Thay đổi"
- [ ] `docs/progress.md` có dòng mới

<!-- ===== Chỉ điền khi PR vào nhánh môi trường (staging/production). Xoá với PR khác. ===== -->

## Tag/bản đã kiểm ở môi trường trước

## Migration trong đợt

<!-- "Không có" nếu không có -->

## Kế hoạch rollback
