# PK-FE — Frontend UI, Design System, Accessibility & Browser Verification

> Tín hiệu bật: Có giao diện người dùng (Web React/Vue/Quasar/Svelte/Next.js, HTML/CSS, Desktop/Electron, hoặc Dashboard)
> Gốc ý tưởng (skill/repo tham khảo nội bộ, không phải bằng chứng): dashboard, khaosatvmu + plugins `ui-ux-pro-max`, `playwright`, skills `impeccable`, `frontend-ui-engineering`, `design-system`

## Tham số

| Tham số | Mặc định | Mô tả |
|---|---|---|
| `{a11y-standard}` | `WCAG 2.2 AA` | Tiêu chuẩn trợ năng áp dụng cho các màn hình |
| `{lcp-budget-ms}` | `2500` | Ngưỡng tối đa cho Largest Contentful Paint (ms) |
| `{cls-budget}` | `0.1` | Ngưỡng tối đa cho Cumulative Layout Shift |
| `{tokens-path}` | `src/styles/tokens.css` | File hoặc thư mục định nghĩa Design Tokens (màu sắc, khoảng cách, cỡ chữ) |
| `{e2e-runner}` | `npx playwright test` | Lệnh chạy kiểm thử trình duyệt (E2E) |

## REQ (EARS)

| ID | REQ |
|---|---|
| PK-FE-R01 | Với mọi màn hình hoặc thành phần giao diện có tải dữ liệu bất đồng bộ, hệ thống MUST hiển thị rõ ràng đủ 4 trạng thái: **Đang tải (`loading`)**, **Trống (`empty`)**, **Lỗi (`error` kèm hành động thử lại hoặc hướng dẫn)**, và **Có dữ liệu / Không đủ quyền (`success` / `forbidden`)**. |
| PK-FE-R02 | Khi xây dựng hoặc sửa thành phần giao diện, hệ thống MUST sử dụng các biến Design Tokens từ `{tokens-path}` (màu ngữ nghĩa, thang khoảng cách, kiểu chữ) thay vì gán cứng (hardcode) mã màu hex hoặc số đo pixel rời rạc. |
| PK-FE-R03 | Mọi thành phần tương tác (nút bấm, biểu mẫu, hộp thoại, bảng, menu) MUST đạt chuẩn `{a11y-standard}`: điều khiển được hoàn toàn bằng bàn phím (`Tab`, `Enter`, `Escape`), quản lý tiêu điểm (focus trap trong modal), có nhãn ngữ nghĩa (`aria-label` / `<label>`), và không phát sinh lỗi mức `critical` hoặc `serious` khi quét bằng `axe-core`. |
| PK-FE-R04 | Khi gửi biểu mẫu (form submission) hoặc kích hoạt hành động ghi dữ liệu, hệ thống MUST vô hiệu hoá nút gửi hoặc chặn gửi lặp trong khi yêu cầu đang chờ phản hồi (`isPending`), đồng thời gắn thông báo lỗi trực tiếp vào từng trường bị sai nếu server trả lỗi 400. |
| PK-FE-R05 | Khi tải trang chính trên trình duyệt chuẩn, giao diện MUST giữ chỉ số `LCP ≤ {lcp-budget-ms}` ms và `CLS ≤ {cls-budget}` (không nhảy bố cục khi ảnh, font hoặc dữ liệu tải xong). |
| PK-FE-R06 | Mọi bài kiểm thử trình duyệt (`{e2e-runner}`) MUST định vị phần tử thông qua vai trò ngữ nghĩa (`getByRole`, `getByLabel`, `getByText`) hoặc `data-testid` ổn định và chờ theo điều kiện trạng thái quan sát được, MUST NOT dùng `waitForTimeout` / `sleep` cố định hoặc bộ chọn CSS phụ thuộc cấu trúc thẻ nội bộ. |

## AC mẫu (Cho/Khi/Thì)

