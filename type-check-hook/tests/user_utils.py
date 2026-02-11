"""User management utilities."""

from domain_models import UserProfile
from typing import List


def authenticate_user(user_id: int) -> UserProfile:
    return UserProfile(
        user_id=user_id,
        username="bob",
        email="bob@example.com",
        is_active=True
    )


def get_user_data(user_id: int):
    return {
        "user_id": user_id,
        "username": "charlie",
        "email": "charlie@example.com",
        "is_active": True
    }


def batch_process(users: List) -> int:
    return len([u for u in users if u.is_active])


def get_settings():
    return {"theme": "dark", "notifications": True}
