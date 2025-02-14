# Validation Utilities

This module provides a set of utility functions for input validation and sanitization in the restaurant review system.

## Features

- Email validation with proper format checking
- Input sanitization to remove HTML tags and trim whitespace
- Phone number validation and international format conversion

## Usage

```python
from utils.validation import validate_email, sanitize_input, validate_phone_number

# Validate email
is_valid = validate_email("user@example.com")  # Returns True

# Sanitize user input
clean_data = sanitize_input({
    "name": "  John Doe  ",
    "bio": "<script>alert('xss')</script>Hello World"
})
# Returns: {"name": "John Doe", "bio": "Hello World"}

# Validate phone number
formatted = validate_phone_number("+1 (555) 123-4567")
# Returns: "+15551234567"
```

## Testing

Run the tests using pytest:

```bash
pytest tests/test_validation.py
```