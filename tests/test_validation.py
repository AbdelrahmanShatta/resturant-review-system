"""Tests for validation utility functions."""
import pytest
from utils.validation import validate_email, sanitize_input, validate_phone_number


def test_validate_email():
    """Test email validation function."""
    assert validate_email("user@example.com")
    assert validate_email("user.name+tag@example.co.uk")
    assert not validate_email("invalid.email@")
    assert not validate_email("@example.com")
    assert not validate_email("no-at-sign")


def test_sanitize_input():
    """Test input sanitization function."""
    test_data = {
        "name": "  John Doe  ",
        "bio": "<script>alert('xss')</script>Hello World<p>",
        "age": 25,
        "email": " user@example.com "
    }
    
    sanitized = sanitize_input(test_data)
    assert sanitized["name"] == "John Doe"
    assert sanitized["bio"] == "Hello World"
    assert sanitized["age"] == 25
    assert sanitized["email"] == "user@example.com"


def test_validate_phone_number():
    """Test phone number validation and formatting."""
    assert validate_phone_number("123-456-7890") == "+1234567890"
    assert validate_phone_number("+1 (555) 123-4567") == "+15551234567"
    assert validate_phone_number("12345") is None
    assert validate_phone_number("123456789012345678") is None