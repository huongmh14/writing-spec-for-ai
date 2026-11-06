# Phân Tích Điểm Yếu writing-spec-for-ai Cho Demo Nhanh

**Analysis Date:** 2026-11-05  
**Purpose:** Phân tích tại sao writing-spec-for-ai không phù hợp cho demo nhanh và đề xuất cải thiện với skills vừa viết.

---

## 1. Điểm Yếu Của writing-spec-for-ai Cho Demo Nhanh

### 1.1 Quá Formal - 3 Cổng Review Mất Thời Gian

**Vấn đề:**
- 8 bước + 3 cổng duyệt: Đề xuất (Cổng 1)  Phản biện (Cổng 2)  Thử docs (Cổng 3)  Code
- Mỗi cổng phải chờ user duyệt
- Demo nhanh cần kết quả ngay, không có thời gian chờ

**Ví dụ:**
```
Demo project nhỏ 30 phút:
- Bước 1-2: Khảo sát (5-10 phút)
- Bước 3: Đề xuất docs (5 phút)  CHỜ DUYỆT CỔNG 1
- Bước 4: Làm rõ (3-5 phút)
- Bước 5a: Viết cụm nền (10 phút)  CHỜ REVIEW 5a
- Bước 5b: Viết spec (15 phút)  CHỜ REVIEW 5b
- Bước 5c: Viết design (10 phút)  CHỜ REVIEW 5c
- Bước 6: Phản biện (10 phút)  CHỜ DUYỆT CỔNG 2
- Bước 7: Thử docs (10 phút)  CHỜ DUYỆT CỔNG 3
- Bước 8: Code (30+ phút)

Tổng: 2+ giờ, quá lâu cho demo 30 phút
```

### 1.2 Quá Nhiều Sub-Skills - Cần Mở Đúng 1 Mỗi Lượt

**Vấn đề:**
- 10 sub-skills: survey-project, propose-doc-design, write-spec, write-design-doc, review-docs, test-docs, plan-tasks, change-spec, explore-options, generate-verify-harness
- Luật: "mỗi lượt chỉ mở đúng 1 sub-skill của bước hiện tại, cấm mở nhiều sub-skill cùng lúc"
- Demo nhanh cần tốc độ, không có thời gian mở từng sub-skill

**Ví dụ:**
```
Để viết 1 spec:
1. Mở survey-project  khảo sát
2. Mở propose-doc-design  đề xuất
3. Mở write-spec  viết spec
4. Mở review-docs  phản biện
5. Mở test-docs  thử docs

Mỗi sub-skill có SKILL.md riêng, cần đọc trước khi dùng
 Quá nhiều file, quá nhiều context
```

### 1.3 Quá Nhiều Terminology - Khó Hiểu Cho Người Mới

**Vấn đề:**
- 10 luật cứng + 31 core laws = 41 luật
- Thuật ngữ: Profile S, Cổng 1/2/3, Cxx, D-xx, P-xx, CHG-xx, REQ, AC, NFR, EARS
- Demo cần đơn giản, không cần formal

**Ví dụ:**
```
"Profile S: mọi con trỏ docs/specs/  docs/spec.md/README, docs/progress.md  block đợt trong AGENTS.md"
 Người mới không hiểu Profile S là gì
```

### 1.4 Không Có Auto-Detection - User Phải Tự Invoke

**Vấn đề:**
- writing-spec-for-ai không tự detect khi nào cần
- User phải nói "viết spec cho dự án" hoặc "viết AGENTS.md"
- Demo cần AI tự động đề xuất, không cần user biết skill nào

**Ví dụ:**
```
User: "tôi muốn demo nhanh project này"
AI: ??? (không biết dùng skill nào)
```

### 1.5 Không Có Quick Start Cho Demo

**Vấn đề:**
- Không có "demo mode" hoặc "quick start"
- Templates quá chi tiết - cần điền nhiều thông tin
- Không có "minimal viable spec" cho demo

**Ví dụ:**
```
AGENTS.md template: ~150 dòng, cần điền:
- Project description
- Tech stack
- Commands
- Coding conventions
- Structure rules
- Ranh giới 3 tầng
- DoD
- Quy trình một task
- Ngữ cảnh dài & nén
- Definition of Done
- Quy ước code
- Git
- Bản đồ repo
```

### 1.6 Templates Quá Chi Tiết - Cần Điền Nhiều

**Vấn đề:**
- SPEC template có nhiều mục: Mục tiêu, phạm vi, REQ EARS, NFR, biên, AC, kiểm e2e, câu hỏi mở
- Demo cần spec đơn giản, chỉ cần REQ + AC cơ bản
- Điền quá nhiều  mất thời gian

**Ví dụ:**
```
SPEC template đầy đủ:
- Mục tiêu (2-3 câu)
- Phạm vi trong/ngoài (không rỗng)
- REQ EARS (mỗi REQ có ID, mức P1/P2/P3)
- NFR (số hoặc N/A - lý do)
- Trường hợp biên
- AC Cho/Khi/Thì
- Kiểm e2e
- Câu hỏi mở (ghi "Không có" nếu rỗng)

Demo cần:
- Mục tiêu (1 câu)
- REQ đơn giản (không cần EARS)
- AC đơn giản (checklist)
```

