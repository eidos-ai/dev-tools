# Universal AGENTS.md Installer

Share AI agent instructions across your team, regardless of which AI coding tool each person uses.

## Usage

1. Clone this repository
2. Pull latest changes: `git pull`
3. Run the interactive installer: `./install.sh`
4. Select your AI coding tool (Claude Code, Windsurf, or Cursor)
5. Choose components to install (AGENTS.md, Skills, or both)
6. Confirm installation

The installer will:
- Validate all files before installation (dry run)
- Prompt before creating directories
- Handle conflicts with existing files (overwrite/append/cancel)
- Automatically install to the correct global location for your tool
- Skip example-skill (template only, not installed)

---

## Global Installation Paths

| Tool | AGENTS.md Location | Skills Location |
|------|-------------------|-----------------|
| **Claude Code** | `~/.claude/CLAUDE.md` | `~/.claude/skills/` |
| **Windsurf** | `~/.codeium/windsurf/AGENTS.md` | `~/.codeium/windsurf/skills/` |
| **Cursor** | Manual (Settings UI) | `~/.cursor/skills/` |

**Note**: For Cursor, AGENTS.md must be manually copied to: Cursor Settings → Rules for AI

---

## Skills Format

**Note**: The `skills/example-skill/` directory serves as a template/reference and is automatically excluded from installation. It demonstrates all optional components (scripts, references, assets, examples) that skills can include.

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
