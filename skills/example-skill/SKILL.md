---
name: example-skill
description: Example skill demonstrating all optional components. Use to test skill installation across different AI coding tools.
---

# Example Skill

This skill demonstrates how to structure a complete skill with scripts, references, and assets.

## When to Use

- Testing skill installation for Claude Code, Windsurf, or Cursor
- Learning how to structure skills with supporting files
- Validating that all components are copied correctly

## Instructions

1. **Check for scripts**: Look in the `scripts/` directory for helper scripts
2. **Review references**: Check `references/REFERENCE.md` for detailed documentation
3. **Use assets**: Load configuration from `assets/config.json` when needed
4. **Execute validation**: Run `scripts/validate.sh` to verify setup

## Supporting Files

This skill includes:
- `scripts/deploy.sh` - Example deployment script
- `scripts/validate.sh` - Validation helper
- `references/REFERENCE.md` - Detailed API documentation
- `assets/config.json` - Configuration template
- `examples/sample-usage.md` - Usage examples (Claude Code)

## Best Practices

- Always validate configuration before deployment
- Check references for API details
- Run validation scripts before executing
