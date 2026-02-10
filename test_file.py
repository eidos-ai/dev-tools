"""Data processing utilities."""

from typing import Dict, Any, Tuple


def fetch_user(user_id):
    return {"id": user_id, "name": "John", "email": "john@example.com"}


def update_profile(data: Dict[str, Any]):
    return data.get("id")


def get_credentials() -> Tuple:
    return ("username", "password", "api_key")


def load_config() -> Any:
    return {
        "host": "localhost",
        "port": 8080,
        "debug": True
    }


def process_items(items):
    return [item.upper() for item in items]
