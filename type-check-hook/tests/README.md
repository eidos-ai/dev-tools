# Type Hint Analysis Test Suite

Comprehensive validation suite for the intelligent type hint analysis system.

## Test Files (Realistic Code)

All test files look like real production code - no hints or comments about expected issues.

### 1. `domain_models.py` (0 issues expected)
Clean Pydantic models that other files can import:
- UserProfile (with EmailStr)
- Product
- OrderSummary

### 2. `user_service.py` (0 issues expected)
Proper usage importing and using models correctly:
- All functions properly typed
- Uses Pydantic models everywhere
- Imports from domain_models.py

### 3. `user_utils.py` (3 issues expected)
Mix of good and bad practices:
- Line 16: Missing return type (returns dict instead of UserProfile)
- Line 25: Generic `List` without type parameter
- Line 29: Missing return type

### 4. `data_processor.py` (6 issues expected)
Multiple violations:
- Line 6: Missing parameter type hint
- Line 6: Missing return type
- Line 10: `Dict[str, Any]` usage
- Line 10: Missing return type
- Line 14: Generic `Tuple` without parameters
- Line 18: `Any` return type
- Line 26: Missing parameter type hint
- Line 26: Missing return type

## Key Features

### Global Analysis
The validation runs **global analysis** on all files together, allowing the analyzer to:
- See imports between files
- Suggest using models from domain_models.py in other files
- Understand the full codebase context

### Realistic Code
Files contain no hints:
- No "Issue 1:" comments
- No "Expected issues:" markers
- No "Should use Pydantic model" comments
- Just real-looking production code

### Automated Validation
The script automatically:
- Counts issues per file
- Verifies specific violation types are detected
- Checks if analyzer suggests using Pydantic models
- Validates cross-file awareness

## Running Tests

```bash
# Run full validation suite
./tests/validate.sh

# Manual test (analyzes all files together)
cd tests
claude --print --model haiku "Analyze domain_models.py user_service.py user_utils.py data_processor.py for type hint issues"
```

## Expected Output

```
🧪 Type Hint Analysis Validation Suite
======================================

Running global analysis on all files...

[Analysis results showing issues in user_utils.py and data_processor.py]

======================================
Issue Count by File
======================================
✓ domain_models.py - Found 0 issues (expected 0)
✓ user_service.py - Found 0 issues (expected 0)
✓ user_utils.py - Found 3 issues (expected 3)
✓ data_processor.py - Found 6 issues (expected 6)

======================================
Specific Validation Checks
======================================
✓ Detects Dict[str, Any] usage
✓ Detects generic List without parameters
✓ Detects missing return types
✓ Suggests using Pydantic models

======================================
Test Summary
======================================
Tests Passed: 8
Tests Failed: 0

🎉 All tests passed!
```

## What's Being Validated

1. **Clean files pass** - domain_models.py and user_service.py have 0 issues
2. **Issues detected accurately** - Correct count for each problematic file
3. **Specific violations caught**:
   - Dict[str, Any] usage
   - Generic types without parameters
   - Missing return/parameter types
4. **Cross-file awareness** - Analyzer suggests using models from domain_models.py
5. **Global context** - Analysis considers all files together, not isolated
