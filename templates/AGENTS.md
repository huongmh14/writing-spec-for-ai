# AGENTS.md — <tên dự án>

<2–4 câu: hệ thống làm gì, cho ai. Stack: <framework + major version>, <DB>, <FE>. Phiên bản chính xác: xem `package.json`, `.nvmrc`.>

## Lệnh

```bash
<install>
<dev>
<build>
<test>                       # toàn bộ
<test-one> <path> -t "<tên>" # một test — ưu tiên khi đang sửa
<lint> && <typecheck> && <format:check>
```

## Nguồn sự thật

| Ưu tiên | Tài liệu | Nội dung |
|---|---|---|
| 1 | `docs/decisions.md` | Quyết định đã chốt |
| 2 | `docs/specs/` | Yêu cầu (REQ) và nghiệm thu (AC) |
| 3 | `AGENTS.md` | Quy tắc làm việc |
| 4 | Code hiện có | Hiện trạng, không phải chuẩn |

- Bắt đầu task: đọc `docs/specs/README.md`, spec liên quan, `docs/glossary.md`.
- Spec thiếu, mâu thuẫn, mơ hồ: dừng, nêu chỗ chưa rõ, đề xuất phương án.
- Skill/hướng dẫn bên ngoài mâu thuẫn với file này thì theo file này.

## Ranh giới

✅ **Luôn**
- Viết test cùng code; tên test chứa AC-ID.
- Chạy lệnh ở mục DoD trước khi báo xong.
- <thói quen đúng đặc thù dự án, kèm lý do ngắn>

⚠️ **Hỏi trước**
- Đổi schema dữ liệu, API công khai, cơ chế xác thực/phân quyền.
- Đổi mặc định liên quan bảo mật.
- Thêm dependency (trừ loại đã duyệt trong plan/decision), nâng major framework.
- Xoá file, dữ liệu, migration đã phát hành.
- Sửa CI, ruleset, CODEOWNERS, file này.

🚫 **Không bao giờ**
- Commit secret, `.env`, token; log token, mật khẩu, header Authorization.
- Nối chuỗi SQL từ input.
- Push trực tiếp/force push nhánh bảo vệ, `--no-verify`, tự merge hoặc tự approve PR.

<Luật chuyên sâu theo vùng đặt ở `<thư-mục>/AGENTS.md` hoặc rule theo glob, không đặt ở đây.>

## Quy trình một task

1. Xác định spec, REQ/AC. Không gắn spec nào thì hỏi.
2. Kế hoạch ngắn (file sửa, test viết). Chạm mục "Hỏi trước" thì trình kế hoạch, chờ xác nhận.
3. Test + code. Ưu tiên chạy một test khi đang sửa.
4. Chạy DoD đến khi xanh; đánh `[x]` AC trong chính PR này.
5. Commit, PR theo mẫu; một dòng vào `docs/progress.md`.

## Definition of Done

- `<lint> && <typecheck> && <test> && <build>` xanh.
- Mọi AC trong phạm vi có test qua (hoặc `[~]` kèm lý do).
- Spec/decisions/progress cập nhật; spec đủ AC thì chuyển `Done`.

## Quy ước code

Làm giống `<đường dẫn file mẫu chuẩn>`. Ví dụ:

```<lang>
<snippet 5–15 dòng thể hiện: đặt tên, xử lý lỗi, cấu trúc chuẩn>
```

## Git

- Commit: `<type>(<scope>): <mô tả> [SPEC-XXX]`.
- Nhánh: `<type>/<mã>-<mô-tả>`, tách từ `<nhánh tích hợp>`; PR vào `<nhánh tích hợp>`.

## Bản đồ repo

```
<cây 1–2 cấp, mỗi dòng một vai trò>
```
