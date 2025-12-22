from django.shortcuts import render
from django.http import JsonResponse
from .services.file_parser import extract_text_from_file
from .services.ai_service import analyze_text
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from .services.cleaner import clean_text
from .services.ai_service import analyze_text_with_ollama


@csrf_exempt
@require_POST
def process_text(request):
    try:
        data = json.loads(request.body.decode("utf-8"))
        raw_text = data.get("text", "").strip()

        if not raw_text:
            return JsonResponse(
                {"error": "Text field is required"},
                status=400
            )

        cleaned_text = clean_text(raw_text)

        result = analyze_text_with_ollama(cleaned_text)

        return JsonResponse(result, status=200)

    except json.JSONDecodeError:
        return JsonResponse(
            {"error": "Invalid JSON"},
            status=400
        )


@csrf_exempt
def process_file(request):
    if request.method == "POST" and request.FILES.get("file"):
        uploaded_file = request.FILES["file"]
        try:
            text = extract_text_from_file(uploaded_file)
        except ValueError as e:
            return JsonResponse({"error": str(e)}, status=400)

        result = analyze_text(text)
        return JsonResponse(result)

    return JsonResponse({"error": "No file uploaded"}, status=400)




@csrf_exempt
@require_POST
def process_text(request):
    try:
        data = json.loads(request.body.decode("utf-8"))
        raw_text = data.get("text", "").strip()

        if not raw_text:
            return JsonResponse(
                {"error": "Text field is required"},
                status=400
            )

        cleaned_text = clean_text(raw_text)

        result = analyze_text_with_ollama(cleaned_text)

        return JsonResponse(result, status=200)

    except json.JSONDecodeError:
        return JsonResponse(
            {"error": "Invalid JSON"},
            status=400
        )

    except Exception as e:
        return JsonResponse(
            {"error": str(e)},
            status=500
        )