### 1.7 10 Luật Cứng + 31 Core Laws - Quá Nhiều Để Nhớ

**Vấn đề:**
- AI phải nhớ 41 luật
- Demo cần đơn giản, chỉ cần 5-10 luật quan trọng nhất
- Quá nhiều luật  AI dễ vi phạm hoặc ignore

**Ví dụ:**
```
Luật quan trọng cho demo:
- C01: Thứ tự nguồn sự thật
- C03: Quyền AI theo trạng thái spec
- C05: Trạng thái AC
- C12: Ranh giới 3 tầng
- C13: Định nghĩa Xong (DoD)

41 luật  AI khó nhớ hết
```

### 1.8 Quy Trình 8 Bước - Quá Dài Cho Demo

**Vấn đề:**
- 8 bước: Khảo sát  Đề xuất  Làm rõ  Viết cụm nền  Viết spec  Viết design  Phản biện  Thử docs  Code
- Demo cần 2-3 bước: Khảo sát  Viết docs đơn giản  Code

**Ví dụ:**
```
Demo 30 phút:
- Khảo sát: 5 phút
- Viết docs đơn giản: 10 phút
- Code: 15 phút

8 bước  quá dài
```

---

## 2. Skills Vừa Viết Có Thể Cải Thiện Như Thế Nào?

### 2.1 auto-guide - Auto-Detection & Smart Routing

**Cải thiện:**
- auto-guide có thể detect "demo nhanh" và đề xuất writing-spec-simple thay vì writing-spec-for-ai
- Auto-guide có thể detect project size và chọn đúng layer
- Auto-guide có thể orchestrate workflow: explore  writing-spec-simple  writing-plans  code

**Ví dụ:**
```
User: "demo nhanh project này"
AI (auto-guide):
=== Tình Huống Của Bạn ===
Phát hiện: demo nhanh, project nhỏ
Project size: 30 files

=== Đề Xuất Của Tôi ===
Skill: explore  writing-spec-simple  writing-plans  code

Lý do:
- Demo nhanh  cần đơn giản, không formal
- Project < 50 files  bản simple đủ
- Không cần 3 cổng review

Kết quả:
- AGENTS.md đơn giản (30 phút)
- Specs đơn giản (REQ + AC)
- Code nhanh (15 phút)

Bạn có đồng ý không?
```

### 2.2 writing-spec-simple - Quick Demo Mode

**Cải thiện:**
- Thêm "Demo Mode" hoặc "Quick Start" cho demo nhanh
- Templates đơn giản hóa hơn: chỉ cần AGENTS.md + SPEC đơn giản
- Quy trình 2-3 bước: Khảo sát  Viết docs  Code
- Không cần 3 cổng review, chỉ cần user approval 1 lần

**Ví dụ:**
```
writing-spec-simple DEMO MODE:

Bước 1: Khảo sát (5 phút)
- Hỏi: project làm gì, tech stack, lệnh build/test
- Không cần explore chi tiết

Bước 2: Viết docs (10 phút)
- AGENTS.md đơn giản (50 dòng thay vì 150)
- SPEC đơn giản (REQ + AC, không cần EARS)
- User approve 1 lần

Bước 3: Code (15 phút)
- AI code theo spec đơn giản
- Verify nhanh
```

### 2.3 starter-guide - Demo Workflow

**Cải thiện:**
- Thêm "Demo Workflow" section cho demo nhanh
- Flow: "Tôi muốn demo nhanh"  auto-guide  writing-spec-simple  code
- Quick reference cho demo

**Ví dụ:**
```
## Demo Workflow (Quick)

Khi user nói "demo nhanh" hoặc "demo project":

1. auto-guide detect  đề xuất writing-spec-simple
2. writing-spec-simple  viết AGENTS.md + SPEC đơn giản
3. writing-plans  viết plan nhanh
4. code  implement
5. verification-before-completion  verify

Tổng thời gian: 30-45 phút
```

### 2.4 cheat-sheet - Demo Quick Reference

**Cải thiện:**
- Thêm "Demo Quick Reference" section
- Khi nào dùng writing-spec-simple vs writing-spec-for-ai
- Demo workflow rõ ràng

**Ví dụ:**
```
## Demo Quick Reference

**Khi nào dùng writing-spec-simple:**
- Demo nhanh (< 1 giờ)
- Project nhỏ (< 50 files)
- 1-2 người
- Không cần formal process

**Khi nào dùng writing-spec-for-ai:**
- Production project
- Project lớn (≥ 50 files)
- Team nhiều người
- Cần formal process + audit
```

### 2.5 Tạo Skill Mới: demo-mode

**Đề xuất:**
- Tạo skill `demo-mode` chuyên cho demo nhanh
- Kế thừa từ writing-spec-simple nhưng đơn giản hơn nữa
- Chỉ cần: AGENTS.md 30 dòng + SPEC 20 dòng + code

