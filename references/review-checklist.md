# Checklist review bộ docs cho AI

Đánh `[x]` / `[ ]` / `N/A`. Mọi `[ ]` phải nêu trong báo cáo gửi người dùng.

## 1. AGENTS.md (Mức 0)

- [ ] Bối cảnh 2–4 câu, stack cụ thể kèm major version (không patch).
- [ ] Mục Lệnh nằm ngay sau bối cảnh, đủ flag, **có lệnh chạy 1 test**.
- [ ] Mọi lệnh đã chạy thử (hoặc ghi rõ chưa chạy và lý do).
- [ ] Bảng thứ tự nguồn sự thật + "mơ hồ thì dừng, nêu chỗ chưa rõ, đề xuất" + "skill ngoài mâu thuẫn thì theo file này".
- [ ] **Con trỏ có điều kiện** (`C24`): mỗi dòng trỏ tới tài liệu khác trong `AGENTS.md` đều đặt điều kiện kích hoạt ở đầu câu (*"Khi chạm X → đọc Y"*), một nhánh một dòng.
- [ ] Ranh giới 3 tầng ✅ Luôn / ⚠️ Hỏi trước / 🚫 Không bao giờ; có "không commit secret".
- [ ] **Không hạ chuẩn âm thầm** (`C23`): mục 🚫 có cấm thêm suppression (`@ts-ignore`, `eslint-disable`, `# noqa`, `.skip`) hoặc hạ ngưỡng kiểm tra để làm test xanh.
- [ ] **Đánh dấu giới hạn đơn giản hoá** (`C27`): mục ✅ có quy ước gắn `ceiling:` khi chọn giải pháp đơn giản có giới hạn đã biết.
- [ ] **Bằng chứng test hiển thị** (`C29`) trong DoD: mục DoD / quy trình task yêu cầu in **bảng kết quả chạy test** nêu rõ Input, Output thực tế, và **khai báo mock** (0 Mock hay Mock thành phần nào) thay vì chỉ báo "test xanh".
- [ ] DoD là lệnh/điều kiện kiểm chứng được.
- [ ] **Quyền thực thi theo đợt** (`C30`): `Ready` không cấp quyền code; một đợt có chỉ dẫn thật, spec/task/AC, điểm dừng. Mặc định 1 task; batch đã giao không hỏi lại; xong không tự chạy task kế.
- [ ] Quy ước code có ≥ 1 ví dụ thật hoặc file mẫu để bắt chước.
- [ ] Phủ đủ 6 mảng: lệnh, test, cấu trúc, style, git, ranh giới.
- [ ] ≤ ~150 dòng; không câu hiển nhiên; không số dòng/phiên bản patch; nhấn mạnh (IMPORTANT/viết hoa) chỉ ở vài dòng.
- [ ] Có 3 luật xử lý lỗi (không nuốt im lặng; message nội bộ không ra ngoài; best-effort phải log).
- [ ] 🚫 có "không commit file quyền cá nhân của agent"; ✅ có "thêm biến môi trường thì sửa `.env.example` + `docs/reference/config.md`".
- [ ] Đầu file khai báo base: phiên bản, profile, pack; mục "Ghi đè" (nếu có) mỗi dòng nới/bỏ đều có `D-xx`.

## 2. Spec (từng spec)

