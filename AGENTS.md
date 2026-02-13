# Dev Tools - AI Agent Installation Guide

This file is for AI agents to read and execute installations automatically. The user is expected to be inside the target repository already.

**IMPORTANT**: Before proceeding with any installation, you MUST ask the user which tool they want to install and any required configuration choices (marked with "ASK THE USER" below). Do NOT assume or skip these questions.

**Fetching files**: This is a private repository. Use `gh` CLI to fetch files:
```bash
gh api repos/eidos-ai/dev-tools/contents/<FILE_PATH> --jq '.content' | base64 -d > <OUTPUT_PATH>
```

## Tool 1: AGENTS.md Installer

Installs AI coding guidelines to the user's global config.

**ASK THE USER**: Which AI tool do you use? (Claude Code, Windsurf, Cursor, or Antigravity)

**Source file path**: `agents/AGENTS.md`

**Target paths**:

| Tool         | Target Path                          | Action     |
|--------------|--------------------------------------|------------|
| Claude Code  | `~/.claude/CLAUDE.md`                | Copy file  |
| Windsurf     | `~/.codeium/windsurf/AGENTS.md`      | Copy file  |
| Cursor       | Cursor Settings > Rules for AI       | Paste content |
| Antigravity  | `~/.gemini/GEMINI.md`                | Copy file  |

**Steps**:

1. Ask the user which AI tool they use
2. Fetch the source file:
   ```bash
   gh api repos/eidos-ai/dev-tools/contents/agents/AGENTS.md --jq '.content' | base64 -d > /tmp/AGENTS.md
   ```
3. Create target directory if needed: `mkdir -p <TARGET_DIR>`
4. If target file exists, back it up: `cp <TARGET> <TARGET>.backup`
5. Copy to target: `cp /tmp/AGENTS.md <TARGET_PATH>`
6. For Cursor: show the file contents and tell the user to paste into Cursor Settings > Rules for AI

---

## Tool 2: Python Type Check Hook

Installs an AI-powered pre-push git hook that analyzes Python files for type hint issues and hardcoded secrets.

**ASK THE USER**: Which AI CLI do you want to use? (Claude Code, Codex CLI, or Cursor CLI)

The target repository is the current working directory. Validate that `.git` exists.

**Source file paths**:
- `type-check-hook/pre-push`
- `type-check-hook/type-analysis-prompt.txt`

**Steps**:

1. If `.git/hooks/pre-push` exists, back it up:
   ```bash
   cp .git/hooks/pre-push .git/hooks/pre-push.backup
   ```

2. Fetch and install the hook:
   ```bash
   gh api repos/eidos-ai/dev-tools/contents/type-check-hook/pre-push --jq '.content' | base64 -d > .git/hooks/pre-push
   chmod +x .git/hooks/pre-push
   ```

3. Fetch the prompt template:
   ```bash
   gh api repos/eidos-ai/dev-tools/contents/type-check-hook/type-analysis-prompt.txt --jq '.content' | base64 -d > .git/hooks/type-analysis-prompt.txt
   ```

4. Create the config file with the chosen CLI:
   ```bash
   echo "AI_CLI=<CHOSEN_CLI>" > .git/hooks/type-check-config.conf
   ```

   Where `<CHOSEN_CLI>` is one of:

   | User choice  | Config value    |
   |--------------|-----------------|
   | Claude Code  | `claude`        |
   | Codex CLI    | `codex`         |
   | Cursor CLI   | `cursor-agent`  |

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
