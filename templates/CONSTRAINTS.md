# CONSTRAINTS.md — <tên dự án>

> Kiểm lần cuối: `<YYYY-MM-DD>` bởi `<@owner>`
> Nguồn sự thật về sàn chất lượng được kiểm bằng lệnh máy. Không hạ ngưỡng hoặc xoá quy tắc trong file này để làm PR/test qua.

## 1. Sàn cứng (Floor — luôn áp dụng, kiểm trên git diff)

- Không thêm cờ bịt miệng trình kiểm tra mới: `@ts-ignore`, `@ts-expect-error` không lý do, `eslint-disable`, `biome-ignore`, `# noqa`, `# type: ignore`, `istanbul ignore`, `nosemgrep`, `gitleaks:allow`.
- Không để hàm rỗng / chưa cài đặt trong code giao: `throw new Error("Not implemented")`, `TODO` thay cho nhánh xử lý thật, `catch {}` rỗng nuốt lỗi.
- Không thêm `.skip`, `.only`, xoá file test, hoặc rút assertion khỏi test hiện có để làm test xanh.
- Không có secret, token, khóa riêng tư trong mã nguồn hoặc log.
- Không sửa giảm ngưỡng trong file `CONSTRAINTS.md` cùng commit với tính năng đang bị đỏ.

## 2. Ngưỡng cưỡng chế bằng lệnh (Enforced with numbers)

Mỗi dòng bắt buộc có lệnh kiểm tra thực tế ở cột `Lệnh kiểm`. Một con số không có lệnh kiểm chỉ là mong muốn, không phải ràng buộc.

| Chiều chất lượng | Ngưỡng bắt buộc | Lệnh kiểm (`Checked by`) | Chạy ở giai đoạn | Lý do chọn ngưỡng |
|---|---|---|---|---|
| Kiểu (Types) | 0 lỗi kiểu | `<tsc --noEmit / mypy .>` | Mọi lần sửa (`check:fast`) | Chặn lỗi sai hợp đồng giữa các module ngay lúc viết |
| Lint | 0 lỗi lint | `<eslint . / biome check / ruff check>` | Mọi lần sửa (`check:fast`) | Giữ quy ước code đồng nhất |
| Secrets | 0 phát hiện lộ khoá | `<gitleaks detect --redact --no-banner>` | Trước commit / CI (`check:fast`) | Chặn lộ thông tin xác thực vào git và log |
| Coverage (code mới) | Dòng thay đổi ≥ `<80%>` | `<vitest run --coverage / pytest --cov>` | Cuối task & CI (`check:task`) | Đảm bảo mọi nhánh mới đều có test bảo vệ |
| Bảo mật phụ thuộc | 0 lỗ hổng mức High/Critical | `<npm audit --audit-level=high / osv-scanner>` | CI (`check:full`) | Chặn CVE nghiêm trọng từ thư viện bên thứ ba |

## 3. Bánh cóc chất lượng (Ratchets — đo và giữ không tụt lùi)

Dùng cho các chỉ số toàn cục chưa đạt ngưỡng lý tưởng nhưng tuyệt đối không được tệ hơn hiện trạng:

| Chỉ số | Giá trị hiện tại (Baseline) | Chiều bắt buộc | Lệnh đo |
|---|---|---|---|
| Độ phủ test toàn dự án | `<vd: 64.2%>` | Không được giảm (`must not fall`, dung sai `0.5%`) | `<lệnh chạy coverage>` |
| Dung lượng bundle / binary | `<vd: 180 kB>` | Không được tăng quá `<+5%>` | `<lệnh build & đo size>` |

## 4. Ngoại lệ có thời hạn (Exceptions)

Mọi ngoại lệ phải có chủ sở hữu (`Owner`) và ngày hết hạn (`Expires` ≤ 90 ngày). Không xoá luật chung để chiều một ngoại lệ.

| ID | Luật được miễn | Phạm vi đường dẫn | Lý do & Ticket xử lý | Owner | Ngày hết hạn |
|---|---|---|---|---|---|
| `EX-01` | `<tên luật>` | `<src/legacy/**>` | `<Lý do kỹ thuật — gắn issue/D-xx>` | `<@tên>` | `<YYYY-MM-DD>` |
