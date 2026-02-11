#!/bin/bash
# Validation script for type hint analysis

set -e

echo "🧪 Type Hint Analysis Validation Suite"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Change to script directory
cd "$(dirname "$0")"

# Expected issues per file
EXPECTED=(
    "domain_models.py:0"    # No issues
    "user_service.py:0"     # No issues
    "user_utils.py:3"       # Missing return types, generic List
    "data_processor.py:6"   # Multiple violations
)

echo -e "${BLUE}Running global analysis on all files...${NC}"
echo ""

# Run global analysis on all files together
ALL_FILES="domain_models.py user_service.py user_utils.py data_processor.py"

RESULT=$(claude --print --model haiku "Analyze these Python files for type hint issues:

Files to check:
$ALL_FILES

Check for:
1. Missing type hints on functions/methods/parameters
2. Generic types (Dict, Any, List, Tuple, dict, list without parameters) that should be Pydantic models or dataclasses
3. Functions returning Dict[str, Any] or plain dict instead of structured types
4. Missing EmailStr or other Pydantic validators where applicable
5. Plain dicts used for structured data instead of Pydantic models
6. Check if models from models.py could be used in other files

IMPORTANT OUTPUT FORMAT:
- If a file has NO issues, output NOTHING for that file (silent pass)
- If a file has issues, list them as numbered items:
  1. Location: file.py:line
     Problem: Brief description
     Suggestion: How to fix
- NO examples, NO code snippets, NO severity labels, NO issue titles
- Keep it concise and actionable

If ALL files are clean, respond with: 'All files passed type hint checks.'

Guidelines from CLAUDE.md:
- Use Pydantic BaseModel for ALL structured data
- Avoid Dict[str, Any] - use specific models
- All functions must have type hints
- Use Pydantic validators like EmailStr where appropriate" 2>&1)

echo "$RESULT"
echo ""
echo "======================================"
echo "Issue Count by File"
echo "======================================"

TESTS_PASSED=0
TESTS_FAILED=0

for expected in "${EXPECTED[@]}"; do
    FILE="${expected%%:*}"
    EXPECTED_COUNT="${expected##*:}"

    # Count issues for this file (look for "Location: filename:line")
    ACTUAL_COUNT=$(echo "$RESULT" | grep -o "Location: $FILE:[0-9]" | wc -l | tr -d ' ')

    # Accept a range (±1 from expected)
    LOWER=$((EXPECTED_COUNT > 0 ? EXPECTED_COUNT - 1 : 0))
    UPPER=$((EXPECTED_COUNT + 1))

    if [ "$ACTUAL_COUNT" -ge "$LOWER" ] && [ "$ACTUAL_COUNT" -le "$UPPER" ]; then
        echo -e "${GREEN}✓ $FILE${NC} - Found $ACTUAL_COUNT issues (expected ~$EXPECTED_COUNT)"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ $FILE${NC} - Found $ACTUAL_COUNT issues (expected ~$EXPECTED_COUNT)"
        ((TESTS_FAILED++))
    fi
done

echo ""
echo "======================================"
echo "Specific Validation Checks"
echo "======================================"

# Check 1: Should detect Dict[str, Any]
if echo "$RESULT" | grep -qi "Dict\[str, Any\]"; then
    echo -e "${GREEN}✓${NC} Detects Dict[str, Any] usage"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} Should detect Dict[str, Any] usage"
    ((TESTS_FAILED++))
fi

# Check 2: Should detect generic List
if echo "$RESULT" | grep -qi "generic.*List\|List without"; then
    echo -e "${GREEN}✓${NC} Detects generic List without parameters"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} Should detect generic List"
    ((TESTS_FAILED++))
fi

# Check 3: Should detect missing return types
if echo "$RESULT" | grep -qi "missing return"; then
    echo -e "${GREEN}✓${NC} Detects missing return types"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} Should detect missing return types"
    ((TESTS_FAILED++))
fi

# Check 4: Should suggest using Pydantic models
if echo "$RESULT" | grep -qi "pydantic\|UserProfile model\|domain_models"; then
    echo -e "${GREEN}✓${NC} Suggests using Pydantic models"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} Should suggest using Pydantic models"
    ((TESTS_FAILED++))
fi

echo ""
echo "======================================"
echo "Test Summary"
echo "======================================"
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi

# Test Security Check
echo ""
echo "======================================"
echo "Security Check Test"
echo "======================================"

SECURITY_RESULT=$(claude --print --model haiku "$(cat .claude/type-analysis-prompt.txt | sed 's|{FILES}|security_bad.py|g')" 2>&1)

if echo "$SECURITY_RESULT" | grep -qi "CRITICAL\|hardcoded\|secret\|API.*key\|password"; then
    echo -e "${GREEN}✓${NC} Detects hardcoded secrets"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} Should detect hardcoded secrets"
    echo "Result: $SECURITY_RESULT"
    ((TESTS_FAILED++))
fi

echo ""
echo "======================================"
echo "Final Summary"
echo "======================================"
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed including security!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