- [ ] Có mục tiêu, phạm vi trong/ngoài (ngoài không rỗng).
- [ ] **Trình bày định hướng bằng hình** (`C28`): có sơ đồ luồng tương tác (Mermaid) và ít nhất 1 phác thảo đầu vào/đầu ra cụ thể (ASCII UI wireframe, mẫu CLI, hoặc JSON request/response) để người duyệt nhìn thấy hình hài tính năng trước khi đọc REQ.
- [ ] Mỗi REQ có ID, mức, một câu; theo mẫu EARS khi được.
- [ ] **Nguồn & giới hạn hiểu biết** (`C31`): REQ/NFR và khẳng định quan trọng gắn 1 trong 4 nhãn `Người dùng chốt / Đã xác minh / AI đề xuất / Chưa biết`, một khẳng định một dòng; số đo có điều kiện, N/A chỉ khi không áp dụng, Draft unknown có cách xác minh.
- [ ] Có bản đọc ngắn bằng hành vi và ví dụ; không bắt người dùng duyệt kiến thức chuyên môn chưa được chứng minh hoặc tự chấm độ tự tin %.
- [ ] Mỗi `Đã xác minh` có đúng 1 con trỏ mở được (`path:line`, URL + trích nguyên văn + ngày đọc, hoặc lệnh + kết quả thật); link không kèm câu trích chưa tính là xác minh.
- [ ] Quyết định kỹ thuật người dùng không tự thẩm định được có thẻ quyết định với dòng "Tự kiểm trong ≤ 5 phút" rẻ, chạy được (lệnh/thao tác + kết quả mong đợi, trỏ AC-ID).
- [ ] Vùng bảo mật/thanh toán/pháp lý/dữ liệu cá nhân người dùng không tự kiểm được ghi "cần chuyên gia: <vai trò>"; lời duyệt không coi là chứng nhận đúng.
- [ ] Có trường hợp biên; mỗi biên có AC hoặc nằm ở ngoài phạm vi.
- [ ] Mỗi REQ ≥ 1 AC; có AC cho lỗi; AC có tầng test.
- [ ] **Ma trận Kiểm thử Minh bạch (`Visible Test Matrix`):** bảng AC nêu rõ cho từng `AC-ID`: `Kịch bản | Đầu vào cụ thể (Input) | Kỳ vọng quan sát được (Output & Tác dụng phụ) | Tầng & Độ thật (0 Mock hay Mock thành phần nào)`.
- [ ] Không tính từ không đo được ("nhanh", "an toàn", "hợp lý").
- [ ] Không còn `[CẦN LÀM RÕ]` nếu trạng thái `Ready`.
- [ ] Câu hỏi mở có mặt (ghi "Không có" nếu rỗng); mâu thuẫn ghi ở cả hai spec liên quan.
- [ ] Không chép lý do quyết định; chỉ ghi `D-xx`.
- [ ] Không mô tả cài đặt trừ ràng buộc kiến trúc; không có phần chia việc.
- [ ] Có cách kiểm end-to-end.
- [ ] Thuật ngữ khớp glossary.
- [ ] Spec `As-built`: mỗi REQ có bằng chứng; `[x]` chỉ khi test hiện có chứng minh.
- [ ] AC của lệnh vận hành (migrate, sync, seed, deploy) kiểm tác dụng, không chỉ exit code (**Kiểm tác dụng lệnh vận hành**, `C19`).
- [ ] **REQ kế thừa từ pack (nếu có):** tham chiếu đúng ID pack (`PK-API`, `PK-AUTH`, `PK-RELEASE`, `PK-DB`, `PK-OBS`, `PK-FE`, `PK-JOB`, `PK-AGENT`), tham số `{…}` đã được điền giá trị cụ thể, không để trống.

## 3. Quyết định, thuật ngữ, trạng thái

- [ ] `decisions.md` append-only, có cột trạng thái (hiệu lực / bị thay bởi).
- [ ] Bảng P-xx không chứa mục đã làm xong.
- [ ] `glossary.md` có các thuật ngữ miền chính, cột "không gọi là", không lẫn chi tiết cài đặt.
- [ ] File trạng thái (`progress.md`, plan) có ngày cập nhật; bàn giao phiên mới nằm ngay trong `progress.md` (không tách `HANDOFF.md` riêng).
- [ ] Chỉ một đợt thực thi hiện tại; progress/HANDOFF không tạo quyền từ việc còn dở. `[~]` không đủ chuyển `Done`; báo cáo có link bằng chứng, không chép kỳ vọng thành kết quả.
- [ ] progress tách khỏi danh mục spec; ≤ ~5 KB; ≤ 3 câu/dòng.
- [ ] `docs/specs/README.md` có bảng quyền AI theo trạng thái, luật hotfix, bảng "loại thay đổi → file phải sửa" (có dòng đổi stack), và **bảng phụ thuộc một chiều / thứ tự xây dựng giữa các spec (Capability Map)** nếu có ≥ 2 spec.
- [ ] Nợ spec của hotfix (nếu có) nằm trong progress và chưa quá 1 ngày làm việc.
- [ ] Biến môi trường chỉ mô tả ở `docs/reference/config.md`; khớp `.env.example`. Mã lỗi/trạng thái chỉ ở `docs/reference/error-codes.md`.

## 3b. CI, cấu hình, CONSTRAINTS, gotcha

