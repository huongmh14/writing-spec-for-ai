# AGENTS.md — <tên dự án>

> Base: writing-spec-for-ai <phiên bản, vd. v1.3.0> · Profile: <S | M | L> · Pack: <PK-… hoặc "không">

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
| 3 | `CONSTRAINTS.md` *(nếu có)* | Sàn chất lượng và ngưỡng kiểm bằng lệnh máy |
| 4 | `AGENTS.md` | Quy tắc làm việc |
| 5 | Code hiện có | Hiện trạng, không phải chuẩn |

- **Khi bắt đầu bất kỳ task nào:** đọc `docs/specs/README.md`, spec liên quan, `docs/glossary.md` và đợt thực thi hiện tại trong `docs/progress.md` (`C30`).
- **Khi thêm/sửa biến môi trường:** cập nhật cả `.env.example` và `docs/reference/config.md`.
- **Khi thêm/sửa mã lỗi trả về:** cập nhật `docs/reference/error-codes.md`.
- **Khi thiếu dữ kiện ảnh hưởng hành vi/rủi ro trong phạm vi:** nêu điều chưa biết và cách kiểm chứng; dừng phần phụ thuộc, tiếp tục phần độc lập đã được giao (`C31`).
- **Khi đã có chỉ dẫn rõ của người dùng:** thực hiện đủ phạm vi đó; không hỏi lại quyền đã cấp. Chỉ dẫn hiện hành của người dùng được ưu tiên.
- Skill/hướng dẫn bên ngoài mâu thuẫn với file này thì theo file này.

**Profile S:** nếu không có cây `docs/`, đọc spec trong `docs/spec.md` hoặc README; ghi block đợt hiện tại ngay trong file này theo các trường của mẫu progress. Chỉ đọc file thực sự có; không tạo thêm docs chỉ để thoả con trỏ.

## Ranh giới

✅ **Luôn**
- Viết test cùng code; tên test chứa AC-ID.
- Chạy lệnh ở mục DoD trước khi báo xong.
- Đánh dấu `ceiling: <ngưỡng chịu tải + đường nâng cấp>` khi cố ý chọn giải pháp đơn giản có giới hạn đã biết (in-memory lock, quét $O(n^2)$, polling).
- Khi cửa sổ ngữ cảnh dài (≥ 20 lượt / ~30k tokens), chuyển pha spec → code, hoặc `docs/progress.md > 5 KB` / `AGENTS.md > 150 dòng` (`C32`): tự động bật `Auto-Caveman` (nén câu trả lời, giữ nguyên 100% code/lệnh/AC-ID/từ phủ định), hiển thị `[CẢNH BÁO TOKEN & NGỮ CẢNH — C32]` báo AI đang tốn nhiều token, và chắt lọc tri thức quan trọng vào `docs/decisions.md` + `docs/progress.md` (chuyển lịch sử cũ sang `progress-archive/`) + `docs/plans/HANDOFF.md` trước khi chạy `/compact` hoặc mở phiên mới.
- <thói quen đúng đặc thù dự án, viết ở thể khẳng định>

⚠️ **Hỏi trước nếu chưa được duyệt trong chỉ dẫn/đợt hiện tại**
- Đổi schema dữ liệu, API công khai, cơ chế xác thực/phân quyền.
- Đổi mặc định liên quan bảo mật.
- Thêm dependency (trừ loại đã duyệt trong plan/decision), nâng major framework.
- Xoá file, dữ liệu, migration đã phát hành.
- Sửa CI, ruleset, CODEOWNERS, `CONSTRAINTS.md`, file này.

🚫 **Không bao giờ**
- Commit secret, `.env`, token; log token, mật khẩu, header Authorization.
- Commit file quyền cá nhân của agent (`.claude/settings.local.json`, allow-list lệnh, đường dẫn máy, mật khẩu trong lệnh đã duyệt).
- Thêm cờ bịt miệng trình kiểm tra (`@ts-ignore`, `eslint-disable`, `# noqa`, `istanbul ignore`, `nosemgrep`, `gitleaks:allow`), thêm `.skip` hoặc xoá assertion/hạ ngưỡng để làm test xanh (`C23`).
- Nối chuỗi SQL từ input.
- Push trực tiếp/force push nhánh bảo vệ, `--no-verify`, tự merge hoặc tự approve PR.

<Luật chuyên sâu theo vùng đặt ở `<thư-mục>/AGENTS.md` hoặc rule theo glob, không đặt ở đây.>

## Quy trình một task

