"""
Test file demonstrating BAD type hinting practices.

This file violates CLAUDE.md guidelines:
- Uses Dict[str, Any] instead of Pydantic models
- Missing type hints on functions
- Generic List, Tuple, Dict without specifics
- Uses Any type
- Plain dicts for structured data
"""

from typing import Dict, Any, Tuple, List


def get_user_data(user_id):
    """
    BAD: Missing return type hint.
    BAD: Returns dict instead of Pydantic model.
    """
    return {
        "user_id": user_id,
        "name": "John",
        "email": "john@example.com",
        "is_active": True,
        "metadata": {"role": "user", "department": "engineering"}
    }


def process_users(users: List) -> Dict[str, Any]:
    """
    BAD: Generic List without type parameter.
    BAD: Returns Dict[str, Any] instead of structured model.
    """
    return {
        "count": len(users),
        "data": users,
        "status": "success"
    }


def get_user_info(user_id: int):
    """
    BAD: Missing return type.
    BAD: Returns tuple without type annotation.
    """
    return (user_id, "John", "john@example.com", True)


def fetch_metadata() -> Any:
    """
    BAD: Returns Any type.
    BAD: Should return specific Pydantic model.
    """
    return {"key": "value", "another_key": 123}


def get_user_preferences(user_id):
    """
    BAD: Missing parameter type hint.
    BAD: Missing return type.
    BAD: Returns plain dict.
    """
    return {
        "theme": "dark",
        "notifications": True,
        "language": "en"
    }


def calculate_stats(user_id: int) -> dict:
    """
    BAD: Generic dict return type without specifics.
    Should be Dict[str, int] or better yet, a Pydantic model.
    """
    return {
        "login_count": 42,
        "post_count": 128,
        "follower_count": 256
    }


def merge_data(data1, data2):
    """
    BAD: Missing all type hints.
    BAD: No return type.
    """
    return {**data1, **data2}


def get_user_list() -> List:
    """
    BAD: Generic List without type parameter.
    Should be list[UserProfile] or List[UserProfile].
    """
    return [
        {"id": 1, "name": "Alice"},
        {"id": 2, "name": "Bob"}
    ]


def validate_email(email: str):
    """
    BAD: Missing return type hint (should be -> bool).
    """
    return "@" in email


def get_config() -> Dict:
    """
    BAD: Generic Dict without type parameters.
    Should be Dict[str, str] or a Config model.
    """
    return {"host": "localhost", "port": "8080"}


def process_response(response: Any) -> Any:
    """
    BAD: Uses Any for both input and output.
    Should use specific types or Pydantic models.
    """
    if isinstance(response, dict):
        return response.get("data")
    return None


def get_user_tuple(user_id: int) -> Tuple:
    """
    BAD: Generic Tuple without type parameters.
    Should be Tuple[int, str, str] or a Pydantic model.
    """
    return (user_id, "John", "john@example.com")


def batch_process(items: list) -> dict:
    """
    BAD: Lowercase 'list' and 'dict' are valid in Python 3.9+
    but still too generic - should specify contents.
    Should be list[UserProfile] and dict[str, int] or models.
    """
    return {"processed": len(items), "success": True}
