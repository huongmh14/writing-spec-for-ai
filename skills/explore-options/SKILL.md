---
name: explore-options
description: Dùng khi một quyết định có ≥ 2 lựa chọn khả thi và khó đảo ngược (chạm schema, API công khai, bảo mật, chi phí, kiến trúc), hoặc khi người dùng nói "cho tôi các phương án", "đa góc nhìn", "so sánh cách làm". Sinh 2–4 phương án thật sự khác nhau từ nhiều góc nhìn, phản biện 1 vòng, trình bảng so sánh để người dùng chọn rồi ghi D-xx.
---

# Explore options — khám phá phương án đa góc nhìn

Mục tiêu: người dùng **chọn được** giữa các phương án mà không cần hiểu hết kỹ thuật. AI mở rộng lựa chọn, kiểm chứng và trình bày. **Người dùng chọn**; AI không tự quyết thay.

**Không dùng khi:** việc nhỏ, dễ đảo ngược, hoặc đã có `D-xx` chốt. Gặp trường hợp đó thì làm theo `D-xx` hoặc nêu một đề xuất ngắn.

> Cơ sở (Đã xác minh, 2026-10-26; chi tiết và trích nguyên văn ở [lenses.md](../../references/lenses.md)):
> - Tìm nhiều góc nhìn giúp bài viết bao quát hơn: STORM, Shao et al. 2024, <https://arxiv.org/abs/2402.14207>.
> - Tranh luận nhiều agent *"do not reliably outperform … self-consistency"*: Smit et al. 2023, <https://arxiv.org/abs/2311.17371>. Vì vậy skill chỉ phản biện **1 vòng**.
> - Cách để một model tự đóng nhiều vai chỉ hiệu quả với model mạnh cỡ GPT-4: Wang et al. 2023, <https://arxiv.org/abs/2307.05300>. Vì vậy skill ưu tiên subagent có ngữ cảnh sạch.
> - Khung ghi quyết định lấy theo mẫu MADR: <https://adr.github.io/madr/>.

## Quy trình — mỗi lượt một bước con, dừng chờ người dùng ở bước 1 và bước 5

1. **Đóng khung quyết định.**
   - Viết quyết định thành 1 câu hỏi, ví dụ: *"Lưu phiên đăng nhập ở đâu?"*.
   - Liệt kê ràng buộc đã chốt, mỗi ràng buộc kèm link `D-xx` hoặc `CONSTRAINTS.md`.
   - Liệt kê tiêu chí chọn (ví dụ: chi phí, độ an toàn, công sức, khả năng đổi sau này). Người dùng xếp hạng tiêu chí.
   - Nếu thiếu tiêu chí, hỏi tối đa 3 câu mà chỉ người dùng quyết được (Frontier), mỗi câu kèm đáp án đoán sẵn. Sau đó **dừng** chờ trả lời.
2. **Chọn góc nhìn.**
   - Lấy 2–3 góc nhìn từ [lenses.md](../../references/lenses.md) theo tín hiệu thật, cộng thêm góc nhìn **Phản biện**.
   - Ghi đúng một dòng: `Góc nhìn: … — vì …`.
3. **Sinh phương án độc lập.**
   - Đưa ra 2–4 phương án. Luôn có một phương án **giữ nguyên / làm tối thiểu** để làm mốc so sánh.
   - Nếu chạy được subagent: mỗi góc nhìn một subagent với ngữ cảnh sạch. Chỉ truyền câu hỏi, ràng buộc, tiêu chí và đường dẫn; không truyền lịch sử hội thoại.
   - Nếu không chạy được subagent: làm tuần tự.
   - Hai phương án phải khác nhau ở **ít nhất một đánh đổi cốt lõi** (ví dụ: tự vận hành hay thuê dịch vụ; đồng bộ hay bất đồng bộ). Nếu chỉ khác tên gọi thì gộp làm một.