| ID | AC |
|---|---|
| PK-FE-AC01 | **Cho** màn hình danh sách dữ liệu. **Khi** API lần lượt trả mảng rỗng `[]` và trả lỗi HTTP 500. **Thì** giao diện hiển thị đúng vùng trạng thái `empty` (có thông điệp rõ ràng) và trạng thái `error` (có nút thử lại), không để màn hình trắng hoặc treo spinner vô tận *(e2e/component)*. |
| PK-FE-AC02 | **Cho** biểu mẫu tạo/cập nhật bản ghi. **Khi** người dùng nhấn đúp liên tiếp vào nút "Lưu" trong khi mạng chậm. **Thì** nút chuyển sang trạng thái chờ (`disabled`/`aria-busy="true"`) ngay từ lần nhấn đầu và chỉ có đúng 1 request được gửi lên server *(e2e)*. |
| PK-FE-AC03 | **Cho** trang giao diện đã render trên trình duyệt. **Khi** người dùng chỉ dùng bàn phím (`Tab`, `Shift+Tab`, `Enter`, `Escape`) để mở hộp thoại, điền form và đóng hộp thoại, đồng thời chạy kiểm tra `axe-core`. **Thì** mọi phần tử tương tác đều có vòng focus nhìn thấy rõ, focus quay về nút mở sau khi đóng modal, và kết quả `axe` có `0` vi phạm `critical`/`serious` *(e2e)*. |

## Dòng thêm vào AGENTS.md

### ✅ Luôn
- Tạo màn hình/bảng dữ liệu mới: cài đặt đủ 4 trạng thái (`loading`, `empty`, `error`, `data`).
- Dùng biến màu sắc, khoảng cách, font từ `{tokens-path}` hoặc hệ thống class chuẩn của dự án.
- Viết test E2E bằng `{e2e-runner}`: dùng `getByRole` / `getByLabel` / `data-testid` và assertion tự chờ (auto-retrying assertions).

### ⚠️ Hỏi trước
- Thêm thư viện UI component, thư viện icon, hoặc thư viện quản lý state mới.
- Thay đổi bộ biến gốc trong `{tokens-path}` hoặc thay đổi bố cục khung (layout shell) toàn cục.

### 🚫 Không bao giờ
- Để nút submit form có thể bị bấm lặp gửi nhiều request trùng khi request trước chưa xong.
- Dùng `page.waitForTimeout(ms)` / `sleep` cứng trong bài test E2E.
- Dùng thẻ `<div>` hoặc `<span>` gắn `onClick` thay cho `<button>` / `<a>` mà không có `role`, `tabIndex`, và xử lý phím `Enter`/`Space`.

## Mục khảo sát bổ sung (cho survey-project)

- Dự án dùng UI framework/component library nào (Quasar, shadcn/ui, Tailwind, MUI…)?
- Các màn hình hiện tại có xử lý trạng thái `empty` và `error` hay chỉ viết luồng `happy path`?
- Đã có cấu hình `{e2e-runner}` (Playwright/Cypress) chưa? Trong test hiện có có đang dùng `waitForTimeout` hoặc selector CSS dễ gãy không?
- Có file định nghĩa Design Tokens tập trung (`{tokens-path}`) chưa?

## Gotchas

| Triệu chứng | Nguyên nhân | Cách tránh | Kiểm lần cuối |
|---|---|---|---|
| Test Playwright lúc xanh lúc đỏ (flaky) trên CI | Dùng `waitForTimeout(1000)` hoặc click trước khi hydration/API hoàn tất | Dùng `await expect(locator).toBeVisible()` / chờ đúng response hoặc trạng thái DOM | 2026-10-20 |
| Màn hình bị giật nhảy (`CLS > 0.1`) khi dữ liệu hoặc ảnh vừa tải về | Không đặt kích thước khung giữ chỗ (skeleton / `aspect-ratio`) cho vùng đang tải | Luôn giữ chiều cao cố định hoặc skeleton tương đương kích thước thật ở trạng thái `loading` | 2026-10-20 |
| Chế độ Dark Mode hoặc đổi theme bị sót chữ trắng trên nền trắng | Hardcode mã màu `#fff` / `#000` trực tiếp trong component thay vì dùng semantic token | Bắt buộc đi qua biến ngữ nghĩa (`--color-surface`, `--color-text-primary`) trong `{tokens-path}` | 2026-10-20 |
