# AGENTS.md Installer

Universal installer for sharing AI agent instructions across different AI coding tools.

## What This Does

Installs `AGENTS.md` (AI coding guidelines) to:
- **Claude Code**: `~/.claude/CLAUDE.md`
- **Windsurf**: `~/.codeium/windsurf/AGENTS.md`
- **Cursor**: Manual installation via Settings UI
- **Antigravity (Gemini)**: `~/.gemini/GEMINI.md`

## Installation

```bash
cd agents
./install.sh
```

The installer will:
1. Show you the current `AGENTS.md` content
2. Detect installed AI coding tools
3. Ask which tools to install to
4. Handle conflicts if existing files are found
5. Create backups before overwriting

## Usage

After installation, your AI coding tools will follow the guidelines in `AGENTS.md` for all projects.

## Uninstall

Remove the installed files manually:
```bash
rm ~/.claude/CLAUDE.md
rm ~/.codeium/windsurf/AGENTS.md
rm ~/.gemini/GEMINI.md
```

## More Info

See main [dev-tools README](../README.md) for all available tools.
