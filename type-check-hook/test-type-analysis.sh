#!/bin/bash
# Quick script to test type hint analysis on test files

echo "🔍 Testing Type Hint Analysis"
echo ""

if [ -n "$1" ]; then
    # Analyze specific file
    FILE="$1"
    echo "Analyzing: $FILE"
    echo ""
else
    # Analyze all test files
    FILE="test_bad_types.py test_good_types.py"
    echo "Analyzing: test_bad_types.py and test_good_types.py"
    echo ""
fi

# Load prompt from file
PROMPT=$(cat .claude/type-analysis-prompt.txt | sed "s|{FILES}|$FILE|g")
claude --print --model haiku "$PROMPT"
