# CHANGELOG — writing-spec-for-ai (base)

Mỗi phiên bản liệt kê ID luật đổi (Core `C-xx`, Pack `PK-…-Rnn`; sổ đăng ký: [references/base-kit.md](references/base-kit.md)). Dự án đang dùng base grep các ID này trong docs của mình để biết chỗ phải xem lại.

## v1.1.0 — 2026-10-20

### Thêm

- `packs/PK-API.md` — Pack HTTP API với REQ PK-API-R01–R07, AC mẫu, dòng AGENTS.md, mục khảo sát, gotchas.
- `packs/PK-AUTH.md` — Pack token/khoá/chữ ký với REQ PK-AUTH-R01–R07, AC mẫu, dòng AGENTS.md, mục khảo sát, gotchas.
- `packs/PK-RELEASE.md` — Pack Docker/registry/phát hành với REQ PK-RELEASE-R01–R06, AC mẫu, dòng AGENTS.md, mục khảo sát, gotchas.
- `profiles.md` — Profile S/M/L với dấu hiệu, file tối thiểu, ví dụ, khi nào nâng cấp.
- `skills/propose-doc-design/SKILL.md`: cập nhật để hỏi profile và pack khi đề xuất docs.
- `templates/doc-design-proposal.md`: cập nhật mục 2 để khai báo base/profile/pack.
- `references/review-checklist.md`: thêm mục kiểm REQ kế thừa (tham chiếu đúng ID pack, tham số đã điền) và mục kiểm pack khai báo trong AGENTS.md.
- `references/base-kit.md` §6: trỏ REQ chi tiết sang file pack thay vì chứa nháp REQ (một sự thật một chỗ).
- `references/base-kit.md` §7.4: trỏ chi tiết profile sang `profiles.md`.
- `references/base-kit.md` §8: đánh dấu GĐ2 xong, trạng thái `v1.1.0`.
- `README.md` (English open-source edition) + `README.vi.md` (bản tiếng Việt): thêm cấu trúc `packs/`, `profiles.md`, hướng dẫn cài đặt đa nền tảng.
- Đóng gói Open-Source & Plugin Manifests: `LICENSE` (MIT), `install.ps1`, `install.sh`, `.claude-plugin/`, `.cursor-plugin/`, `.copilot-plugin/`, `.zcode-plugin/`, `.github/workflows/release.yml` (tự động đóng gói full-suite `.zip` và 7 standalone sub-skill `.zip` khi push tag `v*`).

### Sửa

- Không có thay đổi luật Core (C-xx), chỉ thêm tầng Pack và Profile.

## v1.0.0 — 2026-10-20

Phiên bản đầu tiên được ghim. Có từ trước (C01, C02, C04–C09, C12–C14, C17, C21, C22): bộ điều phối + 7 sub-skill + templates.

### Thêm

- **C03** Quyền AI theo trạng thái spec — `templates/docs/specs/README.md`, principles §2 (0.15).
- **C10** Ngoại lệ hotfix: spec cập nhật ≤ 1 ngày làm việc, nợ ghi vào progress — `templates/docs/specs/README.md`.
- **C11** Bảng "loại thay đổi → file phải sửa" — `templates/docs/specs/README.md`, principles §2 (0.16).
- **C15** 3 luật xử lý lỗi — `templates/AGENTS.md` mục Quy ước code.
- **C16** `.env.example` + `docs/reference/config.md`; không commit file quyền cá nhân của agent — `templates/AGENTS.md`, `templates/adapters/claude-settings.json`.
- **C18** Gotcha có ngày kiểm lần cuối — `templates/project-skill/SKILL.md`.
- **C19** AC cho lệnh vận hành kiểm tác dụng — `skills/write-spec` §5.
- **C20** Đổi stack là một change — `templates/docs/specs/README.md`, `skills/survey-project`.
- Template mới: `templates/docs/reference/config.md`, `templates/docs/reference/error-codes.md`, `templates/docs/changelog/_template.md`.
- `templates/AGENTS.md`: dòng khai báo base/profile/pack và mục "Ghi đè base".
- `skills/survey-project`: kiểm CI khớp stack, nhiều "nguồn sự thật", secret & cấu hình, lệnh vận hành.
- `references/review-checklist.md`: mục kiểm cho từng C-xx mới (§1, §2, §3, §3b).
- `references/principles.md` §7.1: lỗi lặp lại giữa 9 dự án.

### Sửa

- `templates/adapters/claude-settings.json`: bỏ `Read(./.env.*)` (chặn luôn `.env.example` vì deny thắng allow), thay bằng danh sách file env thật.
