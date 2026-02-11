"""User and product data models."""

from pydantic import BaseModel, EmailStr


class UserProfile(BaseModel):
    user_id: int
    username: str
    email: EmailStr
    is_active: bool


class Product(BaseModel):
    product_id: int
    name: str
    price: float
    in_stock: bool


class OrderSummary(BaseModel):
    order_id: int
    total_amount: float
    items_count: int
