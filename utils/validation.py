"""Utility functions for input validation and sanitization."""
from typing import Optional, Dict, Any
import re


def validate_email(email: str) -> bool:
    """
    Validate an email address format.

    Args:
        email: The email address to validate.

    Returns:
        bool: True if the email is valid, False otherwise.
    """
    pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    return bool(re.match(pattern, email))


def sanitize_input(data: Dict[str, Any]) -> Dict[str, Any]:
    """
    Sanitize user input by removing leading/trailing whitespace and HTML tags.

    Args:
        data: Dictionary containing user input data.

    Returns:
        Dict[str, Any]: Sanitized data dictionary.
    """
    sanitized = {}
    for key, value in data.items():
        if isinstance(value, str):
            # Remove HTML tags and trim whitespace
            clean_value = re.sub(r"<[^>]*>", "", value).strip()
            sanitized[key] = clean_value
        else:
            sanitized[key] = value
    return sanitized


def validate_phone_number(phone: str) -> Optional[str]:
    """
    Validate and format a phone number.

    Args:
        phone: The phone number to validate.

    Returns:
        Optional[str]: Formatted phone number if valid, None otherwise.
    """
    # Remove all non-digit characters
    digits = re.sub(r"\D", "", phone)
    
    # Check if we have a valid number of digits (10-15)
    if 10 <= len(digits) <= 15:
        # Format as international number
        return f"+{digits}"
    return None