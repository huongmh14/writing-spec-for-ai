# PK-RELEASE — Docker, registry, phát hành

> Tín hiệu bật: Có Docker image hoặc binary phát hành
> Gốc ý tưởng (skill/repo tham khảo nội bộ, không phải bằng chứng): cdn, citad-crawler-work-schedule, citad-vmu-resources, dashboard, BotAutoTask

## Tham số

| Tham số | Mặc định | Mô tả |
|---|---|---|
| `{release-branch}` | `release/v*` | Nhánh/hoặc pattern tag cho phát hành |
| `{image-registry}` | - | Registry nơi push image (Docker Hub, GHCR, private) |
| `{artifact-path}` | `dist/` | Đường dẫn artifact build được (binary, bundle) |
| `{changelog-path}` | `CHANGELOG.md` hoặc `docs/changelog/` | Đường dẫn changelog theo version |

## REQ (EARS)

| ID | REQ |
|---|---|
| PK-RELEASE-R01 | `.env.example` MUST đủ mọi biến môi trường cần thiết; ứng dụng MUST validate env lúc khởi động và báo gộp mọi lỗi (không fail silent). |
| PK-RELEASE-R02 | Image/binary MUST build từ tag `{release-branch}` theo semver; tag image/binary = phiên bản (không dùng `latest`). |
| PK-RELEASE-R03 | Container Docker MUST chạy bằng user non-root; Dockerfile MUST dùng multi-stage build. |
| PK-RELEASE-R04 | Mỗi phiên bản MUST có changelog; breaking change MUST có hướng dẫn nâng cấp trong `docs/upgrade/` hoặc changelog. |
| PK-RELEASE-R05 | PR vào nhánh môi trường (staging, production) MUST ghi kế hoạch rollback (= triển khai lại tag trước). |
| PK-RELEASE-R06 | Nếu artifact build được commit vào repo (vd. bundle, dist), CI MUST kiểm artifact khớp nguồn (hash hoặc integrity check). |

## AC mẫu (Cho/Khi/Thì)

| ID | AC |
|---|---|
| PK-RELEASE-AC01 | **Cho** khởi động ứng dụng. **Khi** `.env.example` thiếu biến cần thiết. **Thì** validate env báo lỗi "Thiếu biến: {tên}". |
| PK-RELEASE-AC02 | **Cho** khởi động ứng dụng. **Khi** env có giá trị sai type/format. **Thì** validate env báo lỗi "Giá trị sai: {tên} = {giá trị}". |
| PK-RELEASE-AC03 | **Cho** Dockerfile. **Khi** build image. **Thì** dùng multi-stage, chạy user non-root. |
| PK-RELEASE-AC04 | **Cho** CI build. **Khi** tag `{release-branch}` được push. **Thì** build image với tag = phiên bản (vd. `v1.2.3`). |
| PK-RELEASE-AC05 | **Cho** PR vào production. **Khi** PR description. **Thì** có mục "Rollback: deploy v1.2.2". |
| PK-RELEASE-AC06 | **Cho** CI. **Khi** artifact commit vào `{artifact-path}`. **Thì** kiểm hash artifact khớp nguồn. |

## Dòng thêm vào AGENTS.md

### ✅ Luôn
- Thêm biến môi trường: thêm vào `.env.example` và validate khởi động.
- Build image: từ tag semver, tag image = phiên bản.
- Dockerfile: multi-stage build, user non-root.
- Phát hành version: thêm entry changelog.
- Breaking change: thêm hướng dẫn nâng cấp.
- PR môi trường: ghi kế hoạch rollback.
- Artifact commit: CI kiểm khớp nguồn.

### ⚠️ Hỏi trước
- Đổi `{release-branch}` hoặc pattern tag.
- Bỏ validate env lúc khởi động.
- Dùng tag `latest` cho image.
- Chạy container bằng user root.
- Phát hành mà không có changelog.

### 🚫 Không bao giờ
- Bỏ `.env.example` hoặc thiếu biến.
- Build image từ nhánh không phải tag.
- Dùng tag `latest` cho production.
- Chạy container bằng user root.
- Phát hành breaking change mà không có hướng dẫn nâng cấp.
- PR môi trường mà không có kế hoạch rollback.
- Commit artifact mà không kiểm khớp nguồn.

## Mục khảo sát bổ sung (cho survey-project)

- Có `.env.example` không? Đủ biến không?
- Có validate env lúc khởi động không?
- Có Dockerfile không? Multi-stage không? Non-root user không?
- CI build từ tag hay nhánh? Tag image là gì?
- Có changelog không? Bắt buộc không?
- Breaking change có hướng dẫn nâng cấp không?
- PR môi trường có kế hoạch rollback không?
- Có artifact commit vào repo không? Có kiểm khớp nguồn không?

## Gotchas

| Triệu chứng | Nguyên nhân | Cách tránh | Kiểm lần cuối |
|---|---|---|---|
| Ứng dụng chạy nhưng env thiếu, lỗi runtime | Không validate env lúc khởi động | Validate env MUST fail-fast nếu thiếu/sai | 2026-10-20 |
| Dùng tag `latest` cho production, không biết version nào đang chạy | CI build/tag dùng `latest` | Build từ tag semver, tag image = version | 2026-10-20 |
| Container chạy root, rủi ro bảo mật | Dockerfile không chỉ định user non-root | Dockerfile MUST có `USER nonroot` | 2026-10-20 |
| Phát hành mà không có changelog, không biết đổi gì | Changelog không bắt buộc hoặc quên | Mỗi version MUST có changelog entry | 2026-10-20 |
| Breaking change, team không biết cách nâng cấp | Không có hướng dẫn nâng cấp | Breaking change MUST có upgrade guide | 2026-10-20 |
| PR deploy không có rollback, hỏng không biết lùi lại | Không yêu cầu kế hoạch rollback | PR template MUST có section "Rollback" | 2026-10-20 |
| Artifact build không khớp nguồn, có thể bị tamper | Không kiểm hash integrity | CI MUST kiểm artifact hash vs source | 2026-10-20 |