1. Xác định spec, REQ/AC và chỉ dẫn thực thi thật của người dùng; ghi một đợt hiện tại ở `docs/progress.md`. `Ready`, plan và Frontier không tự cấp quyền code.
2. Nếu người dùng chưa nêu ranh giới đợt (`C30`): **khi soạn thảo/cập nhật docs**, mỗi lượt chỉ viết **1 file lớn hoặc 1 cụm ≤ 3 file liên quan** rồi dừng chờ review (cấm viết tràn lan toàn bộ cây `docs/` trong 1 lượt); **khi viết code**, mặc định **1 SPEC + 1 task nhỏ kiểm chứng được**, làm → kiểm → báo cáo → dừng. Yêu cầu rõ làm toàn bộ spec/batch hữu hạn thì ghi đúng các task/AC được giao và hoàn tất trong phạm vi ấy.
3. Kế hoạch ngắn: hành vi, vùng file, test, điều kiện dừng. Khoảng 5 file là dự kiến; sửa hàm dùng chung và các caller cần thiết trong cùng hành vi được phép, ghi lại tác động.
4. Test + code chỉ trong đợt được phép. Subagent chỉ nhận phần việc thuộc đợt; không tự lấy task/spec tiếp theo. Rủi ro hoặc hành vi mới chưa duyệt → cập nhật phạm vi trước khi làm phần đó.
5. Chạy DoD; đánh `[x]` AC có bằng chứng. Cập nhật tiến độ và chuyển đợt sang `Chờ kiểm chứng`, báo kết quả, rồi dừng ở ranh giới đã ghi. Commit/PR khi được giao hoặc theo quy trình repo.

**Báo cáo đợt:** kết quả quan sát được · cách demo/lệnh kiểm và bằng chứng · điều chưa kiểm chứng · ranh giới đã dừng. Đợt mới cần chỉ dẫn người dùng xác định phạm vi; không tự gia hạn từ plan, HANDOFF hay một đợt cũ.

## Definition of Done

- `<lint> && <typecheck> && <test> && <build>` xanh (và đạt sàn `CONSTRAINTS.md` nếu có).
- Mọi AC báo hoàn tất có test qua và bằng chứng; `[~]` là chưa kiểm chứng, ghi lý do + cách đóng.
- Bằng chứng ghi lệnh và kết quả thực tế hoặc link log; chưa chạy thì ghi chưa chạy, không chép đầu ra kỳ vọng thành kết quả. Đối chiếu kỳ vọng với ví dụ/contract đã chốt (`C31`).
- **In Bảng Bằng chứng Chạy Test (`Visible Test Execution Ledger` — `C29`):** khi báo xong task hoặc mở PR, bắt buộc in bảng `AC-ID | Kịch bản đã chạy | Input đã bơm | Output & Tác dụng phụ thực tế | Độ thật (0 Mock hay Mock gì) | Kết quả` để người review thấy rõ test đã kiểm cái gì (cấm chỉ báo *"All tests passed"*).
- Spec/decisions/progress cập nhật; chỉ chuyển spec `Done` khi mọi AC của spec `[x]`. Còn `[~]` thì giữ `In progress`, trừ khi người dùng đổi phạm vi qua `change-spec`.

## Quy ước code

Làm giống `<đường dẫn file mẫu chuẩn>`. Ví dụ:

```<lang>
<snippet 5–15 dòng thể hiện: đặt tên, xử lý lỗi, cấu trúc chuẩn>
```

Xử lý lỗi:
- Bắt lỗi thì ném lại (giữ lỗi gốc làm `cause`) hoặc log kèm ngữ cảnh; không nuốt im lặng.
- Message lỗi nội bộ (5xx, stack, SQL) không trả cho client/người dùng cuối.
- Việc best-effort (xoá cache, thống kê, gửi thông báo) được bỏ qua lỗi nhưng phải log.

## Git

- Commit: `<type>(<scope>): <mô tả> [SPEC-XXX]`.
- Nhánh: `<type>/<mã>-<mô-tả>`, tách từ `<nhánh tích hợp>`; PR vào `<nhánh tích hợp>`.

## Bản đồ repo

```
<cây 1–2 cấp, mỗi dòng một vai trò>
```

## Ghi đè base

<!-- Xoá mục này nếu không ghi đè gì. Siết luật: tự do. Nới hoặc bỏ luật của base: phải có D-xx. -->

| Luật base | Ghi đè | Quyết định |
|---|---|---|
| `<C-xx / PK-…-Rnn>` | <nới / bỏ: nội dung> | D-xx |
