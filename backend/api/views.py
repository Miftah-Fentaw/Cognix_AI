from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from .services.file_parser import extract_text_from_file
from .services.ai_service import analyze_text, analyze_text_with_grok, generate_study_material
from .services.cleaner import clean_text
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
import json
import io
import os
import requests
from django.conf import settings
from reportlab.pdfgen import canvas
from reportlab.lib.units import cm
from reportlab.platypus import Frame, Paragraph, SimpleDocTemplate
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import ImageReader
from PIL import Image


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


# Remove duplicates
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



























def generate_resume_pdf(data):
    buffer = io.BytesIO()
    c = canvas.Canvas(buffer, pagesize=A4)
    width, height = A4

    y = height - 2 * cm

    # ===== HEADER =====
    c.setFont("Helvetica-Bold", 18)
    c.drawString(2 * cm, y, data["personalInfo"]["fullName"])
    y -= 20

    c.setFont("Helvetica", 11)
    c.drawString(2 * cm, y, data["personalInfo"]["jobTitle"])
    y -= 15

    c.setFont("Helvetica", 10)
    c.drawString(
        2 * cm,
        y,
        f'{data["personalInfo"]["email"]} | {data["personalInfo"]["phone"]} | {data["personalInfo"]["location"]}'
    )
    y -= 25

    # ===== PHOTO =====
    photo_url = data["personalInfo"].get("photoPath")
    if photo_url:
        try:
            # Optimize: use local path if it's a media URL to avoid self-requests which might hang single-threaded dev server
            if "/media/" in photo_url:
                relative_path = photo_url.split("/media/")[-1]
                local_path = os.path.join(settings.MEDIA_ROOT, relative_path)
                if os.path.exists(local_path):
                    img = Image.open(local_path)
                else:
                    img_data = requests.get(photo_url).content
                    img = Image.open(io.BytesIO(img_data))
            else:
                img_data = requests.get(photo_url).content
                img = Image.open(io.BytesIO(img_data))
                
            img.thumbnail((120, 120))
            img_io = io.BytesIO()
            img.save(img_io, format="PNG")
            c.drawImage(ImageReader(img_io), 15 * cm, height - 4 * cm, width=3 * cm, height=3 * cm)
        except Exception as e:
            print(f"Error including photo in PDF: {e}")
            pass


    # ===== SUMMARY =====
    draw_title(c, "PROFESSIONAL SUMMARY", y)
    y -= 18

    styles = getSampleStyleSheet()
    frame = Frame(2 * cm, y - 60, 17 * cm, 60, showBoundary=0)
    frame.addFromList(
        [Paragraph(data["professionalSummary"], styles["Normal"])],
        c
    )
    y -= 80

    # ===== EXPERIENCE =====
    draw_title(c, "WORK EXPERIENCE", y)
    y -= 18

    for exp in data["workExperiences"]:
        c.setFont("Helvetica-Bold", 10)
        c.drawString(2 * cm, y, f'{exp["jobTitle"]} — {exp["companyName"]}')
        y -= 12

        c.setFont("Helvetica-Oblique", 9)
        c.drawString(2 * cm, y, exp["dateRange"])
        y -= 12

        c.setFont("Helvetica", 9)
        frame = Frame(2 * cm, y - 40, 17 * cm, 40, showBoundary=0)
        frame.addFromList(
            [Paragraph(exp["responsibilities"], styles["Normal"])],
            c
        )
        y -= 50

    # ===== EDUCATION =====
    draw_title(c, "EDUCATION", y)
    y -= 18

    for edu in data["educations"]:
        c.setFont("Helvetica-Bold", 10)
        c.drawString(2 * cm, y, edu["degree"])
        y -= 12

        c.setFont("Helvetica", 9)
        c.drawString(2 * cm, y, f'{edu["institution"]} ({edu["dateRange"]})')
        y -= 18

    # ===== SKILLS =====
    draw_title(c, "SKILLS", y)
    y -= 18
    c.setFont("Helvetica", 9)
    c.drawString(2 * cm, y, data["skills"])
    y -= 25

    # ===== SOCIAL LINKS =====
    draw_title(c, "LINKS", y)
    y -= 18

    links = data["socialLinks"]
    c.setFont("Helvetica", 9)
    if links["linkedin"]:
        c.drawString(2 * cm, y, f'LinkedIn: {links["linkedin"]}')
        y -= 12
    if links["github"]:
        c.drawString(2 * cm, y, f'GitHub: {links["github"]}')
        y -= 12
    if links["portfolio"]:
        c.drawString(2 * cm, y, f'Portfolio: {links["portfolio"]}')
        y -= 12

    c.showPage()
    c.save()

    buffer.seek(0)
    return buffer

def draw_title(c, text, y):
    c.setFont("Helvetica-Bold", 12)
    c.drawString(2 * cm, y, text)
    c.line(2 * cm, y - 2, 19 * cm, y - 2)

@csrf_exempt
def upload_photo(request):
    if request.method == "POST" and request.FILES.get("photo"):
        photo = request.FILES["photo"]
        
        # Ensure media directory exists
        media_path = os.path.join(settings.MEDIA_ROOT, "photos")
        if not os.path.exists(media_path):
            os.makedirs(media_path, exist_ok=True)
            
        file_name = f"{photo.name}"
        file_path = os.path.join(media_path, file_name)
        
        with open(file_path, 'wb+') as destination:
            for chunk in photo.chunks():
                destination.write(chunk)
                
        # Return online URL for reportlab
        photo_url = f"{request.scheme}://{request.get_host()}{settings.MEDIA_URL}photos/{file_name}"
        return JsonResponse({
            "success": True,
            "photo_url": photo_url
        })
    return JsonResponse({"error": "No photo uploaded"}, status=400)

@csrf_exempt
def generate_resume(request):
    if request.method != "POST":
        return JsonResponse({"error": "POST only"}, status=405)

    try:
        data = json.loads(request.body)
        pdf_buffer = generate_resume_pdf(data)
        
        # Save buffer to media folder
        full_name = data.get("personalInfo", {}).get("fullName", "resume")
        file_name = f"resume_{full_name.replace(' ', '_')}.pdf"
        media_path = os.path.join(settings.MEDIA_ROOT, "resumes")
        if not os.path.exists(media_path):
            os.makedirs(media_path, exist_ok=True)
            
        file_path = os.path.join(media_path, file_name)
        with open(file_path, 'wb') as f:
            f.write(pdf_buffer.getbuffer())
            
        pdf_url = f"{settings.MEDIA_URL}resumes/{file_name}"

        return JsonResponse({
            "success": True,
            "pdf_url": pdf_url
        })

    except Exception as e:
        print(f"Resume Generation Error: {e}")
        return JsonResponse({
            "success": False,
            "error": f"Internal server error: {str(e)}"
        }, status=400)

