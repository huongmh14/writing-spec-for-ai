#!/bin/bash
# Skill Health Check Script
# Chạy định kỳ để đánh giá spec-writing skills

echo "=== Skill Health Check ==="
echo ""

# Check 1: Skills có license field không
echo "1. Checking license field in skills..."
missing_license=0
for skill in auto-guide starter-guide cheat-sheet writing-spec-simple; do
  if ! grep -q "license:" "C:\Users\huong\.agents\skills\$skill\SKILL.md" 2>/dev/null; then
    echo "  ❌ $skill: missing license field"
    missing_license=$((missing_license + 1))
  else
    echo "  ✅ $skill: has license field"
  fi
done
echo ""

# Check 2: Skills có "When NOT to use" không
echo "2. Checking 'When NOT to use' sections..."
missing_when_not=0
for skill in auto-guide starter-guide cheat-sheet writing-spec-simple; do
  if ! grep -qi "when not to use\|không dùng khi\|when to avoid" "C:\Users\huong\.agents\skills\$skill\SKILL.md" 2>/dev/null; then
    echo "  ❌ $skill: missing 'When NOT to use' section"
    missing_when_not=$((missing_when_not + 1))
  else
    echo "  ✅ $skill: has 'When NOT to use' section"
  fi
done
echo ""

# Check 3: Skills có references/ folder không
echo "3. Checking progressive disclosure structure..."
missing_references=0
for skill in writing-spec-simple; do
  if [ ! -d "C:\Users\huong\.agents\skills\$skill\references" ]; then
    echo "  ❌ $skill: missing references/ folder"
    missing_references=$((missing_references + 1))
  else
    echo "  ✅ $skill: has references/ folder"
  fi
done
echo ""

# Check 4: Skills có templates/ folder không
echo "4. Checking templates/ folder..."
missing_templates=0
for skill in writing-spec-simple; do
  if [ ! -d "C:\Users\huong\.agents\skills\$skill\templates" ]; then
    echo "  ❌ $skill: missing templates/ folder"
    missing_templates=$((missing_templates + 1))
  else
    echo "  ✅ $skill: has templates/ folder"
  fi
done
echo ""

# Summary
echo "=== Summary ==="
echo "Missing license fields: $missing_license"
echo "Missing 'When NOT to use' sections: $missing_when_not"
echo "Missing references/ folders: $missing_references"
echo "Missing templates/ folders: $missing_templates"
echo ""

total_issues=$((missing_license + missing_when_not + missing_references + missing_templates))
if [ $total_issues -eq 0 ]; then
  echo "✅ All checks passed!"
  exit 0
else
  echo "❌ $total_issues issue(s) found"
  exit 1
fi
