# AI Assistant Guidelines

This file contains company-wide standards for AI assistants working with our codebase.

## Communication Style

- Answer briefly, concise, and simple
- Don't be verbose
- Get straight to the point

## Code Standards

### Clean Code Principles

- Follow KISS (Keep It Simple, Stupid) principle
- Write clean, readable code
- No inline comments unless absolutely necessary
- Let the code speak for itself

### Python Type Safety

- Use datamodels/dataclasses for structured data
- Default to Pydantic models unless another library is explicitly defined in the project
- All functions must have type hints
- Avoid generic typing like `Dict[str, Any]` - be specific about types
- Use proper type annotations that provide meaningful information

### Error Handling

- Use specific exception types instead of bare `except:`
- Let errors propagate when appropriate rather than silencing them
- Include meaningful error messages with context
- Don't catch exceptions you can't handle

### Dependencies & Configuration

- Never hardcode secrets, API keys, or credentials
- Store sensitive data in `.env` files (gitignored)

### Logging

- Use proper logging instead of print statements
- Include context in log messages
- Use appropriate log levels (DEBUG, INFO, WARNING, ERROR)
- Configure logging at application startup

### Naming Conventions

- Follow PEP 8 standards
- `snake_case` for functions and variables
- `PascalCase` for classes
- `UPPER_SNAKE_CASE` for constants
- Use descriptive names that reveal intent
- Avoid abbreviations unless widely understood

### Example

```python
from pydantic import BaseModel

class UserProfile(BaseModel):
    user_id: int
    username: str
    email: str
    is_active: bool

def get_user_profile(user_id: int) -> UserProfile:
    return UserProfile(
        user_id=user_id,
        username="example",
        email="user@example.com",
        is_active=True
    )
```
