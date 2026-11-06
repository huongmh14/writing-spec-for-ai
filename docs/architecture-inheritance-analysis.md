# Phân Tích Kiến Trúc Kế Thừa & Overlap Skills

**Analysis Date:** 2026  
**Purpose:** Xác định kiến trúc cốt lõi của writing-spec-for-ai có thể kế thừa, khả năng mở rộng, và kiểm tra overlap với các skill khác.

---

## 1. Kiến Trúc Cốt Lõi Của writing-spec-for-ai

### 1.1 Cấu Trúc Tệp (Progressive Disclosure)

```
writing-spec-for-ai/
├── SKILL.md                 # Bộ điều phối chính (64 dòng frontmatter + laws)
├── agents/                  # Sub-agents cho các bước
│   ├── spec-surveyor.md     # Khảo sát dự án (read-only)
│   ├── spec-challenger.md   # Phản biện đối kháng (read-only, chỉ nhận ARTIFACT + CONTRACT)
│   └── doc-tester.md        # Thử docs với task mẫu (read-only)
├── skills/                  # Sub-skills cho từng bước
│   ├── survey-project/      # Bước 1-2: Khảo sát + xác định mức 0/1/2
│   ├── propose-doc-design/  # Bước 3: Đề xuất thiết kế docs (Cổng 1)
│   ├── write-spec/          # Bước 5b: Viết spec từng file một
│   ├── write-design-doc/    # Bước 5c: Viết design doc
│   ├── review-docs/         # Bước 6: Phản biện docs (Cổng 2)
│   ├── test-docs/           # Bước 7: Thử docs (Cổng 3)
│   ├── plan-tasks/          # Bước 7.5: Chọn lát cắt, AC, điểm dừng
│   ├── change-spec/         # Bước 8: Quản lý thay đổi spec
│   ├── explore-options/     # Khi có ≥ 2 phương án khó đảo ngược
│   └── generate-verify-harness/ # Tạo verify harness khi cần
├── references/              # Tài liệu chi tiết, load on demand
│   ├── principles.md        # Nguyên tắc tài liệu cho AI (đầy đủ)
│   ├── base-kit.md          # Core C01-C31 + Pack PK-*
│   ├── glossary.md          # Thuật ngữ bộ kit
│   ├── lenses.md            # Góc nhìn thay danh xưng
│   ├── examples.md          # Ví dụ thực tế
│   └── review-checklist.md  # Checklist review
├── templates/               # Mẫu file để copy + điền
│   ├── AGENTS.md            # Template AGENTS.md (Profile S/M/L)
│   ├── CONSTRAINTS.md       # Template constraints
│   ├── doc-design-proposal.md # Template đề xuất docs
│   ├── docs/
│   │   ├── specs/
│   │   │   ├── _template.md # Template spec đầy đủ
│   │   │   └── README.md   # Trạng thái spec, quyền AI, đổi gì sửa file nào
│   │   ├── decisions.md     # Template decisions (append-only)
│   │   ├── conflicts-and-bugs.md # Template sổ tay lỗi
│   │   └── progress.md     # Template bộ nhớ phiên
│   └── adapters/            # Adapter cho các tool
│       ├── claude-settings.json
│       └── pull_request_template.md
├── packs/                   # Packs cho các use case (tùy chọn)
└── profiles.md              # Profile S (simple) cho dự án nhỏ
```

### 1.2 10 Luật Cứng (Hard Laws)

| # | Luật | Mô tả | Vị trí |
|---|------|-------|--------|
| 1 | 3 cổng duyệt | Đề xuất  Phản biện  Thử docs  Code | SKILL.md line 14 |
| 2 | Không bịa yêu cầu | Không suy ra được  `[CẦN LÀM RỒ]` + câu hỏi mở | SKILL.md line 15 |
| 3 | Một sự thật, một chỗ | Con trỏ có điều kiện (`C24`) | SKILL.md line 16 |
| 4 | Mức 0 luôn làm; mức 1-2 chỉ khi có tín hiệu | Ghi rõ tín hiệu | SKILL.md line 17 |
| 5 | Ngắn và không hạ chuẩn | AGENTS.md ≤ 150 dòng, không hạ ngưỡng (`C23`) | SKILL.md line 18 |
| 6 | Viết cho người không chuyên | Ngôn ngữ theo người dùng, nghĩa trước mã sau | SKILL.md line 19 |
| 7 | Quyền thực thi theo đợt (`C30`) | Mỗi lượt 1 bước con, dừng chờ review | SKILL.md line 20 |
| 8 | Nguồn & giới hạn hiểu biết (`C31`) | 4 nhãn, thẻ giải thích kỹ thuật, phản biện chéo (`C26`) | SKILL.md line 21 |
| 9 | Profile S | Ánh xạ con trỏ cho dự án nhỏ | SKILL.md line 22 |
| 10 | Góc nhìn thay danh xưng | Góc nhìn ≤ 3 mục + tín hiệu thật | SKILL.md line 23 |

