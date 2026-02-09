# Universal AGENTS.md Installer

Share AI agent instructions across your team, regardless of which AI coding tool each person uses.

## Usage

1. Clone this repository
2. Pull latest changes: `git pull`
3. Run install script: `./install.sh --tool <your-tool>`
4. Agent instructions are installed globally to your tool's config

---

## Global Installation Paths

| Tool | File Name | Global Location | Format |
|------|-----------|-----------------|--------|
| **Claude Code** | `CLAUDE.md` | `~/.claude/CLAUDE.md` | Plain markdown |
| **Windsurf** | `AGENTS.md` | `~/.codeium/windsurf/AGENTS.md` | Plain markdown |
| **Cursor** | User Rules | Cursor Settings UI | Plain markdown |

### Claude Code
```bash
cp AGENTS.md ~/.claude/CLAUDE.md
```
- Plain markdown
- Automatically loaded in every conversation

### Windsurf
```bash
mkdir -p ~/.codeium/windsurf
cp AGENTS.md ~/.codeium/windsurf/AGENTS.md
```
- Plain markdown
- Case-insensitive (`AGENTS.md` or `agents.md`)

### Cursor
Cursor's global config is managed through Settings UI, not files.

**Option 1: User Rules (Recommended)**
1. Open Cursor Settings
2. Go to "Cursor Settings" → "Rules for AI"
3. Paste contents of `AGENTS.md`

**Option 2: Team Rules (Enterprise)**
- Managed via Cursor dashboard
- Syncs automatically to all team members

---

## Installation Script TODO

The `install.sh` script will:
1. Detect which tool to install for (or prompt user)
2. Copy `AGENTS.md` to the appropriate global location
3. Handle file naming (rename to `CLAUDE.md` for Claude Code)
4. Backup existing files before overwriting
5. Verify installation success

---

---

## Skills Format

### Claude Code
**Location**: `~/.claude/skills/<skill-name>/SKILL.md`

**Structure**:
```
~/.claude/skills/
└── skill-name/
    ├── SKILL.md (required - YAML + markdown)
    ├── template.md (optional)
    ├── examples/ (optional)
    └── scripts/ (optional)
```

**SKILL.md Format**:
```yaml
---
name: skill-identifier
description: What this skill does and when to use it
---

Your skill instructions in markdown...
```

### Windsurf
**Location**: `~/.codeium/windsurf/skills/<skill-name>/SKILL.md`

**Structure**:
```
~/.codeium/windsurf/skills/
└── skill-name/
    ├── SKILL.md (required - YAML + markdown)
    └── supporting-files.* (optional)
```

**SKILL.md Format**:
```yaml
---
name: skill-identifier
description: Brief explanation of purpose
---

Skill content and instructions...
```

### Cursor
**Location**: `~/.cursor/skills/<skill-name>/` or `~/.claude/skills/<skill-name>/`

**Structure**:
```
~/.cursor/skills/
└── skill-name/
    ├── SKILL.md (required - YAML + markdown)
    ├── scripts/ (optional)
    ├── references/ (optional)
    └── assets/ (optional)
```

**SKILL.md Format**:
```yaml
---
name: skill-identifier
description: Brief description and usage context
disable-model-invocation: false (optional)
---

Detailed instructions...
```

---

## Resources

- [Claude Code: Using CLAUDE.md files](https://claude.com/blog/using-claude-md-files)
- [Claude Code: Skills documentation](https://code.claude.com/docs/en/skills)
- [Windsurf: AGENTS.md documentation](https://docs.windsurf.com/windsurf/cascade/agents-md)
- [Windsurf: Skills documentation](https://docs.windsurf.com/windsurf/cascade/skills)
- [Cursor: Rules documentation](https://cursor.com/docs/context/rules)
- [Cursor: Agent Skills documentation](https://cursor.com/docs/context/skills)