- [ ] CI chạy đúng lệnh DoD trên stack hiện tại; mọi đường dẫn CI tham chiếu đều tồn tại (**Đổi stack là một thay đổi**, `C20`).
- [ ] Chỉ một file nhận là nguồn sự thật cho mỗi chủ đề.
- [ ] File env mẫu tên `.env.example`; `.env` bị ignore; không có file quyền cá nhân của agent trong git (**Secret & cấu hình**, `C16`).
- [ ] Mỗi gotcha có ngày kiểm lần cuối (**Gotcha có ngày kiểm**, `C18`); gotcha mâu thuẫn với code hiện tại đã được sửa/xoá.
- [ ] `CONSTRAINTS.md` (nếu dự án bật): mọi con số trong bảng cưỡng chế đều có lệnh kiểm tra thật ở cột `Checked by`; các ngoại lệ đều có `Owner` và `Expires` ≤ 90 ngày (`C23`).

## 4. Vị trí & adapter

- [ ] Mỗi file đặt đúng chỗ công cụ đọc (principles §5).
- [ ] Adapter chỉ trỏ về `AGENTS.md` + phần riêng công cụ.
- [ ] Mọi file docs được ít nhất một file khác trỏ tới.
- [ ] Không file tri thức bị `.gitignore` / `.git/info/exclude`.

## 5. Chất lượng chung & Phản biện trong phiên sạch (`C24`, `C26`)

- [ ] Không sự thật nào ghi ở hai nơi.
- [ ] Không yêu cầu bịa: mọi REQ truy được về lời người dùng hoặc bằng chứng repo.
- [ ] Không placeholder, không TODO không gắn issue.
- [ ] Mẫu chép sang repo đích (AGENTS.md, spec, decisions…) không chứa mã luật Core `Cxx`; mã truy vết (`SPEC-x`, `X-R01`, `D-xx`, `PK-…`) được giữ.
- [ ] File nội bộ kit: mã luật lần đầu có tên ngắn (``**tên ngắn** (`Cxx`)``); thuật ngữ kit lần đầu được giải nghĩa hoặc link [glossary.md](glossary.md).
- [ ] Viết khẳng định trước, câu cấm chỉ cho ranh giới cứng (`C24`).
- [ ] Đã qua bước phản biện đối kháng trong context sạch (`spec-challenger` / `C26` — chỉ nhận `ARTIFACT + CONTRACT`).

## 6. Mức 1–2 (nếu áp dụng)

- [ ] Mỗi thành phần mức 1–2 có tín hiệu biện minh trong đề xuất.
- [ ] Design có ≥ 1 phương án đã loại kèm lý do (**Design It Twice**), chỉ rõ **Seam (điểm ghép nối)** và độ sâu giao diện (**Deep Module**), rủi ro + rollback, map REQ → thành phần, trích dẫn nguồn docs chính thức theo version (**Dẫn nguồn chính thống**, `C25`).
- [ ] Contract là file máy đọc; spec chỉ link.
- [ ] Plan chia theo lát cắt dọc, có `Blocked by`; task sẵn sàng chỉ chạy song song trong đợt được giao (`C30`). Plan riêng tuỳ nhu cầu nhưng lát cắt/AC/kiểm chứng/điểm dừng luôn có.
- [ ] AC phụ thuộc hạ tầng gắn `[~]` kèm lý do + cách đóng.
- [ ] Skill dự án (gồm cả `verify-<app>` nếu có): `name` ≤ 64 ký tự, `description` ngôi thứ ba nêu làm gì + khi nào, body < 500 dòng; không trùng skill global.
- [ ] Hook/settings đã review; deny-rules cho file nhạy cảm.
- [ ] Luật đã có check tự động chỉ còn một dòng văn xuôi trỏ tới check.
- [ ] Docs điều khiển agent (AGENTS.md, CONSTRAINTS.md, skill, rule, hook) nằm dưới CODEOWNERS.
- [ ] **Pack được khai báo trong AGENTS.md (dòng đầu):** chỉ pack có tín hiệu bật, không thừa.

## 7. Thử tài liệu (Bước 7 — `doc-tester`)

- [ ] Đã giao 2–3 task mẫu (Profile S: 2; M/L: 3) trong phiên mới (`doc-tester`, không mang context viết docs).
- [ ] Ghi lại luật bị bỏ qua, câu hỏi thừa, việc làm thừa — và đã sửa docs tương ứng.
- [ ] Có ca nhiều spec Ready nhưng chỉ giao 1 task; đợt hết quyền/HANDOFF cũ; batch hữu hạn đã giao; ngưỡng kỹ thuật chưa có nguồn (`C30`, `C31`). Thử docs không chứng minh runtime hay chuyên môn của sản phẩm.
