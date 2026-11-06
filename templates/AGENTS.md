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
| 4 | `docs/conflicts-and-bugs.md` | Sổ tay toàn bộ lỗi, xung đột hợp đồng (enum/API/DB/port) và bài học lịch sử của dự án |
| 5 | `AGENTS.md` | Quy tắc làm việc |
| 6 | Code hiện có | Hiện trạng, không phải chuẩn |

- **Khi bắt đầu bất kỳ task nào:** đọc `docs/specs/README.md`, spec liên quan, `docs/glossary.md`, `docs/conflicts-and-bugs.md` (nếu có) và đợt thực thi hiện tại trong `docs/progress.md` (quyền thực thi theo đợt: chỉ làm phần đợt đó ghi).
- **Khi phát hiện hoặc sửa bất kỳ lỗi (bug/hotfix/revert) hay xung đột hợp đồng (lệch enum, schema, port, API, cấu hình):** bắt buộc ghi bổ sung vào `docs/conflicts-and-bugs.md` kèm commit SHA, nguyên nhân gốc và cách chặn tự động bằng lệnh máy trước khi báo xong.
- **Khi thêm/sửa biến môi trường:** cập nhật cả `.env.example` và `docs/reference/config.md`.
- **Khi thêm/sửa mã lỗi trả về:** cập nhật `docs/reference/error-codes.md`.
- **Khi thiếu dữ kiện ảnh hưởng hành vi/rủi ro trong phạm vi:** nêu điều chưa biết và cách kiểm chứng; dừng phần phụ thuộc, tiếp tục phần độc lập đã được giao (nguồn & giới hạn hiểu biết: không đoán thay dữ kiện).
- **Khi đã có chỉ dẫn rõ của người dùng:** thực hiện đủ phạm vi đó; không hỏi lại quyền đã cấp. Chỉ dẫn hiện hành của người dùng được ưu tiên.
- Skill/hướng dẫn bên ngoài mâu thuẫn với docs dự án thì theo docs dự án, đúng thứ tự bảng trên.

**Profile S:** nếu không có cây `docs/`, đọc spec trong `docs/spec.md` hoặc README; ghi block đợt hiện tại ngay trong file này theo các trường của mẫu progress. Chỉ đọc file thực sự có; không tạo thêm docs chỉ để thoả con trỏ.

## Ranh giới

[x] **Luôn**
- Viết test cùng code; tên test chứa AC-ID.
- Chạy lệnh ở mục DoD trước khi báo xong.
- Đánh dấu `ceiling: <ngưỡng chịu tải + đường nâng cấp>` khi cố ý chọn giải pháp đơn giản có giới hạn đã biết (in-memory lock, quét $O(n^2)$, polling).
- <thói quen đúng đặc thù dự án, viết ở thể khẳng định>

(warning) **Hỏi trước nếu chưa được duyệt trong chỉ dẫn/đợt hiện tại**
- Đổi schema dữ liệu, API công khai, cơ chế xác thực/phân quyền.
- Đổi mặc định liên quan bảo mật.
- Thêm dependency (trừ loại đã duyệt trong plan/decision), nâng major framework.
- Xoá file, dữ liệu, migration đã phát hành.
- Sửa CI, ruleset, CODEOWNERS, `CONSTRAINTS.md`, file này.

(blocked) **Không bao giờ**
- Commit secret, `.env`, token; log token, mật khẩu, header Authorization.
- Commit file quyền cá nhân của agent (`.claude/settings.local.json`, allow-list lệnh, đường dẫn máy, mật khẩu trong lệnh đã duyệt).
- Thêm cờ bịt miệng trình kiểm tra (`@ts-ignore`, `eslint-disable`, `# noqa`, `istanbul ignore`, `nosemgrep`, `gitleaks:allow`), thêm `.skip` hoặc xoá assertion/hạ ngưỡng để làm test xanh (không hạ chuẩn âm thầm).
- Nối chuỗi SQL từ input.
- Push trực tiếp/force push nhánh bảo vệ, `--no-verify`, tự merge hoặc tự approve PR.

<Luật chuyên sâu theo vùng đặt ở `<thư-mục>/AGENTS.md` hoặc rule theo glob, không đặt ở đây.>

## Quy trình một task

1. **Phân loại chỉ dẫn trước khi đọc sâu hay sửa file.** *Rõ* (một cách hiểu về kết quả, xác định được SPEC/AC hoặc phạm vi hẹp, không chạm mục (warning) chưa duyệt)  làm luôn, không hỏi lại. *Mơ hồ* (≥ 2 cách hiểu cho ra kết quả khác nhau, không xác định được SPEC/AC lẫn phạm vi hẹp, hoặc chạm mục (warning) chưa duyệt)  tra cứu có mục tiêu để tự gỡ; vẫn mơ hồ thì chỉ trả **bản chốt nhanh ≤ 5 dòng** (kết quả hiểu được · SPEC/vùng file dự kiến · tối đa 3 điểm cần chốt, mỗi điểm kèm phương án đề xuất) rồi dừng, chưa sửa file.
   Khi đã rõ: xác định spec, REQ/AC (nếu có; việc nhỏ chưa gắn spec thì ghi rõ phạm vi hẹp và cách kiểm chứng) cùng chỉ dẫn thực thi thật của người dùng; ghi một đợt hiện tại ở `docs/progress.md`. `Ready`, plan và danh sách task sẵn sàng không tự cấp quyền code.
