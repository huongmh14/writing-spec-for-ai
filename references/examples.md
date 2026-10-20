# Ví dụ chuẩn (lấy từ dự án thật, đã chú giải)

Nguồn: bộ spec của nền tảng dashboard (NestJS + Quasar + Prisma). Mọi ví dụ dưới đây là REQ/AC **đã nghiệm thu bằng test** — dùng làm chuẩn so sánh khi viết spec mới. Gốc: `docs/specs/04-rbac.md`, `13-security-nfr.md`, `docs/decisions.md`.

## 1. REQ theo mẫu EARS

| Ví dụ thật | Mẫu EARS | Vì sao đạt |
|---|---|---|
| `RBAC-R01` — User không ở trạng thái ACTIVE có quyền hiệu lực rỗng. | Trạng thái | Điều kiện + kết quả quantified ("rỗng" kiểm được) |
| `RBAC-R16` — Thiếu quyền ⇒ 403 `AUTH_FORBIDDEN`. | Lỗi | Có mã HTTP + mã lỗi cụ thể |
| `RBAC-R21` — Thay đổi **thu hẹp** (bớt quyền, deprecate vai trò) áp dụng ngay khi sync, tăng `permVersion` user bị ảnh hưởng, ghi AuditLog. | Sự kiện | Sự kiện + 3 hệ quả quan sát được |
| `RBAC-R15` — Mọi thay đổi ảnh hưởng quyền hiệu lực … tăng `permVersion` của **mọi** user bị ảnh hưởng **trong cùng transaction**. | Sự kiện | Định lượng "mọi", ràng buộc "cùng transaction" — đủ hẹp để test |
| `RBAC-R30` — MUST (GĐ2) — Scope `ORG`/`ORG_TREE` dựa trên `OrgUnit.path`… | Tuỳ chọn + giai đoạn | Có thời điểm làm, agent không làm trước |

Đối chiếu: câu viết hỏng `"Hệ thống phải bảo mật và phân quyền linh hoạt"` — không mẫu EARS, không số, không kiểm được.

## 2. AC dạng Cho / Khi / Thì

| AC thật | Cấu trúc |
|---|---|
| `RBAC-AC03` — *Cho* user có `orders:*` và DENY `orders:delete`, *khi* gọi `DELETE /orders/:id`, *thì* 403. | Biên trừu tượng thắng wildcard, dữ liệu đầu vào cụ thể |
| `RBAC-AC07` — *Cho* nhóm có 50 thành viên, *khi* sửa quyền của nhóm, *thì* `permVersion` của cả 50 user tăng trong cùng transaction. | Số lượng cụ thể (50), hệ quả đếm được |
| `RBAC-AC12` — *Cho* chỉ còn một SUPER_ADMIN ACTIVE, *khi* khoá tài khoản đó, *thì* 409 `RBAC_LAST_SUPER_ADMIN`. | AC cho nhánh lỗi, có mã lỗi |
| `RBAC-AC18` — *Cho* cùng bộ quyền hiệu lực và mã yêu cầu (gồm wildcard), *khi* chạy `matchPermission` ở BE và FE, *thì* kết quả giống nhau (test dùng chung bộ dữ liệu). | Contract chạy nhiều runtime + test vectors dùng chung |
| `NFR-AC08` — *Cho* một user gọi `POST /reports/:code/runs` vượt ngưỡng (10 lần/phút), *khi* gửi, *thì* các request vượt ngưỡng nhận 429 `RATE_LIMITED` và user khác không bị ảnh hưởng. | NFR có AC: ngưỡng số + điều kiện không lan sang người khác |

## 3. NFR thay tính từ bằng số

| Tính từ mơ hồ | REQ đạt (thật) |
|---|---|
| "nhanh" | `NFR-R20` — Chi phí guard quyền p95 < 5 ms (cache nóng). |
| "chống spam" | `NFR-R02` — Rate limit lưu Redis: theo IP trên `/auth/*`; theo user trên gửi OTP và xuất báo cáo (mặc định 10 lần/phút). |
| "có giám sát" | `NFR-R23` — Metric Prometheus: thời gian phản hồi, tỉ lệ lỗi, độ dài hàng đợi, số lần 2FA thất bại. |
| "test đủ" | `NFR-R24` — Độ phủ test ≥ 80% cho `rbac`, `auth`, `mfa`; CI chặn merge nếu giảm dưới ngưỡng. |
| "khỏi phục được" | `NFR-R26` — Backup PostgreSQL hằng ngày + WAL archiving, lưu ngoài máy chủ; diễn tập khôi phục định kỳ. |

## 4. Dòng quyết định (decisions.md)

| ID | Ngày | Quyết định | Lý do tóm tắt | Spec |
|---|---|---|---|---|
| D-08 | 2026-09-23 | Đăng nhập Google + 2FA riêng: OTP email mặc định bắt buộc; TOTP tuỳ chọn; khi có TOTP thì OTP email là phương thức thứ cấp | Yêu cầu nghiệp vụ | SPEC-MFA |
| D-11 | 2026-09-23 | Image đẩy lên registry nội bộ. **Thay thế phần "trên GHCR" của D-04**; phần còn lại của D-04 giữ nguyên | Dùng registry nội bộ | SPEC-REPO |

Điểm đạt: một dòng một quyết định; dòng thay thế ghi rõ *thay phần nào* của dòng cũ; có Spec đích để truy vết.

## 5. Chia khu vực spec cho một dự án (19 spec của dashboard)

```
Kiến trúc/lõi phương tiện: ARCH, REPO, MOD, DATA, API, NFR, ROADMAP, DOCS
Miền năng lực:            RBAC, AUTH, MFA, PASSKEY, ADMIN, UIKIT, WIDGET, REPORT, DATASET, NOTIF, INTEG, CLI
```

Quy tắc rút ra: mỗi spec trả lời được "ai dùng tính năng này để làm gì"; spec phương tiện (REPO, API, NFR) chỉ dành cho cái mọi module cùng phải theo. Đơn vị tự nhiên: 1 spec ≈ 10–25 REQ ≈ 1–3 giai đoạn làm việc.

## 6. Plan theo PR (docs/plans/M6.md, rút gọn)

| PR | Nhánh | Nội dung | AC | Phụ thuộc | Song song |
|---|---|---|---|---|---|
| 1 | `feat/SPEC-MOD-ext` | DomainEventBus, AuthHooks, ScopeResolver | MOD-AC20, AUTH-AC04 | — | [P] với 2 |
| 2 | `feat/SPEC-API-users` | `/users*`, `/me/permissions` | API-AC01, NFR-AC07 | 1 | |

Kèm "ngữ cảnh tối thiểu" mỗi PR: link đúng mục spec + file liên quan, để agent không nạp cả spec.

## 7. Sửa câu mơ hồ (trước → sau)

| Trước (không dùng được) | Sau (đạt) |
|---|---|
| "Đăng nhập an toàn" | `AUTH-R01` — Khi nhận ID token Google, hệ thống MUST verify chữ ký, `aud`, `iss`, `exp`, `email_verified` phía server; sai ⇒ 401 `AUTH_INVALID_TOKEN`. |
| "Xuất báo cáo không làm chậm hệ thống" | `REP-R04` — Xuất file chạy nền qua hàng đợi; `POST /reports/:code/runs` rate limit 10 lần/phút/user (D-27). |
| "Giao diện phân quyền theo vai trò" | `RBAC-R41` — Directive `v-can` (ẩn) và `v-can.disable` (vô hiệu hoá) theo quyền hiệu lực. |