### 1.3 31 Luật Core (C01-C31 trong base-kit.md)

**Các luật quan trọng nhất có thể kế thừa:**

| ID | Luật | Có thể kế thừa cho simple? | Lý do |
|----|------|---------------------------|-------|
| C01 | Thứ tự nguồn sự thật | [x] Có | Quy tắc cơ bản, không phụ thuộc quy mô |
| C02 | Ba cổng duyệt | (warning) Đơn giản hóa | Simple có thể làm 2 cổng (Đề xuất  Thử docs) |
| C03 | Quyền AI theo trạng thái spec | [x] Có | Quan trọng để tránh code khi spec chưa sẵn |
| C04 | Hệ ID + truy vết | [x] Có | Truy vết quan trọng ngay cả cho dự án nhỏ |
| C05 | Trạng thái AC | [x] Có | `[]` / `[x]` / `[~]` đơn giản nhưng hiệu quả |
| C06 | Mục bắt buộc của spec | (warning) Đơn giản hóa | Simple có thể giảm số mục |
| C07 | Quyết định append-only | [x] Có | Đơn giản, không làm phức tạp |
| C08 | Thuật ngữ | [x] Có | Glossary đơn giản |
| C09 | Đổi spec đã chạy | [] Không cần | Dự án nhỏ thường ít đổi spec |
| C10 | Ngoại lệ hotfix | (warning) Có thể bỏ | Dự án nhỏ có thể không cần quy trình hotfix |
| C11 | Đổi gì sửa file nào | [x] Có | Quan trọng để biết docs nào cần cập nhật |
| C12 | Ranh giới Luôn/Hỏi/Không bao giờ | [x] Có | Ranh giới bảo mật quan trọng cho mọi dự án |
| C13 | Định nghĩa Xong (DoD) | [x] Có | Bằng chứng test quan trọng |
| C14 | Quy ước commit | [x] Có | Git convention quan trọng |
| C15 | Ba luật xử lý lỗi | [x] Có | Xử lý lỗi cơ bản |
| C16 | Secret & cấu hình | [x] Có | Bảo mật quan trọng |
| C17 | Bộ nhớ phiên | (warning) Có thể bỏ | Dự án nhỏ có thể không cần progress.md |
| C18 | Gotcha có ngày kiểm | [x] Có | Hữu ích nhưng có thể đơn giản hóa |
| C19 | Kiểm tác dụng lệnh vận hành | [x] Có | Quan trọng để tránh lệnh giả |
| C20 | Đổi stack là một thay đổi | [x] Có | Quan trọng để tránh CI lệch |
| C21 | Đặt file đúng chỗ công cụ đọc | [x] Có | Quan trọng để AI đọc được file |
| C22 | Thử docs trước khi code | [x] Có | Quan trọng để verify docs |
| C23 | Không hạ chuẩn âm thầm | [x] Có | Quan trọng để giữ chất lượng |
| C24 | Con trỏ có điều kiện | [x] Có | Quan trọng để giảm binding cost |
| C25 | Dẫn nguồn chính thống | [x] Có | Quan trọng để tránh prompt injection |
| C26 | Phản biện chéo model | (warning) Có thể bỏ | Dự án nhỏ có thể không cần phức tạp |
| C27 | Đánh dấu giới hạn đơn giản hoá | [x] Có | Quan trọng để không nhầm lỗi |
| C28 | Trình bày định hướng bằng hình | [x] Có | Quan trọng để tránh "gật đầu mù" |
| C29 | Bằng chứng test hiển thị | [x] Có | Quan trọng để biết AI test cái gì |
| C30 | Quyền thực thi theo đợt | [x] Có | Quan trọng để không code tràn lan |
| C31 | Nguồn & giới hạn hiểu biết | [x] Có | Quan trọng để không bịa kiến thức |

