# Dev Tools

Collection of development tools and utilities for the team.

## Lazy Installation

Open your AI agent inside the repository you want to install the tool on and use one of these prompts:

**Install the type check hook**:
```
I want to install a pre-push git hook from our internal team repo (eidos-ai/dev-tools). This hook analyzes Python files for type hint issues and hardcoded secrets before pushing. It installs 3 files into .git/hooks/: a pre-push script, a prompt template, and a config file. Read the installation guide by running `gh api repos/eidos-ai/dev-tools/contents/AGENTS.md --jq '.content' | base64 -d` and follow the steps for "Tool 2: Python Type Check Hook". Ask me which AI CLI I want to use (Claude Code, Codex CLI, or Cursor CLI) before proceeding.
```

**Install the coding guidelines**:
```
I want to install AI coding guidelines from our internal team repo (eidos-ai/dev-tools). This copies an AGENTS.md file with coding standards (type safety, naming conventions, error handling) to the appropriate config location for my AI tool. Read the installation guide by running `gh api repos/eidos-ai/dev-tools/contents/AGENTS.md --jq '.content' | base64 -d` and follow the steps for "Tool 1: AGENTS.md Installer". Ask me which AI tool I use (Claude Code, Windsurf, Cursor, or Antigravity) before proceeding.
```

Requires `gh` CLI authenticated with access to this repo.

---

## Available Tools

### 1. Python Type Check Hook

Intelligent pre-push git hook that analyzes Python code for type hints and security issues.

**Location**: [`type-check-hook/`](type-check-hook/)

**Features**:
- Type hint analysis
- Detects Dict[str, Any] and generic types
- Security checks (hardcoded secrets, API keys)
- Supports Claude Code, Codex CLI, and Cursor CLI
- Fast (only analyzes changed files)

**Manual install**:
```bash
cd type-check-hook
./install.sh
```

[Read more](type-check-hook/README.md)

---

### 2. AGENTS.md Installer

Universal installer for sharing AI coding guidelines across different AI tools (Claude Code, Windsurf, Cursor, Antigravity).

**Location**: [`agents/`](agents/)

**Manual install**:
```bash
cd agents
./install.sh
```

[Read more](agents/README.md)

---

## Requirements

- **Type Check Hook**:
  - Git repository
  - One of: [Claude Code](https://github.com/anthropics/claude-code), [Codex CLI](https://github.com/openai/codex), or [Cursor CLI](https://cursor.com)
  - Python projects
- **AGENTS.md Installer**: Bash shell

## Contributing

When adding new tools:
1. Create a new directory for the tool
2. Include README.md with usage instructions
3. Include install.sh if installation is needed
4. Update this main README and AGENTS.md

## License

Internal team tools - not for external distribution.
