"""User and product service functions."""

from domain_models import UserProfile, Product, OrderSummary


def get_user(user_id: int) -> UserProfile:
    return UserProfile(
        user_id=user_id,
        username="alice",
        email="alice@example.com",
        is_active=True
    )


def get_products() -> list[Product]:
    return [
        Product(product_id=1, name="Widget", price=9.99, in_stock=True),
        Product(product_id=2, name="Gadget", price=19.99, in_stock=False)
    ]


def count_active_users(users: list[UserProfile]) -> int:
    return sum(1 for user in users if user.is_active)


def create_order(user_id: int, items: list[Product]) -> OrderSummary:
    total = sum(p.price for p in items)
    return OrderSummary(
        order_id=12345,
        total_amount=total,
        items_count=len(items)
    )
