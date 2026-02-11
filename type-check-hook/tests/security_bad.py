"""Config with hardcoded secrets (BAD)."""

import requests


# SECURITY ISSUE: Hardcoded API key
API_KEY = "sk-1234567890abcdef"
AWS_SECRET = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
DATABASE_PASSWORD = "mySecretP@ssw0rd"


def connect_to_api():
    headers = {"Authorization": f"Bearer {API_KEY}"}
    return requests.get("https://api.example.com", headers=headers)


def get_db_connection():
    connection_string = f"postgresql://user:{DATABASE_PASSWORD}@localhost/db"
    return connection_string
