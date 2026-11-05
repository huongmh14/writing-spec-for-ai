---
name: idea-to-spec
description: Phân tích ý tưởng, đánh giá feasibility, scale, maintainability, viết spec, và review code sau implement. Dành cho user chỉ đưa ý tưởng, AI làm phần còn lại.
license: MIT
trigger_phrases:
  - "tôi có ý tưởng"
  - "phân tích dự án này"
  - "viết spec cho idea này"
  - "đánh giá khả năng làm dự án này"
  - "từ ý tưởng đến spec"
do_not_use:
  - "Khi đã có spec rõ ràng"
  - "Khi chỉ cần fix bug"
  - "Khi task nhỏ không cần phân tích"
  - "Khi project đã có AGENTS.md đầy đủ"
---

# Idea to Spec - Từ Ý Tưởng Đến Spec

**Mục tiêu:** User chỉ đưa ý tưởng → AI phân tích toàn diện → viết spec → review code sau implement.

**Khi nào dùng:**
- User có ý tưởng mới, chưa biết khả năng thực hiện
- User muốn đánh giá feasibility trước khi đầu tư
- User cần spec từ ý tưởng thô
- User muốn AI phân tích scale, maintainability

**Khi nào KHÔNG dùng:**
- Đã có spec rõ ràng → dùng `writing-spec-simple` hoặc `writing-spec-for-ai`
- Chỉ cần fix bug → dùng `systematic-debugging`
- Task nhỏ không cần phân tích → code trực tiếp

---

## Procedure (Look → Check)

### Step 1: LOOK - Thu Thập Thông Tin

**Mục tiêu:** Hiểu ý tưởng và context

- [ ] Đọc ý tưởng user đưa
- [ ] Hỏi clarifying questions (tối đa 3 câu):
  - "Ý tưởng này giải quyết vấn đề gì?"
  - "Ai là user mục tiêu?"
  - "Có deadline hoặc ràng buộc không?"
- [ ] Check project context (nếu có):
  - Đã có AGENTS.md chưa?
  - Project size bao nhiêu files?
  - Tech stack hiện tại là gì?

**Output:** Hiểu rõ ý tưởng + context

---

### Step 2: ANALYZE - Đánh Giá Khả Năng

**Mục tiêu:** Phân tích toàn diện trước khi viết spec

#### 2.1 Feasibility Analysis

**Câu hỏi cần trả lời:**
- Ý tưởng này có khả thi về mặt kỹ thuật không?
- Có dependencies phức tạp không?
- Có cần third-party services không?
- Có rủi ro kỹ thuật lớn không?

**Output:** `docs/idea-analysis.md` - Phần Feasibility

#### 2.2 Scale Prediction

**Câu hỏi cần trả lời:**
- Khi thành công, scale sẽ như thế nào?
- Dự đoán users, data, traffic?
- Kiến trúc có scale được không?
- Có bottlenecks tiềm ẩn không?

**Output:** `docs/idea-analysis.md` - Phần Scale

#### 2.3 Maintainability Assessment

**Câu hỏi cần trả lời:**
- Code có dễ maintain không?
- Technical debt risk là gì?
- Team size cần thiết?
- Documentation requirements?

**Output:** `docs/idea-analysis.md` - Phần Maintainability

#### 2.4 Dependencies & Risks

**Câu hỏi cần trả lời:**
- Dependencies bên ngoài là gì?
- Third-party services cần dùng?
- Rủi ro business/legal?
- Rủi ro kỹ thuật?

**Output:** `docs/idea-analysis.md` - Phần Dependencies & Risks

---

### Step 3: WRITE - Viết Spec

**Mục tiêu:** Tạo spec dựa trên phân tích

#### 3.1 Tạo Idea Analysis Document

**File:** `docs/idea-analysis.md`

