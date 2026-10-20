# Checklist review bộ docs cho AI

Đánh `[x]` / `[ ]` / `N/A`. Mọi `[ ]` phải nêu trong báo cáo gửi người dùng.

## 1. AGENTS.md (Mức 0)

- [ ] Bối cảnh 2–4 câu, stack cụ thể kèm major version (không patch).
- [ ] Mục Lệnh nằm ngay sau bối cảnh, đủ flag, **có lệnh chạy 1 test**.
- [ ] Mọi lệnh đã chạy thử (hoặc ghi rõ chưa chạy và lý do).
- [ ] Bảng thứ tự nguồn sự thật + "mơ hồ thì dừng, nêu chỗ chưa rõ, đề xuất" + "skill ngoài mâu thuẫn thì theo file này".
- [ ] Ranh giới 3 tầng ✅ Luôn / ⚠️ Hỏi trước / 🚫 Không bao giờ; có "không commit secret".
- [ ] DoD là lệnh/điều kiện kiểm chứng được.
- [ ] Quy ước code có ≥ 1 ví dụ thật hoặc file mẫu để bắt chước.
- [ ] Phủ đủ 6 mảng: lệnh, test, cấu trúc, style, git, ranh giới.
- [ ] ≤ ~150 dòng; không câu hiển nhiên; không số dòng/phiên bản patch; nhấn mạnh (IMPORTANT/viết hoa) chỉ ở vài dòng.
- [ ] Có 3 luật xử lý lỗi (không nuốt im lặng; message nội bộ không ra ngoài; best-effort phải log).
- [ ] 🚫 có "không commit file quyền cá nhân của agent"; ✅ có "thêm biến môi trường thì sửa `.env.example` + `docs/reference/config.md`".
- [ ] Đầu file khai báo base: phiên bản, profile, pack; mục "Ghi đè" (nếu có) mỗi dòng nới/bỏ đều có `D-xx`.

## 2. Spec (từng spec)

- [ ] Có mục tiêu, phạm vi trong/ngoài (ngoài không rỗng).
- [ ] Mỗi REQ có ID, mức, một câu; theo mẫu EARS khi được.
- [ ] NFR đủ dòng: số liệu hoặc `N/A — lý do`.
- [ ] Có trường hợp biên; mỗi biên có AC hoặc nằm ở ngoài phạm vi.
- [ ] Mỗi REQ ≥ 1 AC; có AC cho lỗi; AC có tầng test.
- [ ] Không tính từ không đo được ("nhanh", "an toàn", "hợp lý").
- [ ] Không còn `[CẦN LÀM RÕ]` nếu trạng thái `Ready`.
- [ ] Câu hỏi mở có mặt (ghi "Không có" nếu rỗng); mâu thuẫn ghi ở cả hai spec liên quan.
- [ ] Không chép lý do quyết định; chỉ ghi `D-xx`.
- [ ] Không mô tả cài đặt trừ ràng buộc kiến trúc; không có phần chia việc.
- [ ] Có cách kiểm end-to-end.
- [ ] Thuật ngữ khớp glossary.
- [ ] Spec `As-built`: mỗi REQ có bằng chứng; `[x]` chỉ khi test hiện có chứng minh.
- [ ] AC của lệnh vận hành (migrate, sync, seed, deploy) kiểm tác dụng, không chỉ exit code.

## 3. Quyết định, thuật ngữ, trạng thái

- [ ] `decisions.md` append-only, có cột trạng thái (hiệu lực / bị thay bởi).
- [ ] Bảng P-xx không chứa mục đã làm xong.
- [ ] `glossary.md` có các thuật ngữ miền chính, cột "không gọi là".
- [ ] File trạng thái (progress, HANDOFF, plan) có ngày cập nhật; HANDOFF mới bằng dòng cuối progress.
- [ ] progress tách khỏi danh mục spec; ≤ ~5 KB; ≤ 3 câu/dòng.
- [ ] `docs/specs/README.md` có bảng quyền AI theo trạng thái, luật hotfix, bảng "loại thay đổi → file phải sửa" (có dòng đổi stack).
- [ ] Nợ spec của hotfix (nếu có) nằm trong progress và chưa quá 1 ngày làm việc.
- [ ] Biến môi trường chỉ mô tả ở `docs/reference/config.md`; khớp `.env.example`. Mã lỗi/trạng thái chỉ ở `docs/reference/error-codes.md`.

## 3b. CI, cấu hình, gotcha

- [ ] CI chạy đúng lệnh DoD trên stack hiện tại; mọi đường dẫn CI tham chiếu đều tồn tại.
- [ ] Chỉ một file nhận là nguồn sự thật cho mỗi chủ đề.
- [ ] File env mẫu tên `.env.example`; `.env` bị ignore; không có file quyền cá nhân của agent trong git.
- [ ] Mỗi gotcha có ngày kiểm lần cuối; gotcha mâu thuẫn với code hiện tại đã được sửa/xoá.

## 4. Vị trí & adapter

- [ ] Mỗi file đặt đúng chỗ công cụ đọc (principles §5).
- [ ] Adapter chỉ trỏ về `AGENTS.md` + phần riêng công cụ.
- [ ] Mọi file docs được ít nhất một file khác trỏ tới.
- [ ] Không file tri thức bị `.gitignore` / `.git/info/exclude`.

## 5. Chất lượng chung

- [ ] Không sự thật nào ghi ở hai nơi.
- [ ] Không yêu cầu bịa: mọi REQ truy được về lời người dùng hoặc bằng chứng repo.
- [ ] Không placeholder, không TODO không gắn issue.
- [ ] Viết khẳng định trước, câu cấm chỉ cho ranh giới cứng.

## 6. Mức 1–2 (nếu áp dụng)

- [ ] Mỗi thành phần mức 1–2 có tín hiệu biện minh trong đề xuất.
- [ ] Design có phương án đã loại, rủi ro + rollback, map REQ → thành phần.
- [ ] Contract là file máy đọc; spec chỉ link.
- [ ] Plan có phụ thuộc/song song, checklist theo loại thay đổi, ngữ cảnh tối thiểu mỗi PR.
- [ ] AC phụ thuộc hạ tầng gắn `[~]` kèm lý do + cách đóng.
- [ ] Skill dự án: `name` ≤ 64 ký tự, `description` ngôi thứ ba nêu làm gì + khi nào, body < 500 dòng; không trùng skill global.
- [ ] Hook/settings đã review; deny-rules cho file nhạy cảm.
- [ ] Luật đã có check tự động chỉ còn một dòng văn xuôi trỏ tới check.
- [ ] Docs điều khiển agent (AGENTS.md, skill, rule, hook) nằm dưới CODEOWNERS.

## 7. Thử tài liệu (Bước 7)

- [ ] Đã giao 2–3 task mẫu trong phiên mới.
- [ ] Ghi lại luật bị bỏ qua, câu hỏi thừa, việc làm thừa — và đã sửa docs tương ứng.