**Cấu trúc:**
```
demo-mode/
├── SKILL.md              # Demo workflow, 3 bước
└── templates/
    ├── AGENTS.demo.md    # 30 dòng, chỉ cần lệnh + stack
    └── SPEC.demo.md      # 20 dòng, chỉ cần REQ + AC
```

---

## 3. Hướng Phát Triển Đề Xuất

### 3.1 Ngắn Hạn (1-2 ngày)

**Priority 1: Thêm Demo Mode vào writing-spec-simple**
1. Thêm section "Demo Mode" vào SKILL.md
2. Tạo templates đơn giản: AGENTS.demo.md (30 dòng), SPEC.demo.md (20 dòng)
3. Quy trình 3 bước: Khảo sát  Viết docs  Code
4. Không cần 3 cổng review, chỉ cần user approval 1 lần

**Priority 2: Update auto-guide detection rules**
1. Thêm signal: "demo", "demo nhanh", "quick demo"
2. Khi detect demo  đề xuất writing-spec-simple (demo mode)
3. Auto-guide có thể detect project size và chọn đúng layer

**Priority 3: Update starter-guide**
1. Thêm "Demo Workflow" section
2. Flow rõ ràng cho demo nhanh
3. Quick reference cho demo

### 3.2 Trung Hạn (1 tuần)

**Priority 4: Tạo skill demo-mode riêng**
1. Tạo skill `demo-mode` chuyên cho demo
2. Kế thừa từ writing-spec-simple nhưng đơn giản hơn
3. Templates siêu đơn giản
4. Test với 3-5 demo projects

**Priority 5: Enhance cheat-sheet**
1. Thêm "Demo Quick Reference"
2. Clear decision: khi nào simple vs full
3. Demo workflow examples

### 3.3 Dài Hạn (2 tuần+)

**Priority 6: Smart routing trong auto-guide**
1. Auto-guide detect demo vs production
2. Auto-guide detect project size
3. Auto-guide detect team size
4. Auto-guide chọn đúng skill layer tự động

**Priority 7: Demo templates library**
1. Tạo templates cho các loại project phổ biến
2. E-commerce, API, Blog, Dashboard...
3. Copy-paste và điền thông tin

---

## 4. Demo Workflow Đề Xuất

### 4.1 User Nói: "Demo nhanh project này"

```
User: "demo nhanh project này"

AI (auto-guide):
=== Tình Huống Của Bạn ===
Phát hiện: demo nhanh request
Project size: 25 files
User level: beginner

=== Đề Xuất Của Tôi ===
Skill: explore  writing-spec-simple (demo mode)  writing-plans  code

Lý do:
- Demo nhanh  cần đơn giản, không formal
- Project < 50 files  bản simple đủ
- Demo mode  3 bước thay vì 8 bước

Kết quả:
- AGENTS.demo.md: 30 dòng (5 phút)
- SPEC.demo.md: 20 dòng (5 phút)
- Plan: 5 phút
- Code: 15 phút
Tổng: ~30 phút

Bạn có đồng ý không?
```

### 4.2 Sau Khi User Approve

```
AI: "Bắt đầu demo mode..."

Bước 1: Khảo sát (5 phút)
- Hỏi: project làm gì, tech stack, lệnh build/test
- User trả lời nhanh

Bước 2: Viết docs (10 phút)
- Viết AGENTS.demo.md (30 dòng)
- Viết SPEC.demo.md (20 dòng)
- User approve 1 lần

Bước 3: Code (15 phút)
- AI code theo spec
- Verify nhanh
- Demo xong
```

---

## 5. Kết Luận

### Điểm Yếu writing-spec-for-ai Cho Demo Nhanh:

1. **Quá formal:** 3 cổng review mất thời gian
2. **Quá nhiều sub-skills:** 10 sub-skills cần mở từng cái
3. **Quá nhiều terminology:** 41 luật + nhiều thuật ngữ
4. **Không có auto-detection:** User phải tự invoke
5. **Không có quick start:** Không có demo mode
6. **Templates quá chi tiết:** Cần điền nhiều
7. **Quá nhiều luật:** 41 luật khó nhớ
8. **Quy trình quá dài:** 8 bước quá lâu cho demo

### Cải Thiện Với Skills Vừa Viết:

1. **auto-guide:** Auto-detect demo, đề xuất writing-spec-simple
2. **writing-spec-simple:** Thêm demo mode, templates đơn giản
3. **starter-guide:** Thêm demo workflow
4. **cheat-sheet:** Thêm demo quick reference
5. **Tạo demo-mode:** Skill chuyên cho demo nhanh

### Hướng Phát Triển:

1. **Ngắn hạn:** Thêm demo mode vào writing-spec-simple, update auto-guide
2. **Trung hạn:** Tạo skill demo-mode riêng, enhance cheat-sheet
3. **Dài hạn:** Smart routing, demo templates library

**Kết quả:** Demo nhanh từ 2+ giờ  30-45 phút, đơn giản và hiệu quả.
