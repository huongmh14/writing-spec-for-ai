# Nghiên cứu — spec giúp người dùng kiểm soát AI coding

Ngày đối chiếu nguồn: **2026-10-25**. Phạm vi: giới hạn lượt triển khai và kiểm chứng phần kỹ thuật người dùng chưa tự thẩm định được. Đây là cơ sở cho thay đổi thiết kế; không phải chứng nhận chất lượng hay bằng chứng người dùng đã duyệt mọi quyết định kỹ thuật.

## 1. Vấn đề trong bộ hiện tại

- Bộ đã có trạng thái spec, ba cổng duyệt, Scope Radar và ma trận test. Tuy nhiên, duyệt nội dung một spec chưa trả lời rõ **lượt này AI được thực hiện phần nào và kết thúc ở đâu**. Nhiều spec `Ready` dễ bị hiểu thành hàng đợi được phép chạy.
- Mẫu spec chứa mục tiêu, REQ, NFR và thiết kế, nhưng chưa buộc từng kết luận quan trọng phân biệt **người dùng yêu cầu / quan sát được / AI đề xuất / chưa biết**. Một ngưỡng kỹ thuật do AI tự điền có thể trông giống yêu cầu đã chốt.
- Review bởi một AI khác và test do AI viết đều hữu ích, nhưng chưa thay thế được tiêu chí đúng lấy từ ví dụ nghiệp vụ, tài liệu nguồn hoặc người có chuyên môn.

Các nhận định trên là **phân tích repo**, dựa trên [README.vi.md](../README.vi.md), [base-kit.md](base-kit.md) và [mẫu spec](../templates/docs/specs/_template.md); không phải kết luận thực nghiệm về mọi agent.

## 2. Nguồn sơ cấp và điều thực sự được hỗ trợ

