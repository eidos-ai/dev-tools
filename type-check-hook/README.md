# Python Type Hint & Security Check Hook

Intelligent pre-push git hook that analyzes Python code for:
- ✅ Missing type hints
- ✅ Generic types (Dict[str, Any], List, Tuple) that should be Pydantic models
- ✅ Hardcoded secrets (API keys, passwords, credentials)
- ✅ Security issues

## Features

- **AI-Powered Analysis**: Uses Claude (Haiku) for intelligent detection
- **Fast & Cheap**: Analyzes only changed files, uses efficient Haiku model
- **Interactive**: Shows issues and asks for confirmation before pushing
- **Customizable**: Edit prompt in `type-analysis-prompt.txt`
- **No GitHub Actions needed**: Runs locally, no extra API costs

## Installation

Run the installer and select a target repository:

```bash
./install.sh
```

The installer will:
1. Ask for the target repository path
2. Verify it's a git repository
3. Install the pre-push hook
4. Install the analysis prompt
5. Make the hook executable

## Manual Installation

If you prefer manual installation:

```bash
# Go to your target repo
cd /path/to/your/repo

# Copy the hook
cp /path/to/dev-tools/type-check-hook/pre-push .git/hooks/

# Copy the prompt
mkdir -p .claude
cp /path/to/dev-tools/type-check-hook/type-analysis-prompt.txt .claude/

# Make executable
chmod +x .git/hooks/pre-push
```

## How It Works

When you `git push`:

1. **Detects changed Python files** in your commits
2. **Analyzes them** using Claude for type hints and security issues
3. **Shows results**:
   - ✅ Clean files → proceeds automatically
   - ⚠️ Issues found → shows detailed report and asks for confirmation

## Example Output

### Bad Code (with issues)
```
🔍 Pre-push Type Hint and Security Analysis

Analyzing Python files:
  • api/users.py

1. Location: api/users.py:15
   Problem: Missing return type hint
   Suggestion: Add -> UserProfile return type

2. Location: api/users.py:23
   Problem: CRITICAL - Hardcoded API key detected
   Suggestion: Move to environment variable

⚠️  Type hint issues found.

Continue with push? (y/n)
```

### Clean Code
```
🔍 Pre-push Type Hint and Security Analysis

Analyzing Python files:
  • api/users.py

✓ Type hints look great!
```

## Testing

### Run Validation Suite
```bash
cd tests
./validate.sh
```

Tests:
- Clean files pass (0 issues)
- Problem files detect correct issues
- Security checks work
- Cross-file analysis

### Manual Testing
See [TESTING.md](TESTING.md) for manual testing steps.

## Customization

### Edit the Prompt

Modify `type-analysis-prompt.txt` to:
- Add new checks
- Change output format
- Adjust security rules

### Disable Temporarily

```bash
# Skip hook for one push
git push --no-verify

# Disable permanently
mv .git/hooks/pre-push .git/hooks/pre-push.disabled
```

## Requirements

- Git repository
- Claude Code CLI installed
- Python files to analyze

## What It Checks

### Type Hints
- Missing type hints on functions/methods/parameters
- Generic types without parameters (List, Dict, Tuple)
- Dict[str, Any] instead of Pydantic models
- Plain dicts for structured data
- Missing Pydantic validators (EmailStr, etc.)

### Security
- Hardcoded API keys
- Exposed passwords
- AWS credentials
- Database connection strings
- Any sensitive data that should be in .env

## Test Files

The `tests/` directory contains:
- `domain_models.py` - Clean Pydantic models (0 issues)
- `user_service.py` - Proper usage (0 issues)
- `user_utils.py` - Mixed issues (~3 issues)
- `data_processor.py` - Bad practices (~6 issues)
- `security_bad.py` - Hardcoded secrets (CRITICAL)

## More Info

See main [dev-tools README](../README.md) for all available tools.
