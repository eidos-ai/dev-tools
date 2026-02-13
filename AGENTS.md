# Dev Tools - AI Agent Installation Guide

This file is for AI agents to read and execute installations automatically. The user is expected to be inside the target repository already. Fetch source files from the raw URLs below — do not clone the repo.

**Base URL**: `https://raw.githubusercontent.com/eidos-ai/dev-tools/main`

## Tool 1: AGENTS.md Installer

Installs AI coding guidelines to the user's global config.

**Ask the user**: Which AI tool do you use?

**Source**: `<BASE_URL>/agents/AGENTS.md`

**Target paths**:

| Tool         | Target Path                          | Action     |
|--------------|--------------------------------------|------------|
| Claude Code  | `~/.claude/CLAUDE.md`                | Copy file  |
| Windsurf     | `~/.codeium/windsurf/AGENTS.md`      | Copy file  |
| Cursor       | Cursor Settings > Rules for AI       | Paste content |
| Antigravity  | `~/.gemini/GEMINI.md`                | Copy file  |

**Steps**:

1. Ask the user which AI tool they use
2. Fetch the source file: `curl -fsSL <BASE_URL>/agents/AGENTS.md -o /tmp/AGENTS.md`
3. Create target directory if needed: `mkdir -p <TARGET_DIR>`
4. If target file exists, back it up: `cp <TARGET> <TARGET>.backup`
5. Copy to target: `cp /tmp/AGENTS.md <TARGET_PATH>`
6. For Cursor: show the file contents and tell the user to paste into Cursor Settings > Rules for AI

---

## Tool 2: Python Type Check Hook

Installs an AI-powered pre-push git hook that analyzes Python files for type hint issues and hardcoded secrets.

**Ask the user**: Which AI CLI? (`claude`, `codex`, or `cursor-agent`)

The target repository is the current working directory. Validate that `.git` exists.

**Source files**:
- `<BASE_URL>/type-check-hook/pre-push`
- `<BASE_URL>/type-check-hook/type-analysis-prompt.txt`

**Steps**:

1. If `.git/hooks/pre-push` exists, back it up:
   ```bash
   cp .git/hooks/pre-push .git/hooks/pre-push.backup
   ```

2. Fetch and install the hook:
   ```bash
   curl -fsSL <BASE_URL>/type-check-hook/pre-push -o .git/hooks/pre-push
   chmod +x .git/hooks/pre-push
   ```

3. Fetch the prompt template:
   ```bash
   curl -fsSL <BASE_URL>/type-check-hook/type-analysis-prompt.txt -o .git/hooks/type-analysis-prompt.txt
   ```

4. Create the config file with the chosen CLI:
   ```bash
   echo "AI_CLI=<CHOSEN_CLI>" > .git/hooks/type-check-config.conf
   ```

**CLI reference**:

| CLI Value       | Full Command                              |
|-----------------|-------------------------------------------|
| `claude`        | `claude --print --model haiku`            |
| `codex`         | `codex exec -m gpt-5-codex-mini`          |
| `cursor-agent`  | `cursor-agent -p --model gemini-3-flash`  |

---

## Verification

After type-check hook installation:
```bash
ls -la .git/hooks/pre-push
ls -la .git/hooks/type-analysis-prompt.txt
ls -la .git/hooks/type-check-config.conf
```

After AGENTS.md installation:
```bash
ls -la <TARGET_PATH>
```
