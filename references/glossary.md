# Thuật ngữ của bộ kit

Tra một từ hoặc một mã lạ trong bộ kit ở đây. Mỗi file trong bộ kit tự giải nghĩa ngắn ở lần đầu dùng; file này chỉ để tra cứu khi cần.

- **Luật Core `C01–C31`:** tên ngắn và nội dung đầy đủ nằm ở [base-kit.md §3](base-kit.md#3-tầng-core--kế-thừa-nguyên-văn-c01c31). `C32` đã bỏ.
- **Pack `PK-*`:** bộ luật chỉ bật khi dự án có tín hiệu tương ứng (API, DB, job nền…), xem [base-kit.md §6](base-kit.md#6-tầng-pack--kế-thừa-có-điều-kiện).

## Quy trình

| Thuật ngữ | Nghĩa bằng lời thường | Định nghĩa đầy đủ |
|---|---|---|
| Cổng 1 / 2 / 3 | Ba lần dừng để người dùng duyệt trước khi code: duyệt đề xuất → duyệt bộ docs sau phản biện → duyệt kết quả thử docs | [SKILL.md](../SKILL.md) |
| Checkpoint 5a / 5b / 5c | Ba lần dừng trong lúc viết docs: 5a cụm nền (AGENTS, glossary, decisions), 5b từng spec một, 5c từng design doc | [SKILL.md](../SKILL.md) |
| Đợt (RUN) | Phần việc người dùng đã giao cho một lượt làm, ghi trong `docs/progress.md`. Spec `Ready` hay plan không tự tạo đợt | base-kit `C30` |
| Mức 0 / 1 / 2 | Mức 0: bắt buộc ngay từ đầu. Mức 1: thêm khi có tín hiệu. Mức 2: dự án trưởng thành | [principles.md §2](principles.md#2-bộ-kỹ-năng-theo-mức) |
| Profile S / M / L | Gói cấu hình theo quy mô repo, để repo nhỏ không phải gánh docs của repo lớn | [profiles.md](../profiles.md) |
| Frontier | Những câu hỏi về kết quả hoặc đánh đổi mà **chỉ người dùng** quyết được. Chi tiết kỹ thuật thì AI tự nghiên cứu | `skills/propose-doc-design` |
| HYPOTHESIS / GUESS | Cách hỏi ở Bước 4: AI nêu giả thuyết kèm bằng chứng (HYPOTHESIS) và đáp án đoán sẵn (GUESS) để người dùng chỉ cần xác nhận hoặc sửa | `skills/propose-doc-design` |
| Scope Radar | Bảng 3 cột phạm vi: 🟢 làm ngay · 🟡 đợt sau · 🔴 không làm | base-kit `C28` |
| Task sẵn sàng | Task trong plan mà mọi task nó phụ thuộc đã xong. "Sẵn sàng" không có nghĩa là đã được giao | `skills/plan-tasks` |

## Trạng thái và ID

| Thuật ngữ | Nghĩa |
|---|---|
| `Draft` → `Ready` → `In progress` → `Done` | Vòng đời spec. Chỉ người dùng chuyển sang `Ready`. `Ready` = yêu cầu đã đủ rõ, **chưa phải** quyền code |
| `As-built` | Spec mô tả code **đã có sẵn** (repo cũ), kèm bằng chứng từ code/test |
| `[ ]` / `[x]` / `[~]` | AC chưa đạt / đạt và có bằng chứng chạy / chưa kiểm chứng được (ghi lý do, chặn `Done`) |
| REQ · NFR · AC | Yêu cầu chức năng · yêu cầu phi chức năng (hiệu năng, bảo mật…) · điều kiện nghiệm thu kiểm được |
| `SPEC-X`, `X-R01`, `X-AC01` | ID của spec, của yêu cầu và của điều kiện nghiệm thu. Được giữ trong test, commit và PR để truy vết |
| `D-xx` · `P-xx` · `CHG-xx` | Quyết định đã chốt · đề xuất chưa chốt · đề xuất thay đổi cho spec đã `Done` |
| EARS | Mẫu câu viết yêu cầu: *Luôn / Khi <sự kiện> / Trong khi <trạng thái> / Nếu <lỗi> thì / Khi bật <tính năng>* (Alistair Mavin, <https://alistairmavin.com/ears/>) |

## Bốn nhãn nguồn gốc (luật **Nguồn & giới hạn hiểu biết**, `C31`)

| Nhãn | Bắt buộc kèm |
|---|---|
| `Người dùng chốt` | Ngày, câu người dùng nói hoặc mục Làm rõ |
| `Đã xác minh` | Đúng 1 con trỏ mở ra được: `path:line` · URL + trích nguyên văn + ngày đọc · lệnh + kết quả thật |
| `AI đề xuất` | Lý do trong 1 dòng + hậu quả nếu sai |
| `Chưa biết` | Cách xác minh, ai làm, phần việc nào bị chặn |

Một khẳng định viết trên một dòng. Có trích dẫn chưa đủ: phải có câu trích để người đọc đối chiếu được. Không tự chấm độ tin cậy %.

**Thẻ quyết định kỹ thuật:** khung 5 dòng (nói đơn giản · nếu sai thì sao · tự kiểm trong ≤ 5 phút · nguồn · phần không tự kiểm được), dùng cho quyết định người dùng không tự thẩm định được. Người dùng duyệt dòng "tự kiểm", không duyệt lập luận. Mẫu nằm ở [_template.md](../templates/docs/specs/_template.md).

## Khái niệm mượn từ bên ngoài

| Thuật ngữ | Nghĩa | Nguồn gốc |
|---|---|---|
| Deep Module | Module có giao diện nhỏ nhưng che giấu nhiều logic bên trong | John Ousterhout, *A Philosophy of Software Design* |
| Design It Twice | Phác ít nhất hai phương án rồi mới chọn | John Ousterhout, *A Philosophy of Software Design* |
| Seam | Điểm có thể thay hành vi (vd. để test) mà không phải sửa code tại chỗ | Michael Feathers, *Working Effectively with Legacy Code* |
| Tracer Bullet | Lát cắt mỏng chạy xuyên mọi tầng (UI → API → DB), cho kết quả thật từ sớm | Andrew Hunt & David Thomas, *The Pragmatic Programmer* |
| Expand–Migrate–Contract | Đổi schema/API không gây gián đoạn: thêm cái mới song song → chuyển dữ liệu/người dùng và kiểm → gỡ cái cũ | "Parallel Change", <https://martinfowler.com/bliki/ParallelChange.html> |
| STRIDE | 6 loại đe doạ cần rà: giả mạo, sửa trái phép, chối bỏ, lộ thông tin, từ chối dịch vụ, leo thang quyền | Microsoft (Kohnfelder & Garg, 1999), <https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats> |
| DoD | Định nghĩa Xong: các lệnh phải xanh + có bằng chứng AC + docs đã cập nhật | Thuật ngữ Scrum |