```markdown
# Idea Analysis - [Tên ý tưởng]

## Feasibility
- **Khả năng kỹ thuật:** [Cao/Trung bình/Thấp]
- **Dependencies:** [List dependencies]
- **Rủi ro kỹ thuật:** [List risks]
- **Kết luận:** [Có khả thi không?]

## Scale Prediction
- **Dự đoán users:** [Số users dự kiến]
- **Dự đoán data:** [Data volume]
- **Dự đoán traffic:** [Requests/day]
- **Kiến trúc scale:** [Có scale được không?]

## Maintainability
- **Độ khó maintain:** [Dễ/Trung bình/Khó]
- **Technical debt risk:** [Low/Medium/High]
- **Team size cần:** [Số người]
- **Documentation needs:** [Yêu cầu docs]

## Dependencies & Risks
- **External dependencies:** [List]
- **Third-party services:** [List]
- **Business risks:** [List]
- **Technical risks:** [List]
```

#### 3.2 Tạo Spec Document

**File:** `docs/specs/SPEC-001-[feature-name].md`

**Chọn template dựa trên project size:**
- < 50 files → `writing-spec-simple/templates/SPEC.simple.md`
- ≥ 50 files → `writing-spec-for-ai/templates/docs/specs/_template.md`

**Spec phải bao gồm:**
- Requirements (REQ) với feasibility notes
- Architecture dự đoán scale
- Maintainability guidelines
- Review checklist

---

### Step 4: CHECK - Verify & Review

**Mục tiêu:** Đảm bảo spec đầy đủ và chính xác

- [ ] Spec có đủ REQ + AC?
- [ ] Feasibility analysis có rõ ràng?
- [ ] Scale prediction có realistic?
- [ ] Maintainability guidelines có đủ?
- [ ] Dependencies & risks có được document?
- [ ] User đã approve spec?

**Nếu user chưa approve:**
- Hỏi clarifying questions
- Cập nhật spec dựa trên feedback
- Repeat Step 3-4 cho đến khi approve

---

## Checks (5 tiêu chí Có/Không)

Trước khi claim "spec hoàn thành", phải check:

- [ ] **Check 1:** Có phân tích feasibility rõ ràng?
- [ ] **Check 2:** Có dự đoán scale cụ thể?
- [ ] **Check 3:** Có đánh giá maintainability?
- [ ] **Check 4:** Có spec với REQ + AC?
- [ ] **Check 5:** User đã approve?

**Nếu bất kỳ check nào = No → chưa hoàn thành, tiếp tục improve.**

---

## Guard (Rào Chắn An Toàn)

### ✅ Được Tự Làm
- Phân tích ý tưởng
- Viết spec
- Đánh giá feasibility, scale, maintainability
- Review code sau implement
- Hỏi clarifying questions

### ⚠️ Hỏi Trước
- Đổi scope lớn
- Thêm dependencies mới
- Thay đổi kiến trúc quan trọng
- Commit code khi chưa có spec approve

### 🚫 Không Bao Giờ
- Bịa feasibility analysis
- Hứa scale không thực tế
- Bỏ qua rủi ro
- Code khi spec chưa approve
- Commit secrets, tokens

---

## Resources

- `references/feasibility-framework.md` - Framework đánh giá feasibility
- `references/scale-prediction.md` - Cách dự đoán scale
- `references/maintainability-checklist.md` - Checklist maintainability

---

## Scripts

- `scripts/analyze-idea.sh` - Script phân tích ý tưởng tự động
- `scripts/generate-spec.sh` - Script tạo spec từ template

---

## Learn (Học Hỏi)

**Sau mỗi lần user sửa idea hoặc feedback:**

1. Ghi lại bài học vào `references/lessons-learned.md`
2. Thêm check mới vào skill nếu cần
3. Cập nhật procedure nếu cần

**Ví dụ:**
- User nói "ý tưởng này không khả thi vì X" → thêm vào feasibility framework
- User nói "scale prediction sai vì Y" → cập nhật scale prediction method

---

## Integration Với Skills Khác

| Bước | Skill | Mô tả |
|------|-------|-------|
| 1. Phân tích ý tưởng | `idea-to-spec` | Feasibility, scale, maintainability |
| 2. Viết spec | `writing-spec-simple` hoặc `writing-spec-for-ai` | Tùy project size |
| 3. Plan implementation | `writing-plans` | Chia nhỏ task |
| 4. Code | `tdd` hoặc direct | Implement |
| 5. Review | `code-review` | Check spec + standards |

---

**Tóm lại:** `idea-to-spec` là skill đầu vào - user chỉ cần đưa ý tưởng, AI làm phần còn lại: phân tích, viết spec, và chuẩn bị cho implementation.
