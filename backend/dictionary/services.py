# dictionary/services.py
import requests

LIBRETRANSLATE_URL = "https://libretranslate.com/translate"
MYMEMORY_URL = "https://api.mymemory.translated.net/get"

def translate_text_libre(text, source_lang, target_lang):
    try:
        payload = {
            "q": text,
            "source": source_lang,
            "target": target_lang,
            "format": "text"
        }
        response = requests.post(LIBRETRANSLATE_URL, json=payload, timeout=10)
        response.raise_for_status()
        return response.json().get("translatedText")
    except Exception as e:
        print("LibreTranslate error:", e)
        return None

def translate_text_mymemory(text, source_lang, target_lang):
    try:
        params = {"q": text, "langpair": f"{source_lang}|{target_lang}"}
        response = requests.get(MYMEMORY_URL, params=params, timeout=10)
        response.raise_for_status()
        return response.json().get("responseData", {}).get("translatedText")
    except Exception as e:
        print("MyMemory error:", e)
        return None

def translate_text(text, source_lang, target_lang):
    """
    Main service: try LibreTranslate, fallback to MyMemory
    """
    translated = translate_text_libre(text, source_lang, target_lang)
    if translated:
        return translated
    return translate_text_mymemory(text, source_lang, target_lang)
