#!/bin/bash
# Simplified validation - focuses on issue counts, accepts LLM variance

echo "🧪 Type Hint Analysis Validation"
echo "================================="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

cd "$(dirname "$0")"

# Expected ~issues per file
EXPECTED=(
    "domain_models.py:0"
    "user_service.py:0"
    "user_utils.py:3"
    "data_processor.py:5"
)

echo "Running analysis..."
echo ""

ALL_FILES="domain_models.py user_service.py user_utils.py data_processor.py"
PROMPT=$(cat ../type-analysis-prompt.txt | sed "s|{FILES}|$ALL_FILES|g")
RESULT=$(claude --print --model haiku "$PROMPT" 2>&1)

echo "$RESULT"
echo ""
echo "================================="
echo "Results"
echo "================================="

PASSED=0
FAILED=0

for expected in "${EXPECTED[@]}"; do
    FILE="${expected%%:*}"
    EXPECTED_COUNT="${expected##*:}"
    ACTUAL_COUNT=$(echo "$RESULT" | grep -o "Location: $FILE:[0-9]" | wc -l | tr -d ' ')
    
    # Accept ±1 variance
    LOWER=$((EXPECTED_COUNT > 0 ? EXPECTED_COUNT - 1 : 0))
    UPPER=$((EXPECTED_COUNT + 1))

    if [ "$ACTUAL_COUNT" -ge "$LOWER" ] && [ "$ACTUAL_COUNT" -le "$UPPER" ]; then
        echo -e "${GREEN}✓${NC} $FILE ($ACTUAL_COUNT issues)"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $FILE ($ACTUAL_COUNT issues, expected ~$EXPECTED_COUNT)"
        ((FAILED++))
    fi
done

echo ""
echo "Passed: $PASSED/4"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Validation passed!${NC}"
else
    echo -e "${RED}❌ $FAILED files outside expected range${NC}"
fi