### 1.4 Quy Trình 8 Bước + 3 Cổng

```
Bước 1-2: Survey (spec-surveyor)
  
Bước 3: Đề xuất docs (propose-doc-design)  CỔNG 1 (chờ duyệt)
  
Bước 4: Làm rõ Frontier (HYPOTHESIS + GUESS)
  
Bước 5a: Viết cụm nền (AGENTS.md, glossary, decisions)  Checkpoint 5a
  
Bước 5b: Viết spec từng file một (write-spec)  Checkpoint 5b
  
Bước 5c: Viết design doc (write-design-doc)  Checkpoint 5c
  
Bước 6: Phản biện docs (review-docs + spec-challenger)  CỔNG 2 (chờ duyệt)
  
Bước 7: Thử docs (test-docs + doc-tester)  CỔNG 3 (chờ duyệt mới code)
  
Bước 7.5: Chọn lát cắt, AC, điểm dừng (plan-tasks)
  
Bước 8: Code theo docs (change-spec)
```

---

## 2. writing-spec-simple Có Thể Kế Thừa Được Không?

### 2.1 Kế Thừa Cấu Trúc Tệp

**Đúng:** writing-spec-simple nên adopt progressive disclosure structure

```
writing-spec-simple/
├── SKILL.md                 # Bộ điều phối đơn giản hóa (~400 dòng)
├── references/              # Tài liệu chi tiết (load on demand)
│   ├── principles-simple.md # Nguyên tắc đơn giản hóa (từ principles.md)
│   ├── base-simple.md       # Core laws đơn giản (C01, C03-C05, C11-C16, C23-C25, C29-C30)
│   └── examples-simple.md   # Ví dụ cho dự án nhỏ
└── templates/               # Mẫu file
    ├── AGENTS.simple.md     # Template AGENTS.md cho dự án nhỏ (< 50 files)
    ├── SPEC.simple.md       # Template spec đơn giản (ít mục hơn full)
    └── glossary.simple.md   # Template glossary đơn giản
```

### 2.2 Kế Thừa Quy Trình (Đơn giản hóa)

**writing-spec-simple nên dùng quy trình 3 bước:**

```
Bước 1: Khảo sát dự án (5-10 phút)
  - Dùng explore skill (có sẵn)
  - Hỏi user: project làm gì, tech stack, lệnh build/test
  - Xác định project size (< 50 files  dùng simple)

Bước 2: Đề xuất cấu trúc docs (3-5 phút)
  - Đề xuất: AGENTS.md, glossary (nếu cần), specs (nếu cần)
  - User approve trước khi tiếp tục

Bước 3: Viết docs từng file một (10-30 phút)
  - Copy từ template, điền thông tin thật
  - Review từng file trước khi file tiếp theo
  - Test docs với 2-3 task mẫu (nếu user muốn)
```

**Khác biệt với writing-spec-for-ai:**
- Không có 3 cổng formal (đơn giản hóa thành user approval ở mỗi bước)
- Không có sub-agents (spec-surveyor, spec-challenger, doc-tester)
- Không có phản biện chéo model (`C26`)
- Không có hệ ID phức tạp (giữ ID đơn giản: SPEC-001, AC-1)
- Không có change-spec flow (dự án nhỏ ít đổi spec)
- Không có progress.md (dự án nhỏ không cần bộ nhớ phiên)

### 2.3 Các Core Laws Nên Kế Thừa

**Mandatory (kế thừa 100%):**
- C01: Thứ tự nguồn sự thật
- C03: Quyền AI theo trạng thái spec (Draft  Ready  Done)
- C04: Hệ ID đơn giản (SPEC-001, AC-1)
- C05: Trạng thái AC (`[]` / `[x]` / `[~]`)
- C11: Đổi gì sửa file nào (bảng đơn giản)
- C12: Ranh giới Luôn/Hỏi/Không bao giờ
- C13: Định nghĩa Xong (DoD)
- C14: Quy ước commit
- C15: Ba luật xử lý lỗi
- C16: Secret & cấu hình
- C21: Đặt file đúng chỗ công cụ đọc
- C22: Thử docs trước khi code (đơn giản: 1-2 task mẫu)
- C23: Không hạ chuẩn âm thầm
- C24: Con trỏ có điều kiện
- C25: Dẫn nguồn chính thống
- C29: Bằng chứng test hiển thị (đơn giản hóa)
- C30: Quyền thực thi theo đợt (đơn giản: mỗi lượt 1 file)

