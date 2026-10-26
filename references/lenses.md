# Danh mục góc nhìn chuyên môn (lens)

Dùng thay cho câu "bạn là senior BA / tech lead…". Đầu mỗi bước, AI tra bảng, bật **tối đa 3** góc nhìn có tín hiệu thật rồi ghi một dòng:

`Góc nhìn: <tên> — vì <tín hiệu cụ thể: file, từ khoá, bước>`

Người dùng nói "thêm/bỏ góc nhìn X" thì AI làm theo. Mỗi góc nhìn phải đổi **câu hỏi và đầu ra**, không chỉ đổi giọng văn.

> **Vì sao không dùng danh xưng (Đã xác minh, 2026-10-26):**
> - Zheng et al., Findings EMNLP 2024, <https://arxiv.org/abs/2311.10054>, nguyên văn: *"adding personas in system prompts does not improve model performance across a range of questions compared to the control setting where no persona is added"*. Cùng bài: tự chọn persona *"often performing no better than random selection"*.
> - Kim et al. 2024, <https://arxiv.org/abs/2408.08631>, nguyên văn: *"role-playing prompts sometimes distract LLMs, degrading their reasoning abilities in 7 out of 12 datasets in llama3"*.
> - Anthropic, <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices#give-claude-a-role>, nguyên văn: *"Setting a role in the system prompt focuses Claude's behavior and tone"*. Theo tài liệu này, độ chính xác đến từ ví dụ, không đến từ vai trò.
>
> Kết luận: chất lượng nằm ở checklist bên dưới; một dòng mô tả vai trò chỉ định hướng giọng văn.

| Góc nhìn | Bật khi có tín hiệu | Câu hỏi bắt buộc | Đầu ra | Skill liên quan |
|---|---|---|---|---|
| Phân tích nghiệp vụ (BA) | Yêu cầu mơ hồ, nhiều bên liên quan, chưa có AC | Ai dùng? Thành công đo bằng gì? Trường hợp biên nào? Điều gì **không** làm? | REQ dạng EARS, AC Cho/Khi/Thì, `[CẦN LÀM RÕ]` | `write-spec` |
| Kiến trúc / Tech lead | > 2 PR, nhiều module, quyết định khó đảo ngược | Ranh giới module ở đâu? Lùi lại (rollback) thế nào? Task nào chặn task nào? | Design doc, đồ thị task | `write-design-doc`, `plan-tasks` |
| Dữ liệu | Chạm schema, migration, backfill, dữ liệu người dùng | Đổi được mà không gián đoạn không? Dữ liệu cũ xử lý ra sao? | Chuỗi Expand–Migrate–Contract | `plan-tasks`, [PK-DB](../packs/PK-DB.md) |
| Bảo mật | Đăng nhập, phân quyền, dữ liệu cá nhân, thanh toán, secret | Theo STRIDE: ai giả mạo được, cái gì lộ hoặc bị sửa được? Có cần chuyên gia không? | Bảng mối đe doạ + biện pháp, ghi "cần chuyên gia" nếu vượt hiểu biết | `write-design-doc`, [PK-AUTH](../packs/PK-AUTH.md) |
| Kiểm thử (QA) | Có AC, có hồi quy, đang sửa bug | Test ở tầng nào? Bằng chứng nào chứng minh là đúng? Có dùng mock không? | Bảng test hiển thị, tầng test cho từng AC | `generate-verify-harness` |
| Vận hành (SRE) | Deploy, worker, cron, hạ tầng, hàng đợi | Hỏng thì biết bằng cách nào? Lùi bản ra sao? | Log/metric cần có, runbook | [PK-OBS](../packs/PK-OBS.md), [PK-RELEASE](../packs/PK-RELEASE.md) |
| Ngữ cảnh cho AI | Viết `AGENTS.md`, docs cho agent, skill dự án | Agent mới vào đọc file nào trước? Có vượt ngân sách đọc mỗi phiên không? Có hai nguồn sự thật không? | `AGENTS.md`, bản đồ docs, con trỏ có điều kiện | `propose-doc-design`, [PK-AGENT](../packs/PK-AGENT.md) |
| Trải nghiệm người dùng (UX) | Có UI hoặc luồng thao tác của người dùng | Người dùng kẹt ở đâu? Trạng thái lỗi/rỗng/đang tải ra sao? Có đạt a11y không? | Luồng màn hình, trạng thái lỗi | [PK-FE](../packs/PK-FE.md) |
| Phản biện | **Luôn bật** ở Cổng 2 và khi so sánh phương án | Chỗ nào sai được? Khẳng định nào thiếu nguồn mở được? Phương án nào là bù nhìn? | Danh sách vấn đề kèm mức độ | `review-docs`, `explore-options` |

Bước mặc định (nếu chưa có tín hiệu nào khác):

| Bước | Góc nhìn mặc định |
|---|---|
| 1–4 (khảo sát, đề xuất) | Ngữ cảnh cho AI + BA |
| 5b (spec) | BA + Kiểm thử |
| 5c (design) | Kiến trúc + góc nhìn rủi ro có tín hiệu (Dữ liệu/Bảo mật/Vận hành) |
| 6 (Cổng 2) | Phản biện |
| 7.5–8 (plan, code) | Kiến trúc + Kiểm thử |

Thêm góc nhìn mới khi một loại tín hiệu lặp lại ≥ 2 dự án. Ghi đủ 5 cột; thiếu "Câu hỏi bắt buộc" thì đó chỉ là danh xưng, không nhận.
