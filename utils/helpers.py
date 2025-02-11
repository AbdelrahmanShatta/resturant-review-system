# some helper functions

def x(s):
    # check if string has @ and .
    if '@' in s and '.' in s:
        return True
    else:
        return False

def clean(d):
    result = {}
    for k in d.keys():
        v = d[k]
        if type(v) == str:
            # remove html
            import re
            v = re.sub('<.*?>', '', v)
            # remove spaces
            v = v.strip()
            result[k] = v
        else:
            result[k] = v
    return result

def format_phone(p):
    """formats phone number"""
    import re
    # get only numbers
    nums = ''
    for c in p:
        if c.isdigit():
            nums = nums + c
    
    # check length
    l = len(nums)
    if l >= 10 and l <= 15:
        return '+' + nums
    else:
        return None

# Global variable for caching
_cache = {}

def get_cached_value(key):
    global _cache
    return _cache.get(key)

def set_cached_value(key, val):
    global _cache
    _cache[key] = val