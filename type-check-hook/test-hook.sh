#!/bin/bash
# Test the pre-push hook

set -e

echo "🧪 Testing Pre-push Hook"
echo "========================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if hook exists
if [ ! -f .git/hooks/pre-push ]; then
    echo -e "${RED}✗ Hook not found at .git/hooks/pre-push${NC}"
    exit 1
fi

if [ ! -x .git/hooks/pre-push ]; then
    echo -e "${RED}✗ Hook exists but is not executable${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Hook exists and is executable"
echo ""

# Save current branch
CURRENT_BRANCH=$(git branch --show-current)

# Create test branch
TEST_BRANCH="test-hook-$$"
echo "Creating test branch: $TEST_BRANCH"
git checkout -b $TEST_BRANCH 2>/dev/null

echo ""
echo "Test 1: Push file with issues"
echo "------------------------------"

# Copy a bad file from tests
cp tests/data_processor.py test_hook_bad.py
git add test_hook_bad.py
git commit -m "Test: file with type issues" --no-verify

echo ""
echo "Attempting push (should detect issues)..."
echo "This will ask for confirmation - press 'n' to cancel"
echo ""

# Try to push (this will run the hook)
if git push origin $TEST_BRANCH 2>&1 | tee /tmp/hook_test.log; then
    echo ""
    echo -e "${YELLOW}Push completed - check if hook ran above${NC}"
else
    echo ""
    echo -e "${GREEN}✓ Push was blocked (expected)${NC}"
fi

echo ""
echo "Test 2: Push file without issues"
echo "----------------------------------"

# Reset and try with good file
git reset --soft HEAD~
git reset test_hook_bad.py
rm test_hook_bad.py

cp tests/domain_models.py test_hook_good.py
git add test_hook_good.py
git commit -m "Test: file without issues" --no-verify

echo ""
echo "Attempting push (should pass)..."
echo ""

if git push origin $TEST_BRANCH 2>&1 | tee /tmp/hook_test2.log; then
    echo ""
    echo -e "${GREEN}✓ Push succeeded (expected)${NC}"
else
    echo ""
    echo -e "${RED}✗ Push failed unexpectedly${NC}"
fi

echo ""
echo "Cleanup"
echo "-------"

# Cleanup
git checkout $CURRENT_BRANCH
git branch -D $TEST_BRANCH 2>/dev/null || true
git push origin --delete $TEST_BRANCH 2>/dev/null || true
rm -f test_hook_bad.py test_hook_good.py

echo -e "${GREEN}✓ Test complete and cleaned up${NC}"
echo ""
echo "Review:"
echo "- Test 1 should have shown issues and asked for confirmation"
echo "- Test 2 should have passed with no issues"