**Optional (có thể bỏ hoặc đơn giản hóa):**
- C02: Ba cổng duyệt  đơn giản thành approval từng bước
- C06: Mục bắt buộc của spec  giảm số mục
- C09: Đổi spec đã chạy  bỏ (dự án nhỏ ít đổi)
- C10: Ngoại lệ hotfix  bỏ
- C17: Bộ nhớ phiên  bỏ
- C18: Gotcha có ngày kiểm  bỏ hoặc đơn giản
- C19: Kiểm tác dụng lệnh vận hành  giữ
- C20: Đổi stack là một thay đổi  giữ
- C26: Phản biện chéo model  bỏ
- C27: Đánh dấu giới hạn đơn giản hoá  giữ
- C28: Trình bày định hướng bằng hình  đơn giản
- C31: Nguồn & giới hạn hiểu biết  đơn giản (không cần thẻ giải thích phức tạp)

### 2.4 Templates Có Thể Kế Thừa

**Từ writing-spec-for-ai/templates/:**

```
AGENTS.md  AGENTS.simple.md
  - Giữ cấu trúc 3 tầng (Luôn/Hỏi/Không)
  - Giữ lệnh (install, dev, build, test)
  - Giữ thứ tự nguồn sự thật
  - Bỏ profile M/L (chỉ giữ S)
  - Bỏ phần nâng cấp/compatibility
  - Bỏ phần conflicts-and-bugs (có thể thêm sau)

docs/specs/_template.md  SPEC.simple.md
  - Giữ: Mục tiêu, REQ, AC, NFR
  - Bỏ: biên chi tiết, kiểm e2e phức tạp
  - Bỏ: câu hỏi mở (dự án nhỏ ít câu hỏi)
  - Đơn giản hóa: AC có thể không cần GIVEN/WHEN/THEN

docs/decisions.md  decisions.simple.md
  - Giữ cấu trúc append-only
  - Đơn giản hóa: không cần trạng thái hiệu lực/bị thay thế

glossary.md  glossary.simple.md
  - Giữ cấu trúc: thuật ngữ / định nghĩa / không gọi là / tên trong code
  - Không cần quá nhiều terms
```

### 2.5 Reuse Các Skill Có Sẵn

**Không reimplement, chỉ reference:**

| Việc | Skill có sẵn | writing-spec-simple nên làm |
|------|-------------|----------------------------|
| Khảo sát codebase | `explore` | Gọi explore skill, không reimplement |
| Viết plan implement | `writing-plans` | Nếu user cần plan sau khi có docs, gọi writing-plans |
| Ghi ADR/decisions | `documentation-and-adrs` | Reference, không reimplement |
| Debug bug | `systematic-debugging` | Không liên quan |
| Review code | `code-review` | Không liên quan |
| Verify trước khi xong | `verification-before-completion` | Reference trong DoD |

---

## 3. Overlap Với Các Skill Khác Trong Máy

### 3.1 Danh Sách Skills Trong Máy

```
Total: 32 skills

Beginner layer (mới tạo):
- auto-guide
- starter-guide
- cheat-sheet
- writing-spec-simple
- README-FOR-BEGINNERS.md

Core skills (có sẵn):
- explore
- systematic-debugging
- code-review
- verification-before-completion
- writing-plans
- tdd
- safe-refactor

Process skills (có sẵn):
- git-workflow-and-versioning
- using-git-worktrees
- incremental-implementation

Research skills (có sẵn):
- research
- code-research
- feature-research

UI/UX skills (có sẵn):
- impeccable
- ui-ux-pro-max

Testing skills (có sẵn):
- playwright
- webapp-testing

Utility skills (có sẵn):
- brainstorming
- caveman
- dispatching-parallel-agents
- fast-apply
- morph-cli
- morph-migrate
- pr
- receiving-code-review
- visualize
- writing-skills

Formal skills (có sẵn):
- writing-spec-for-ai
- documentation-and-adrs
- security-audit
```

