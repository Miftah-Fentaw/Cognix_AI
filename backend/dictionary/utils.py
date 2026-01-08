from .constants import SUPPORTED_LANGUAGES

def validate_languages(source, target):
    if source not in SUPPORTED_LANGUAGES:
        return False, f"Unsupported source language: {source}"

    if target not in SUPPORTED_LANGUAGES:
        return False, f"Unsupported target language: {target}"

    if source == target:
        return False, "Source and target languages must be different"

    return True, None
