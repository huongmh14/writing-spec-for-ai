# PK-AUTH — Token, khoá, chữ ký

> Tín hiệu bật: Có xác thực, API key, webhook, hoặc token
> Gốc ý tưởng (skill/repo tham khảo nội bộ, không phải bằng chứng): cdn, notification-service, dashboard, BotAutoTask

## Tham số

| Tham số | Mặc định | Mô tả |
|---|---|---|
| `{hash-algo}` | `bcrypt` hoặc `argon2` | Thuật toán hash cho secret/khoá |
| `{salt}` | - | Salt dùng khi hash (không hardcode) |
| `{token-typ-claim}` | `typ` | Claim trong JWT chỉ định loại token (access/refresh/api-key) |
| `{refresh-ttl}` | `7d` | Time-to-live cho refresh token |
| `{hmac-algo}` | `sha256` | Thuật toán HMAC cho URL/webhook ký |
| `{hmac-ttl}` | `300` | Giây hết hạn cho HMAC signature (tham số `exp`) |

## REQ (EARS)

| ID | REQ |
|---|---|
| PK-AUTH-R01 | Secret/khoá/password MUST lưu dạng hash có salt; giá trị gốc chỉ trả về đúng một lần khi tạo. |
| PK-AUTH-R02 | So sánh secret/khoá/password MUST dùng phép so sánh constant-time (không bị timing attack). |
| PK-AUTH-R03 | Mỗi loại token MUST mang claim loại (`{token-typ-claim}`); endpoint MUST từ chối token sai loại. |
| PK-AUTH-R04 | Refresh token MUST duy nhất cho mỗi lần cấp, quay vòng sau mỗi lần dùng, có thể thu hồi được. |
| PK-AUTH-R05 | URL/webhook có ký MUST dùng HMAC kèm tham số `exp`; quá hạn `{hmac-ttl}` giây thì bị từ chối. |
| PK-AUTH-R06 | Nếu thiếu hoặc hỏng cấu hình xác thực (secret, salt, public key), hệ thống MUST từ chối khởi động hoặc request (fail-closed). |
| PK-AUTH-R07 | Hệ thống MUST NOT log token, mật khẩu, header `Authorization`, secret, hoặc bất kỳ giá trị nhạy cảm. |

## AC mẫu (Cho/Khi/Thì)

| ID | AC |
|---|---|
| PK-AUTH-AC01 | **Cho** endpoint tạo API key. **Khi** tạo thành công. **Thì** trả key gốc đúng một lần; lưu hash có salt. |
| PK-AUTH-AC02 | **Cho** endpoint đăng nhập. **Khi** so sánh password. **Thì** dùng constant-time compare. |
| PK-AUTH-AC03 | **Cho** endpoint chấp nhận JWT. **Khi** token thiếu claim `{token-typ-claim}` hoặc claim sai. **Thì** trả 401. |
| PK-AUTH-AC04 | **Cho** endpoint refresh token. **Khi** dùng refresh token. **Thì** token cũ bị vô hiệu, trả token mới. |
| PK-AUTH-AC05 | **Cho** webhook endpoint. **Khi** nhận signature HMAC. **Thì** kiểm `exp` > hiện tại; quá hạn thì từ chối. |
| PK-AUTH-AC06 | **Cho** khởi động ứng dụng. **Khi** thiếu biến env `JWT_SECRET` hoặc `API_KEY_SALT`. **Thì** fail-fast, không chạy. |
| PK-AUTH-AC07 | **Cho** log request. **Khi** có header `Authorization`. **Thì** log chỉ ghi "có auth", không ghi giá trị. |

## Dòng thêm vào AGENTS.md

### ✅ Luôn
- Lưu secret/khoá: hash có salt, chỉ trả gốc một lần.
- So sánh secret: dùng constant-time compare.
- Tạo token: thêm claim `{token-typ-claim}`.
- Refresh token: implement quay vòng (rotation).
- Ký webhook: dùng HMAC + `exp`.
- Khởi động: validate env cấu hình auth; thiếu thì fail-closed.
- Log: KHÔNG log token, password, secret, header `Authorization`.

### ⚠️ Hỏi trước
- Đổi thuật toán hash `{hash-algo}`.
- Đổi `{refresh-ttl}` hoặc `{hmac-ttl}`.
- Bỏ validation cấu hình auth lúc khởi động (nghịch lý fail-closed).
- Thêm loại token mới (cần update claim `{token-typ-claim}`).

### 🚫 Không bao giờ
- Lưu secret/khoá/password dạng plaintext.
- So sánh secret bằng phép so sánh bình thường (`===`, `==`).
- Log token, password, secret, header `Authorization`.
- Refresh token không quay vòng (dùng lại mãi một token).
- Webhook ký không có `exp` hoặc không kiểm `exp`.
- Chạy với cấu hình auth thiếu/hỏng (fail-open).

## Mục khảo sát bổ sung (cho survey-project)

- Có API key/password/secret không? Lưu dạng gì?
- Có dùng JWT không? Có claim `typ` không?
- Có refresh token không? Có quay vòng không?
- Có webhook được ký không? Dùng HMAC gì? Có kiểm `exp` không?
- Có validate env cấu hình auth lúc khởi động không?
- Có log token/password không?

## Gotchas

| Triệu chứng | Nguyên nhân | Cách tránh | Kiểm lần cuối |
|---|---|---|---|
| Log rò rỉ token/password trong production | Log request/response có header/body nhạy cảm | Log filter; blacklist header `Authorization` | 2026-10-20 |
| Timing attack phát hiện user tồn tại | So sánh password bằng `===` hoặc `==` | Dùng constant-time compare (bcrypt.compare, crypto.timingSafeEqual) | 2026-10-20 |
| Refresh token bị reuse, không thu hồi được | Token không quay vòng, dùng mãi một token | Implement rotation: mỗi lần dùng → tạo mới, vô hiệu cũ | 2026-10-20 |
| Webhook bị replay attack | Signature không có `exp` hoặc không kiểm | Thêm `exp` vào payload signed, kiểm trước khi verify | 2026-10-20 |
| Chạy với cấu hình auth thiếu/hỏng | Không validate env lúc khởi động, default null | Validate tất cả biến env cần thiết; thiếu thì fail-fast | 2026-10-20 |
| Token sai loại vẫn được chấp nhận | Endpoint không kiểm claim `{token-typ-claim}` | Mọi endpoint protected MUST kiểm `typ` | 2026-10-20 |