### 3.2 Overlap Analysis

#### 3.2.1 writing-spec-simple vs writing-spec-for-ai

**Overlap:** CÒN (có overlap nhưng có lý do)

| Aspect | writing-spec-simple | writing-spec-for-ai | Overlap? | Action |
|--------|-------------------|---------------------|----------|--------|
| Mục tiêu | Dự án nhỏ (< 50 files), người mới | Dự án bất kỳ, formal | [] Không | Complementary layers |
| Quy trình | 3 bước đơn giản | 8 bước + 3 cổng formal | [] Không | Different complexity |
| Templates | Đơn giản hóa | Đầy đủ, formal | (warning) Một phần | Simple should inherit from full |
| Laws | 18 laws core đơn giản | 31 laws core + Pack | (warning) Một phần | Simple subset of full |
| Sub-agents | Không có | spec-surveyor, spec-challenger, doc-tester | [] Không | Simple doesn't need |

**Kết luận:** writing-spec-simple nên kế thừa templates và core laws từ writing-spec-for-ai, nhưng không overlap trong use case.

#### 3.2.2 writing-spec-simple vs explore

**Overlap:** KHÔNG (complementary)

- explore: semantic search codebase
- writing-spec-simple: viết docs dựa trên kết quả explore
- Action: writing-spec-simple nên **gọi** explore skill, không reimplement

#### 3.2.3 writing-spec-simple vs writing-plans

**Overlap:** KHÔNG (sequential)

- writing-spec-simple: viết docs (AGENTS.md, specs)
- writing-plans: viết implementation plan từ specs
- Action: writing-spec-simple nên **reference** writing-plans cho bước tiếp theo

#### 3.2.4 writing-spec-simple vs documentation-and-adrs

**Overlap:** MỘT PHẦN (cả hai đều viết docs)

| Aspect | writing-spec-simple | documentation-and-adrs | Overlap? | Action |
|--------|-------------------|------------------------|----------|--------|
| AGENTS.md | Viết | Không viết | [] Không | Complementary |
| decisions.md | Viết (template) | Viết ADR (template khác) | (warning) Một phần | writing-spec-simple reference ADR template |
| Specs | Viết | Không viết | [] Không | Complementary |

**Kết luận:** writing-spec-simple nên reference documentation-and-adrs cho ADR, nhưng không reimplement.

#### 3.2.5 auto-guide vs writing-spec-simple

**Overlap:** KHÔNG (routing vs execution)

- auto-guide: phát hiện tình huống, đề xuất skill
- writing-spec-simple: thực thi workflow viết docs
- Action: auto-guide nên đề xuất writing-spec-simple khi phù hợp

#### 3.2.6 starter-guide vs cheat-sheet

**Overlap:** MỘT PHẦN (cả hai đều là hướng dẫn)

| Aspect | starter-guide | cheat-sheet | Overlap? | Action |
|--------|--------------|------------|----------|--------|
| Mục tiêu | Hướng dẫn nhanh theo mức độ | When-to-use lookup chi tiết | (warning) Một phần | Different granularity |
| Nội dung | 3 mức skill + flow khuyến nghị | 50+ skills chi tiết | (warning) Một phần | starter-guide subset of cheat-sheet |
| Kích thước | 163 dòng | 572 dòng | [] Không | Different depth |

**Kết luận:** starter-guide là entry-level, cheat-sheet là reference. Không overlap đáng kể.

#### 3.2.7 writing-spec-simple vs systematic-debugging

**Overlap:** KHÔNG (khác domain)

- systematic-debugging: tìm bug
- writing-spec-simple: viết docs
- Action: Không liên quan

#### 3.2.8 writing-spec-simple vs code-review

**Overlap:** KHÔNG (khác domain)

- code-review: review code/PR
- writing-spec-simple: viết docs
- Action: Không liên quan

#### 3.2.9 writing-spec-simple vs verification-before-completion

**Overlap:** MỘT PHẦN (cả hai đều có verify)