| Nguồn | Kết quả đối chiếu | Hệ quả thiết kế đề xuất |
|---|---|---|
| [GitHub Docs — Best practices for using GitHub Copilot to work on tasks](https://docs.github.com/en/copilot/tutorials/cloud-agent/get-the-best-results) | GitHub khuyên giao việc rõ, phạm vi hẹp, AC đầy đủ và chỉ dẫn file; các việc rộng, mơ hồ hoặc cần hiểu biết nghiệp vụ sâu khó giao hơn. | Mỗi lượt có kết quả quan sát được, AC và phạm vi ghi; tránh lệnh mặc định chạy cả backlog. |
| [Anthropic — Effective harnesses for long-running agents](https://www.anthropic.com/research/effective-harnesses-for-long-running-agents), mục Incremental progress và Testing | Trong thử nghiệm phát triển web, agent làm quá nhiều một lần và đánh dấu xong khi chưa kiểm đầy đủ. Làm từng tính năng, lưu tiến độ và kiểm end-to-end giúp cải thiện kết quả. Bài viết ghi rõ đây là một cách tiếp cận, còn câu hỏi mở. | Một phần việc có thể demo mỗi lượt; lưu bằng chứng và điểm dừng. Không suy rộng thành bảo đảm mọi dự án đều thành công. |
| [Anthropic — Building effective agents](https://www.anthropic.com/research/building-effective-agents), mục Agents và Appendix 1.B | Agent cần phản hồi thực từ công cụ hoặc chạy code; có thể dùng checkpoint và điều kiện dừng. Test tự động hỗ trợ xác minh chức năng; review người vẫn cần cho yêu cầu hệ thống rộng hơn. | Quyết định kỹ thuật đi kèm phép kiểm; báo kết quả thật và giới hạn, thay cho chỉ báo tự tin. |
| [NIST AI 600-1 — Generative AI Profile](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf), §2.2; MS-2.5-003; MS-2.3-002 | NIST mô tả nguy cơ nội dung sai được trình bày tự tin, khuyến nghị kiểm nguồn/citation và đánh giá tuyên bố bằng phương pháp thực nghiệm. | Lưu nguồn gốc kết luận và trạng thái kiểm chứng. Nguồn chính thức vẫn cần được đọc đúng ngữ cảnh và phiên bản. |
| [GitHub Spec Kit — implement.md](https://github.com/github/spec-kit/blob/main/templates/commands/implement.md) | Mẫu lệnh mô tả việc thực hiện tất cả task trong `tasks.md`. Đây là lựa chọn workflow của công cụ, không phải quy tắc mọi bộ spec phải theo. | Khi tái sử dụng skill hoặc lệnh ngoài, phải đối chiếu quyền chạy của dự án; có danh sách task không đồng nghĩa được chạy hết. |

**Phân biệt:** các nguồn hỗ trợ giao việc hẹp, tiến từng bước và kiểm bằng môi trường thực. Cách tách `Ready` khỏi quyền chạy, mẫu biên bản lượt làm và nhãn nguồn gốc dưới đây là **đề xuất cho bộ này**, không phải tiêu chuẩn được các nguồn chứng nhận.

## 3. Thiết kế tối thiểu nên áp dụng

### A. Tách nội dung đã chốt khỏi quyền thực thi

`Ready` nghĩa là yêu cầu đủ rõ để triển khai. Quyền thực thi lấy từ **lệnh hiện hành của người dùng** với phạm vi xác định. Ghi lại lệnh đó cùng SPEC/AC đang làm; AI không tự cấp quyền bằng cách sửa trạng thái hay plan.

- Mặc định một phần việc có kết quả kiểm chứng được trong một spec; số file không phải thước đo duy nhất của phạm vi.
- Nếu người dùng đã giao rõ phần việc thì bắt tay làm và kiểm chứng trong phạm vi đó; không tạo vòng xin phép lại.
- Nếu lệnh như “code đi” chưa xác định được phần việc trong bối cảnh nhiều spec, trình bày phần việc kế tiếp cùng kết quả mẫu để người dùng chọn.
- Người dùng có thể giao nhiều phần việc một lần bằng danh sách hoặc mốc kết thúc rõ. Trong phạm vi ấy AI tiếp tục tự chủ, báo kết quả từng phần.
- Làm xong phần đã giao, báo bằng chứng rồi dừng. Phụ thuộc, spec kế tiếp và backlog không tự tạo quyền mới.

### B. Đưa phần người dùng có thể kiểm tra lên trước

Đầu mỗi lượt chỉ cần trả lời: **sẽ thấy thay đổi gì, thử bằng thao tác nào, giới hạn nào còn lại**. Chi tiết chuyên môn đặt sau và gắn với bằng chứng. Người dùng duyệt hành vi và đánh đổi; không phải xác nhận một thuật toán đúng chỉ vì AI viết có vẻ thuyết phục.

Một ví dụ nghiệp vụ chuẩn do người dùng cung cấp có giá trị làm đối chứng. Nếu AI tự tạo cả kỳ vọng lẫn test rồi test xanh, chỉ kết luận code khớp kỳ vọng đó; chưa chứng minh kỳ vọng đúng.

### C. Gắn nguồn gốc với kết luận quan trọng

Tận dụng REQ, bảng quyết định và ghi chú thiết kế sẵn có; không cần một cơ sở dữ liệu tri thức mới. Với quyết định ảnh hưởng hành vi, tính đúng, bảo mật hoặc giới hạn, ghi:

| Trường | Nội dung |
|---|---|
| Kết luận | Câu có thể kiểm chứng; tránh thuật ngữ mơ hồ như “chuẩn”, “tối ưu”. |
| Nguồn gốc | Lệnh người dùng; repo `path:line`; tài liệu chính thức đúng phiên bản; hoặc `Đề xuất` / `Chưa biết`. |
| Bằng chứng | Thí nghiệm, test, log hoặc review có thể xem lại; chưa chạy thì ghi rõ. |
| Phạm vi và giới hạn | Điều phép kiểm chứng minh được và điều còn ngoài phép kiểm. |

Không bắt truy vết mọi câu văn. Không biến tỷ lệ “tự tin 95%” thành bằng chứng. AI được đề xuất nhưng cần giữ nguyên nhãn đề xuất đến khi có quyết định hoặc kiểm chứng phù hợp.

### D. Xử lý thiếu hiểu biết theo mức ảnh hưởng

1. Tra repo và nguồn chính thức trước khi hỏi điều đã có thể tìm được.
2. Nếu chưa chắc hành vi thư viện hoặc tính đúng thuật toán, chạy thí nghiệm nhỏ có tiêu chí thất bại rõ.
3. Nếu thiếu quyết định nghiệp vụ, hỏi bằng ví dụ cụ thể và hệ quả lựa chọn.
4. Nếu cần chuyên môn mà nguồn và thí nghiệm chưa giải quyết, giữ `Chưa xác minh`, chỉ rõ ai/cách nào có thể kiểm. Tránh ép người dùng duyệt một tuyên bố họ không có cơ sở đánh giá.
5. Chỉ chặn phần việc phụ thuộc điều chưa biết; tiếp tục phần độc lập đã được giao.

### E. Báo kết quả để kiểm tra lại được

Một biên bản ngắn gồm: phần việc đã giao; hành vi đã đổi; lệnh/thao tác và kết quả thật; đầu vào/kỳ vọng lấy từ đâu; mock hoặc điều chưa kiểm; kết luận trong phạm vi phép kiểm; phần có thể làm tiếp.

## 4. Cách thử lại thiết kế

| Tình huống | Hành vi đạt |
|---|---|
| Ba spec đều `Ready`; người dùng chỉ giao AC01 của spec thứ nhất. | Chỉ làm AC01 cùng các sửa đổi cần thiết và đã nằm trong phạm vi; báo xong, không chạy spec thứ hai. |
| Người dùng giao rõ hai phần việc liên tiếp. | Làm cả hai nếu điều kiện đã đáp ứng; không hỏi lại chỉ vì chuyển phần việc. |
| AI đề xuất “p95 < 100 ms” nhưng chưa có tải mục tiêu hay phép đo. | Ghi đề xuất/chưa đo; không gắn thành MUST hoặc báo đạt. |
| Test do AI viết dùng một công thức AI tự suy ra. | Phân biệt khớp công thức với công thức đúng; tìm đối chứng hoặc để thiếu kiểm chứng. |
| Cần kiến thức chuyên môn người dùng chưa có. | Trình bày bằng chứng hoặc phép thử, giới hạn và cách kiểm thêm; không dùng “bạn đã duyệt” để chứng nhận đúng. |
| Thiếu quyết định ở AC02, AC01 độc lập và đã được giao. | Hoàn thành AC01, chặn riêng AC02 và nêu câu hỏi cần trả lời. |

## 5. Giới hạn thực tế

Markdown hướng dẫn hành vi; nó không tự chặn ghi file, thực thi lệnh hay mở rộng phạm vi. Review AI thứ hai có thể mắc cùng lỗi. Test xanh có thể kiểm sai kỳ vọng hoặc bỏ sót điều kiện thật. Không nên hứa loại bỏ các rủi ro ấy bằng cách thêm luật.

Nếu cần **cưỡng chế**, dùng quyền công cụ, sandbox, review diff và kiểm CI được bảo vệ phù hợp với nền tảng đang dùng. Chỉ thêm cơ chế khi có nhu cầu thực; không cần dựng một framework mới để bắt đầu thử cách giao việc hẹp và báo bằng chứng.
