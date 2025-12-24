from django.shortcuts import render
from django.http import JsonResponse
from .services.file_parser import extract_text_from_file
from .services.ai_service import analyze_text
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from .services.cleaner import clean_text

from .services.ai_service import analyze_text_with_grok




@csrf_exempt
def process_file(request):
    if request.method == "POST" and request.FILES.get("file"):
        uploaded_file = request.FILES["file"]
        try:
            text = extract_text_from_file(uploaded_file)
            print(f"DEBUG: Extracted {len(text)} chars from file. Preview: {text[:200]}...")
            
            result = analyze_text(text)
            return JsonResponse(result)
        except ValueError as e:
            return JsonResponse({"error": str(e)}, status=400)
        except Exception as e:
            print(f"Server Error: {e}")
            return JsonResponse({"error": f"Processing failed: {str(e)}"}, status=500)

    return JsonResponse({"error": "No file uploaded"}, status=400)




@csrf_exempt
@require_POST
def process_text(request):
    try:
        data = json.loads(request.body.decode("utf-8"))
        raw_text = data.get("text", "").strip()

        if not raw_text:
            return JsonResponse({"error": "Text field is required"}, status=400)

        cleaned_text = clean_text(raw_text)

        # Use Grok-backed analysis
        result = analyze_text_with_grok(cleaned_text)

        return JsonResponse(result, status=200)

    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON"}, status=400)

    except EnvironmentError as e:
        # Missing configuration such as GROK_API_KEY
        return JsonResponse({"error": str(e)}, status=500)

    except Exception as e:
        # Log and return a concise error. Logs contain details.
        return JsonResponse({"error": "Internal server error", "details": str(e)}, status=500)