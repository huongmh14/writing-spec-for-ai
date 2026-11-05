#!/bin/bash
# Analyze idea and generate basic spec structure
# Usage: ./analyze-idea.sh "idea description"

IDEA="$1"
DATE=$(date +%Y-%m-%d)

if [ -z "$IDEA" ]; then
  echo "Usage: $0 \"idea description\""
  exit 1
fi

mkdir -p docs/specs docs/analysis

echo "=== Idea Analysis ==="
echo "Idea: $IDEA"
echo "Date: $DATE"
echo ""

cat > "docs/analysis/idea-$DATE.md" << EOF
# Idea Analysis - $DATE

## Original Idea
$IDEA

## Feasibility Assessment
- Technical feasibility: [To be filled]
- Resource feasibility: [To be filled]
- Market feasibility: [To be filled]
- Overall score: [To be filled]

## Scale Prediction
- Expected users: [To be filled]
- Data volume: [To be filled]
- Traffic estimate: [To be filled]

## Maintainability
- Code quality needs: [To be filled]
- Team size: [To be filled]
- Technical debt risk: [To be filled]

## Dependencies & Risks
- External dependencies: [To be filled]
- Third-party services: [To be filled]
- Business risks: [To be filled]
- Technical risks: [To be filled]

## Next Steps
- [ ] Complete feasibility analysis
- [ ] Define scale requirements
- [ ] Assess maintainability
- [ ] Create spec document
EOF

echo "Created: docs/analysis/idea-$DATE.md"
echo "Next: Fill in the analysis sections"