| Aspect | writing-spec-simple | verification-before-completion | Overlap? | Action |
|--------|-------------------|--------------------------------|----------|--------|
| Verify docs | Có (2-3 task mẫu) | Không (verify code) | [] Không | Different target |
| Verify code | Không | Có (lệnh verify) | [] Không | Different target |

**Kết luận:** Không overlap đáng kể.

### 3.3 Summary: Overlap Đáng Cần Lưu Ý

**Có overlap (nhưng có lý do, không cần xóa):**
1. writing-spec-simple vs writing-spec-for-ai: kế thừa, không trùng
2. starter-guide vs cheat-sheet: entry-level vs reference, không trùng
3. writing-spec-simple vs documentation-and-adrs: reference decisions/ADR

**Không overlap:**
- Tất cả các skill khác có domain khác nhau

**Không gây loãng context:**
- Mỗi skill có use case rõ ràng
- Auto-guide routing giúp user không cần chọn
- Progressive disclosure (nếu thêm) sẽ giảm binding cost

---

## 4. Kế Hoạch Kế Thừa & Cải Tiến

### 4.1 writing-spec-simple Nên Kế Thừa Từ writing-spec-for-ai

**Ngay lập tức (Priority 1):**

1. **Add progressive disclosure structure:**
   ```
   writing-spec-simple/
   ├── SKILL.md                 # ~400 dòng, quy trình 3 bước
   └── references/
       ├── principles-simple.md # Từ principles.md (đơn giản hóa)
       ├── base-simple.md       # C01, C03-C05, C11-C16, C23-C25, C29-C30
       └── examples-simple.md   # Ví dụ dự án nhỏ
   ```

2. **Add templates from writing-spec-for-ai:**
   ```
   writing-spec-simple/
   └── templates/
       ├── AGENTS.simple.md     # Từ AGENTS.md (Profile S)
       ├── SPEC.simple.md       # Từ _template.md (đơn giản hóa)
       ├── glossary.simple.md   # Từ glossary.md
       └── decisions.simple.md  # Từ decisions.md
   ```

3. **Update SKILL.md để kế thừa core laws:**
   - Thêm section "Các quy tắc kế thừa từ writing-spec-for-ai"
   - Liệt kê 18 laws mandatory
   - Thêm link đến references/base-simple.md

**Sau đó (Priority 2):**

4. **Add "When NOT to use"** (đã có trong evaluation)

5. **Add license field** (đã có trong evaluation)

6. **Add BDD scenarios** (đã có trong evaluation)

### 4.2 auto-guide Nên Cập Nhật Để Đề Xuất Đúng Layer

**Update auto-guide detection rules:**

```
Signal 3: Dự án mới / chưa có docs cho AI

Detection project size:
- Check số files: < 50  writing-spec-simple
- Check số files: ≥ 50  writing-spec-for-ai

Lý do template:
```
Đề xuất: writing-spec-simple
Lý do:
- Phát hiện signal: dự án mới / chưa có docs
- Project size: < 50 files  bản simple đủ
- Project size: ≥ 50 files  bản full formal cần
- AI cần docs để làm việc hiệu quả

Kết quả:
- writing-spec-simple: AGENTS.md với tech stack, commands, conventions
- writing-spec-for-ai: Full docs với 3 cổng, sub-agents, formal process
```

### 4.3 starter-guide Nên Cập Nhật Để Tham Chiếu Đúng

**Update starter-guide để reference writing-spec-for-ai cho dự án lớn:**

```markdown
### Mức Nâng Cao (Advanced) - Khi cần chuyên sâu

|| Skill | Khi nào dùng | Ví dụ câu nói |
||-------|-------------|--------------|
|| `writing-spec-for-ai` | Dự án lớn (≥ 50 files), team, cần formal process | "Viết AGENTS.md cho dự án enterprise này" |
```

### 4.4 README-FOR-BEGINNERS Nên Cập Nhật

**Add section về kế thừa:**

```markdown
## Kế Thừa Từ writing-spec-for-ai

writing-spec-simple kế thừa kiến trúc cốt lõi từ writing-spec-for-ai:
- Templates (AGENTS.md, SPEC, decisions, glossary)
- Core laws (C01, C03-C05, C11-C16, C23-C25, C29-C30)
- Progressive disclosure structure

