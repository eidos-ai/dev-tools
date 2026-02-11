# Dev Tools

Collection of development tools and utilities for the team.

## Available Tools

### 1. 🤖 AGENTS.md Installer

Universal installer for sharing AI coding guidelines across different AI tools (Claude Code, Windsurf, Cursor, Antigravity).

**Location**: [`agents/`](agents/)

**Quick start**:
```bash
cd agents
./install.sh
```

[Read more →](agents/README.md)

---

### 2. 🔍 Python Type Check Hook

Intelligent pre-push git hook that analyzes Python code for type hints and security issues.

**Location**: [`type-check-hook/`](type-check-hook/)

**Features**:
- ✅ Type hint analysis
- ✅ Detects Dict[str, Any] and generic types
- ✅ Security checks (hardcoded secrets, API keys)
- ✅ AI-powered with Claude
- ✅ Fast (only analyzes changed files)

**Quick start**:
```bash
cd type-check-hook
./install.sh
```

[Read more →](type-check-hook/README.md)

---

## Installation

Each tool has its own installation script. Navigate to the tool's directory and run `./install.sh`.

## Requirements

- **AGENTS.md Installer**: Bash shell
- **Type Check Hook**:
  - Git repository
  - Claude Code CLI ([install](https://github.com/anthropics/claude-code))
  - Python projects

## Contributing

When adding new tools:
1. Create a new directory for the tool
2. Include README.md with usage instructions
3. Include install.sh if installation is needed
4. Update this main README

## License

Internal team tools - not for external distribution.
