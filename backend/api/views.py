from django.shortcuts import render
from django.http import JsonResponse
from .services.file_parser import extract_text_from_file
from .services.ai_service import analyze_text
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from .services.cleaner import clean_text

from .services.ai_service import analyze_text_with_grok, generate_study_material




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








# generating files

from django.http import HttpResponse
from reportlab.platypus import SimpleDocTemplate, Paragraph
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.pagesizes import A4
import io
import json
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
@csrf_exempt
def generate_pdf(request):
    if request.method != "POST":
        return JsonResponse({"error": "Method not allowed"}, status=405)

    try:
        data = json.loads(request.body)
        title = data.get("title", "Generated Material")
        input_content = data.get("content", "")
        pages = data.get("pages", 0)

        # Basic validation
        if not input_content:
             return JsonResponse({"error": "Content or topic is required"}, status=400)

        # If pages > 0, we use AI to generate the full content
        final_content = input_content
        if pages > 0:
            try:
                # Call AI service to expand content
                # We interpret 'pages' as desired length guide
                final_content = generate_study_material(input_content, pages)
            except Exception as e:
                print(f"AI Generation failed: {e}")
                # Fallback to original content or return error? 
                # Let's return error so user knows AI failed
                return JsonResponse({"error": f"Failed to generate content: {str(e)}"}, status=500)

        # Generate PDF
        buffer = io.BytesIO()
        
        # Simple template configuration
        doc = SimpleDocTemplate(
            buffer,
            pagesize=A4,
            rightMargin=50,
            leftMargin=50,
            topMargin=50,
            bottomMargin=50,
        )

        styles = getSampleStyleSheet()
        # Create a custom title style
        title_style = styles["Title"]
        title_style.spaceAfter = 20
        
        # Create normal style
        normal_style = styles["Normal"]
        normal_style.spaceAfter = 12
        normal_style.leading = 16 # Line spacing
        
        # Heading styles for markdown-like headers
        h1_style = styles["Heading1"]
        h1_style.spaceBefore = 20
        h1_style.spaceAfter = 10
        
        h2_style = styles["Heading2"]
        h2_style.spaceBefore = 15
        h2_style.spaceAfter = 8

        story = []

        # Add Title
        story.append(Paragraph(title, title_style))

        # Process content (basic markdown-like parsing)
        # We handle newlines and maybe simple headers if Grok returns them
        lines = final_content.split("\n")
        
        for line in lines:
            line = line.strip()
            if not line:
                continue
                
            if line.startswith("# "):
                story.append(Paragraph(line[2:], h1_style))
            elif line.startswith("## "):
                story.append(Paragraph(line[3:], h2_style))
            elif line.startswith("- ") or line.startswith("* "):
                 # Bullet points
                 bullet_text = line[2:]
                 story.append(Paragraph(f"• {bullet_text}", normal_style))
            elif line[0].isdigit() and ". " in line[:4]:
                 # Numbered lists (simple detection)
                 story.append(Paragraph(line, normal_style))
            else:
                story.append(Paragraph(line, normal_style))

        doc.build(story)

        buffer.seek(0)
        
        response = HttpResponse(buffer, content_type="application/pdf")
        response["Content-Disposition"] = f'attachment; filename="{title}.pdf"'
        
        return response

    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON"}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
