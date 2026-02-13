# Dev Tools - AI Agent Installation Guide

This file is for AI agents to read and execute installations automatically. Do not use the interactive `install.sh` scripts — follow the steps below directly.

## Repository Layout

```
dev-tools/
  agents/
    AGENTS.md                        # AI coding guidelines
  skills/
    example-skill/                   # Template only, do not install
  type-check-hook/
    pre-push                         # Git hook script
    type-analysis-prompt.txt         # LLM prompt template
```

## Tool 1: AGENTS.md Installer

Copies AI coding guidelines to the user's global config.

**Ask the user**: Which AI tool do you use?

**Source file**: `agents/AGENTS.md`

**Target paths**:

| Tool         | Target Path                          | Action     |
|--------------|--------------------------------------|------------|
| Claude Code  | `~/.claude/CLAUDE.md`                | Copy file  |
| Windsurf     | `~/.codeium/windsurf/AGENTS.md`      | Copy file  |
| Cursor       | Cursor Settings > Rules for AI       | Paste content |
| Antigravity  | `~/.gemini/GEMINI.md`                | Copy file  |

**Steps**:

1. Ask the user which AI tool they use
2. Create target directory if needed: `mkdir -p <TARGET_DIR>`
3. If target file exists, back it up: `cp <TARGET> <TARGET>.backup`
4. Copy: `cp <REPO>/agents/AGENTS.md <TARGET_PATH>`
5. For Cursor: print the file contents and tell the user to paste into Cursor Settings > Rules for AI

**Optional — Skills**:

Copy each subdirectory from `skills/` EXCEPT `example-skill/`:

| Tool         | Skills Target Path                    |
|--------------|---------------------------------------|
| Claude Code  | `~/.claude/skills/`                   |
| Windsurf     | `~/.codeium/windsurf/skills/`         |
| Cursor       | `~/.cursor/skills/`                   |
| Antigravity  | `~/.gemini/antigravity/skills/`       |

```bash
cp -r <REPO>/skills/<skill_name> <SKILLS_TARGET>/<skill_name>
```

---

## Tool 2: Python Type Check Hook

Installs an AI-powered pre-push git hook that analyzes Python files for type hint issues and hardcoded secrets.

**Ask the user**:
1. Which AI CLI? (`claude`, `codex`, or `cursor-agent`)
2. Absolute path to the target git repository

**Validate**: Confirm `<TARGET_REPO>/.git` exists.

**Source files**:
- `type-check-hook/pre-push`
- `type-check-hook/type-analysis-prompt.txt`

**Steps**:

1. If `<TARGET_REPO>/.git/hooks/pre-push` exists, back it up:
   ```bash
   cp <TARGET_REPO>/.git/hooks/pre-push <TARGET_REPO>/.git/hooks/pre-push.backup
   ```

2. Copy the hook:
   ```bash
   cp <REPO>/type-check-hook/pre-push <TARGET_REPO>/.git/hooks/pre-push
   chmod +x <TARGET_REPO>/.git/hooks/pre-push
   ```

3. Copy the prompt template:
   ```bash
   cp <REPO>/type-check-hook/type-analysis-prompt.txt <TARGET_REPO>/.git/hooks/type-analysis-prompt.txt
   ```

4. Create the config file:
   ```bash
   echo "AI_CLI=<CHOSEN_CLI>" > <TARGET_REPO>/.git/hooks/type-check-config.conf
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
ls -la <TARGET_REPO>/.git/hooks/pre-push
ls -la <TARGET_REPO>/.git/hooks/type-analysis-prompt.txt
ls -la <TARGET_REPO>/.git/hooks/type-check-config.conf
```

After AGENTS.md installation:
```bash
ls -la <TARGET_PATH>
```
