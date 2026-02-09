# Example Skill API Reference

## Overview

This document provides detailed technical reference for the example skill.

## Configuration Format

```json
{
  "name": "project-name",
  "version": "1.0.0",
  "environment": "production",
  "features": {
    "validation": true,
    "deployment": true
  }
}
```

## Script Usage

### deploy.sh

Deploys the application using the configuration from `config.json`.

**Usage:**
```bash
./scripts/deploy.sh
```

**Requirements:**
- Valid `config.json` in assets directory
- Proper permissions for deployment

### validate.sh

Validates the skill setup and configuration.

**Usage:**
```bash
./scripts/validate.sh
```

**Exit Codes:**
- `0`: Validation successful
- `1`: Validation failed

## Best Practices

1. Always run `validate.sh` before `deploy.sh`
2. Keep configuration files version controlled
3. Test in staging environment first
4. Monitor deployment logs for errors

## Troubleshooting

**Issue**: Configuration not found
**Solution**: Ensure `assets/config.json` exists

**Issue**: Permission denied
**Solution**: Make scripts executable with `chmod +x scripts/*.sh`
