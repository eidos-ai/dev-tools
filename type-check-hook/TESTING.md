# Testing the Pre-push Hook

## Quick Test (Manual)

### Test 1: File with Issues

```bash
# Add a file with type hint issues
cp tests/data_processor.py test_temp.py
git add test_temp.py
git commit -m "Test commit"
git push

# Expected: Hook should detect issues and ask for confirmation
# Press 'n' to cancel the push
```

### Test 2: Clean File

```bash
# Add a file without issues
cp tests/domain_models.py test_temp.py
git add test_temp.py
git commit -m "Test commit"
git push

# Expected: Hook should pass with no issues
```

### Cleanup

```bash
git reset --soft HEAD~
git reset test_temp.py
rm test_temp.py
```

## Automated Test

Run the automated test script:

```bash
./test-hook.sh
```

This will:
1. Create a test branch
2. Test with a bad file (should detect issues)
3. Test with a good file (should pass)
4. Clean up everything

## What to Look For

### Bad File Test
You should see:
```
🔍 Pre-push Type Hint Analysis

Analyzing Python files:
  • test_temp.py

Running intelligent type hint analysis...

[List of issues found]

⚠️  Type hint issues found.

Continue with push? (y/n)
```

### Good File Test
You should see:
```
🔍 Pre-push Type Hint Analysis

Analyzing Python files:
  • test_temp.py

Running intelligent type hint analysis...

All files passed type hint checks.

✓ Type hints look great!
```

## Verify Hook Installation

```bash
# Check hook exists and is executable
ls -la .git/hooks/pre-push

# Should show: -rwxr-xr-x (note the 'x' for executable)
```

## Disable Hook Temporarily

```bash
# To skip hook for one push
git push --no-verify

# To disable permanently
mv .git/hooks/pre-push .git/hooks/pre-push.disabled
```

## Re-enable Hook

```bash
mv .git/hooks/pre-push.disabled .git/hooks/pre-push
```
