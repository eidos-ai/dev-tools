"""
Test file demonstrating EXCELLENT type hinting practices.

This file follows best practices from CLAUDE.md:
- Uses Pydantic BaseModel for ALL structured data
- Leverages Pydantic's built-in types (EmailStr, etc.)
- No plain dicts - everything is a proper model
- All functions have complete type hints
- Specific types instead of generic Dict[str, Any]
- No use of Any type
"""

from pydantic import BaseModel, EmailStr


class UserMetadata(BaseModel):
    """Structured metadata instead of dict[str, str]."""
    role: str
    department: str
    hire_date: str


class UserProfile(BaseModel):
    """User profile with proper Pydantic types."""
    user_id: int
    username: str
    email: EmailStr
    is_active: bool
    metadata: UserMetadata


class UserPreferences(BaseModel):
    """User preferences with specific types."""
    theme: str
    notifications_enabled: bool
    language: str


class UserStats(BaseModel):
    """User statistics."""
    login_count: int
    last_login: str
    total_posts: int


class MergedUserData(BaseModel):
    """Structured response instead of generic dict."""
    profile: UserProfile
    preferences: UserPreferences
    stats: UserStats


def get_user_profile(user_id: int) -> UserProfile:
    """
    Retrieve user profile by ID.

    Returns a properly typed Pydantic model instead of Dict[str, Any].
    Uses EmailStr for validation and UserMetadata model instead of dict.
    """
    return UserProfile(
        user_id=user_id,
        username="john_doe",
        email="john@example.com",
        is_active=True,
        metadata=UserMetadata(
            role="user",
            department="engineering",
            hire_date="2024-01-15"
        )
    )


def get_user_list() -> list[UserProfile]:
    """
    Get list of users with specific type hint.

    Uses list[UserProfile] instead of List or List[Any].
    """
    return [
        UserProfile(
            user_id=1,
            username="alice",
            email="alice@example.com",
            is_active=True,
            metadata=UserMetadata(role="admin", department="ops", hire_date="2023-06-01")
        ),
        UserProfile(
            user_id=2,
            username="bob",
            email="bob@example.com",
            is_active=False,
            metadata=UserMetadata(role="user", department="sales", hire_date="2023-08-15")
        )
    ]


def get_user_preferences(user_id: int) -> UserPreferences:
    """
    Retrieve user preferences.

    Returns a structured Pydantic model.
    """
    return UserPreferences(
        theme="dark",
        notifications_enabled=True,
        language="en"
    )


def calculate_user_stats(user_id: int) -> UserStats:
    """
    Calculate user statistics.

    All parameters and return types are properly annotated.
    """
    return UserStats(
        login_count=42,
        last_login="2026-02-09",
        total_posts=128
    )


def merge_user_data(
    profile: UserProfile,
    preferences: UserPreferences,
    stats: UserStats
) -> MergedUserData:
    """
    Merge multiple user data sources.

    Returns a structured MergedUserData model instead of a generic dict.
    This is better than dict[str, UserProfile | UserPreferences | UserStats].
    """
    return MergedUserData(
        profile=profile,
        preferences=preferences,
        stats=stats
    )


def get_user_emails(user_ids: list[int]) -> list[EmailStr]:
    """
    Get user emails.

    Uses Pydantic's EmailStr type for validation.
    """
    return [
        EmailStr("alice@example.com"),
        EmailStr("bob@example.com")
    ]


def validate_user_data(profile: UserProfile) -> bool:
    """
    Validate user data.

    Takes structured input, returns clear boolean.
    No generic types, no Any.
    """
    return profile.is_active and profile.email is not None
