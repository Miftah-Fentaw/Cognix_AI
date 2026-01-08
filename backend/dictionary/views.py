from django.shortcuts import render


from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

from .services import translate_text
from .utils import validate_languages

@csrf_exempt
def translate_view(request):
    if request.method != "POST":
        return JsonResponse({"error": "Only POST method allowed"}, status=405)

    try:
        data = json.loads(request.body)
        text = data.get("text", "").strip()
        source_lang = data.get("source_lang")
        target_lang = data.get("target_lang")

        if not text:
            return JsonResponse({"error": "Text is required"}, status=400)

        valid, error_msg = validate_languages(source_lang, target_lang)
        if not valid:
            return JsonResponse({"error": error_msg}, status=400)

        translated_text = translate_text(text, source_lang, target_lang)
        if not translated_text:
            return JsonResponse({"error": "Translation failed"}, status=500)

        return JsonResponse({
            "text": text,
            "source_lang": source_lang,
            "target_lang": target_lang,
            "translation": translated_text
        })

    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON"}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