4. **Phản biện 1 vòng.**
   - Góc nhìn Phản biện tấn công từng phương án: chỗ nào sai được, chi phí ẩn, rủi ro khó đảo ngược.
   - Mở lại từng nguồn được trích. Nguồn không mở được hoặc câu trích không khớp thì hạ nhãn xuống `AI đề xuất`.
   - Không tranh luận nhiều vòng.
5. **Trình bày để chọn** theo khuôn bên dưới, rồi **dừng** chờ người dùng chọn.
6. **Ghi quyết định.**
   - Người dùng chọn xong thì ghi `D-xx` vào `docs/decisions.md` theo khung MADR: *Các phương án đã xét*, *Phương án chọn + lý do*, *Hệ quả*.
   - Các phương án bị loại ghi kèm lý do loại. Nếu đang viết design doc thì đây chính là mục "Phương án đã loại".

## Khuôn trình bày (bước 5)

```markdown
**Quyết định:** <1 câu> · **Tiêu chí (người dùng xếp hạng):** 1. … 2. … 3. …
**Góc nhìn:** <…> — vì <tín hiệu>

| Phương án | Tiêu chí 1 | Tiêu chí 2 | Tiêu chí 3 | Khó đảo ngược? |
|---|---|---|---|---|
| A. Giữ nguyên / tối thiểu | tốt / vừa / kém + 1 lý do | … | … | Dễ |
| B. … | … | … | … | … |

Mỗi phương án kèm một Thẻ quyết định kỹ thuật:
- Nói đơn giản: <không dùng thuật ngữ>
- Nếu sai thì sao: <hậu quả + chi phí quay lại>
- Tự kiểm ≤ 5 phút: <lệnh / link / thao tác người dùng tự làm được>
- Nguồn: <path:line | URL + trích nguyên văn> · Nhãn: Người dùng chốt / Đã xác minh / AI đề xuất / Chưa biết
- Không tự kiểm được: <phần cần chuyên gia, nếu có>

**Điểm khác biệt mấu chốt:** <1–2 câu: chọn A nghĩa là chấp nhận X, chọn B nghĩa là chấp nhận Y>
**AI đề xuất:** <phương án> — vì <tiêu chí>. **Tôi sẽ đổi đề xuất nếu:** <điều kiện cụ thể>
```

Chỉ đánh giá định tính (tốt / vừa / kém); không chấm điểm số hay phần trăm, vì con số tạo cảm giác chính xác giả. Vùng bảo mật, thanh toán, pháp lý ghi "cần chuyên gia".

## Dấu hiệu lỗi — dừng và làm lại

| Dấu hiệu | Sửa |
|---|---|
| Các phương án thực chất là một (chỉ khác tên hoặc thư viện) | Gộp lại; tìm đánh đổi cốt lõi khác |
| Có phương án bù nhìn dựng ra để dễ loại | Thay bằng phương án mà một chuyên gia thật sẽ bảo vệ |
| Góc nhìn chỉ đổi giọng văn ("với tư cách senior…") | Dùng câu hỏi bắt buộc của góc nhìn đó trong `lenses.md` |
| Có hơn 4 phương án, hoặc bảng quá dài | Giữ tối đa 4 phương án; loại sớm phương án vi phạm ràng buộc đã chốt |
| AI tự chọn rồi viết code hoặc docs luôn | Dừng. Chưa có lựa chọn của người dùng thì không có `D-xx` |
| Gắn nhãn "Đã xác minh" nhưng không có nguồn mở được | Hạ nhãn xuống `AI đề xuất` hoặc `Chưa biết` |

## Checklist

- [ ] Có phương án giữ nguyên / tối thiểu; 2–4 phương án, mỗi cặp khác nhau ở ít nhất một đánh đổi cốt lõi.
- [ ] Đã ghi dòng `Góc nhìn: … — vì …`; góc nhìn Phản biện đã chạy đúng 1 vòng.
- [ ] Mỗi phương án có Thẻ quyết định, kèm dòng Tự kiểm ≤ 5 phút và nhãn nguồn gốc.
- [ ] Người dùng chọn; quyết định được ghi vào `D-xx` theo khung MADR.