Đơn giản hóa:
- Quy trình 3 bước vs 8 bước + 3 cổng
- Không có sub-agents (spec-surveyor, spec-challenger, doc-tester)
- Không có phản biện chéo model
- Dành cho dự án nhỏ (< 50 files)
```

---

## 5. Kết Luận

### 5.1 writing-spec-simple Có Thể Kế Thừa Được Không?

**CÓ, và nên kế thừa:**

1. **Kế thừa templates:** AGENTS.md, SPEC, decisions, glossary từ writing-spec-for-ai
2. **Kế thừa core laws:** 18 laws quan trọng nhất (C01, C03-C05, C11-C16, C23-C25, C29-C30)
3. **Kế thừa structure:** Progressive disclosure (references/, templates/)
4. **Đơn giản hóa quy trình:** 3 bước vs 8 bước, không có sub-agents, không có phản biện chéo

**Lợi ích:**
- Không phải reimplement từ đầu
- Consistency với formal version
- Dễ upgrade lên writing-spec-for-ai khi dự án lớn
- Giảm maintenance burden

### 5.2 Khi Hệ Thống Mở Rộng, writing-spec-for-ai Có Kế Thừa Được Không?

**CÓ, kiến trúc đã thiết kế để kế thừa:**

1. **4 tầng kế thừa:** Core (100%)  Tham số (100% khung)  Pack (100% khi bật)  Dự án (0%)
2. **Profile S:** Đã có cho dự án nhỏ
3. **Pack system:** Có thể thêm pack mới cho use case khác
4. **Sub-skills:** Có thể thêm sub-skill mới vào quy trình
5. **Extension points:** explore-options, generate-verify-harness

**Khi hệ thống mở rộng:**
- Thêm pack mới (PK-*) cho domain khác (UI, E2E, Security...)
- Thêm sub-skill mới cho bước mới
- Thêm template mới cho use case khác
- Core laws (C01-C31) giữ nguyên, chỉ thêm

### 5.3 Các Skill Khác Có Trùng Hoặc Gây Loãng Context Không?

**KHÔNG TRỤNG đáng kể, KHÔNG GÂY LOÃNG CONTEXT:**

1. **writing-spec-simple vs writing-spec-for-ai:** Kế thừa, không trùng (different complexity)
2. **starter-guide vs cheat-sheet:** Entry-level vs reference, không trùng (different depth)
3. **Tất cả skill khác:** Domain khác nhau, không trùng

**Giảm binding cost:**
- Auto-guide routing giúp user không cần chọn
- Progressive disclosure (nếu thêm) sẽ giảm context cost
- Mỗi skill có use case rõ ràng

### 5.4 Đề Xuất Action Items

**Priority 1 (ngay lập tức):**
1. Add progressive disclosure structure cho writing-spec-simple
2. Copy templates từ writing-spec-for-ai sang writing-spec-simple
3. Update writing-spec-simple SKILL.md để kế thừa core laws
4. Add license field cho tất cả skills mới
5. Add "When NOT to use" sections

**Priority 2 (sau commit):**
6. Add BDD scenarios cho writing-spec-simple
7. Update auto-guide detection rules để đề xuất đúng layer
8. Update starter-guide để reference writing-spec-for-ai
9. Update README-FOR-BEGINNERS để giải thích kế thừa
10. Reduce auto-guide và cheat-sheet xuống < 500 dòng

**Priority 3 (long-term):**
11. Thêm references/ cho tất cả skills mới
12. Thêm integration giữa auto-guide và writing-spec-simple
13. Thăm dò thêm pack cho writing-spec-for-ai
14. Thăm dò thêm sub-skill cho các use case khác

---

## 6. Nguồn

- writing-spec-for-ai/SKILL.md
- writing-spec-for-ai/references/principles.md
- writing-spec-for-ai/references/base-kit.md
- writing-spec-for-ai/templates/
- writing-spec-for-ai/agents/
- writing-spec-for-ai/skills/
- writing-spec-for-ai/profiles.md
- Explore skill (C:\Users\huong\.agents\skills\explore\SKILL.md)
- writing-plans skill (C:\Users\huong\.agents\skills\writing-plans\SKILL.md)
- documentation-and-adrs skill (C:\Users\huong\.agents\skills\documentation-and-adrs\SKILL.md)
