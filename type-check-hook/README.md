# Python Type Hint & Security Check Hook

AI-powered pre-push git hook that checks Python code for type hints and security issues.

## Features

- ✅ Type hint analysis (missing hints, generic types)
- ✅ Security checks (hardcoded secrets, API keys)
- ✅ Fast (only analyzes changed files)
- ✅ Supports Claude Code, Codex CLI, and Cursor CLI

## Installation

```bash
./install.sh
```

Prompts for target repository path and installs:
- Pre-push hook to `.git/hooks/pre-push`
- Analysis prompt to `.claude/type-analysis-prompt.txt`

## How It Works

When you `git push`:
1. Detects changed Python files
2. Analyzes with Claude for issues
3. Shows report and asks for confirmation

**Good code** → proceeds automatically  
**Bad code** → shows issues, asks "Continue? (y/n)"

## Example Output

```
🔍 Pre-push Type Hint and Security Analysis

Analyzing: api/users.py

1. Location: api/users.py:15
   Problem: Missing return type hint
   Suggestion: Add -> UserProfile

2. Location: api/users.py:23
   Problem: CRITICAL - Hardcoded API key
   Suggestion: Move to environment variable

⚠️ Type hint issues found.
Continue with push? (y/n)
```

## Testing

Run validation suite:
```bash
cd tests
./validate.sh
```

Tests include:
- Clean code (passes)
- Type hint issues (detected)
- Security violations (flagged)
- Cross-file analysis

## Customization

Edit `type-analysis-prompt.txt` to modify checks.

## Disable

```bash
# Skip once
git push --no-verify

# Disable permanently
rm .git/hooks/pre-push
```

## Requirements

- Git repository
- One of:
  - [Claude Code](https://github.com/anthropics/claude-code)
  - [Codex CLI](https://github.com/openai/codex)
  - [Cursor CLI](https://cursor.com)
- Python files