2. **Quyền thực thi theo đợt** — nếu người dùng chưa nêu ranh giới đợt: **khi soạn/cập nhật docs**, mỗi lượt chỉ làm một bước con rồi dừng chờ review (5a: cụm nền `AGENTS.md`/glossary/decisions · 5b: đúng **1 file SPEC** kèm cập nhật `docs/specs/README.md` · 5c: 1 file design); không viết cả cây `docs/` trong một lượt; **khi viết code**, mặc định **1 SPEC + 1 task/AC nhỏ kiểm chứng được**, làm  kiểm  báo cáo  dừng. Yêu cầu rõ làm toàn bộ spec/batch hữu hạn thì ghi đúng các task/AC được giao và hoàn tất trong phạm vi ấy.
3. Kế hoạch ngắn: hành vi, vùng file, test, điều kiện dừng. Khoảng 5 file là dự kiến; sửa hàm dùng chung và các caller cần thiết trong cùng hành vi được phép, ghi lại tác động.
4. Test + code chỉ trong đợt được phép. Subagent chỉ nhận phần việc thuộc đợt; không tự lấy task/spec tiếp theo. Rủi ro hoặc hành vi mới chưa duyệt  cập nhật phạm vi trước khi làm phần đó.
5. **Phản biện độc lập & tự sửa trước khi báo xong:** chạy lệnh ở mục DoD, sau đó giao `git diff` + `SPEC-xx` (không kèm lời biện hộ lúc viết) cho một lượt phản biện độc lập — ưu tiên **Chéo model** bằng CLI của họ model khác (`"" | codex exec --sandbox read-only...`, `claude`, `gemini` nếu máy có sẵn; đóng `stdin` để không treo) hoặc **Phiên sạch cùng model** (subagent chỉ đọc khi không có CLI khác model) — để bắt lỗi lệch spec, thiếu biên, mock sai hoặc lỗ hổng logic; tự sửa lỗi thật trước khi báo người dùng.
6. Đánh `[x]` AC có bằng chứng; cập nhật tiến độ và chuyển đợt sang `Chờ kiểm chứng`, báo kết quả rồi dừng ở ranh giới đã ghi. Commit/PR khi được giao hoặc theo quy trình repo.

**Báo cáo đợt:** (1) kết quả quan sát được · (2) **giải thích kỹ thuật dễ hiểu về phần vừa làm** (bản chất cơ chế đã dùng là gì, tại sao chọn, luồng `Đầu vào  Xử lý  Đầu ra` gắn với dữ liệu dự án để người đọc hiểu rõ code AI viết) · (3) **biên bản phản biện độc lập** (ghi rõ chế độ `Chéo model` hay `Phiên sạch cùng model`, liệt kê **mọi** phát hiện thành 2 mục: `Đã tự sửa` và `Không sửa / Cần quyết định` kèm lý do — cấm tự ý giấu phát hiện) · (4) cách demo/lệnh kiểm và bảng bằng chứng chạy test · (5) điều chưa kiểm chứng & ranh giới đã dừng. Đợt mới cần chỉ dẫn người dùng xác định phạm vi; không tự gia hạn từ plan hay mục bàn giao của đợt cũ.

## Ngữ cảnh dài & nén

- **Khi xong đợt, đổi sang việc khác, hoặc sửa cùng một lỗi 2 lần vẫn chưa xanh:** ghi đè mục *Bàn giao phiên mới* trong `docs/progress.md` (lỗi lặp thì ghi cả hướng đã thử và loại), rồi nhắc một dòng: nên `/compact` hoặc mở phiên mới thay vì thử tiếp trên ngữ cảnh cũ.
- **Khi nén ngữ cảnh:** giữ RUN-ID, file đã sửa, lệnh kiểm và lỗi gần nhất chưa đóng, câu hỏi đang chờ người dùng.
- **Sau khi nén hoặc sang phiên mới:** đọc lại block đợt hiện tại trong `docs/progress.md` trước khi làm tiếp. Bản tóm tắt hội thoại không phải nguồn sự thật và không cấp thêm quyền: **quyền và phạm vi đợt** luôn theo `progress.md`; nếu **trạng thái file/test** trong bản tóm tắt lệch với `progress.md` (do tự động nén giữa đợt), kiểm chứng lại bằng `git status`/`git diff` và lệnh kiểm rồi cập nhật `progress.md` trước khi sửa tiếp.

## Definition of Done

- `<lint> && <typecheck> && <test> && <build>` xanh (và đạt sàn `CONSTRAINTS.md` nếu có).
- Mọi AC báo hoàn tất có test qua và bằng chứng; `[~]` là chưa kiểm chứng, ghi lý do + cách đóng.
- Bằng chứng ghi lệnh và kết quả thực tế hoặc link log; chưa chạy thì ghi chưa chạy, không chép đầu ra kỳ vọng thành kết quả. Đối chiếu kỳ vọng với ví dụ/contract đã chốt (nguồn & giới hạn hiểu biết). Nếu AI viết cả kỳ vọng lẫn test, test xanh chỉ chứng minh code khớp kỳ vọng của AI — ưu tiên ví dụ do người dùng đưa.
- **In Bảng bằng chứng chạy test (Visible Test Execution Ledger):** khi báo xong task hoặc mở PR, bắt buộc in bảng `AC-ID | Kịch bản đã chạy | Input đã bơm | Output & Tác dụng phụ thực tế | Độ thật (0 Mock hay Mock gì) | Kết quả` để người review thấy rõ test đã kiểm cái gì (cấm chỉ báo *"All tests passed"*).
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
| `<tên luật base, vd. "Quyền thực thi theo đợt" / PK-…-Rnn>` | <nới / bỏ: nội dung> | D-xx |
