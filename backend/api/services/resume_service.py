from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from django.conf import settings
import os
import uuid


def generate_resume_pdf(data: dict) -> str:
    """
    data: validated resume data (dict)
    returns: relative PDF path
    """

    file_name = f"resume_{uuid.uuid4().hex}.pdf"
    output_dir = os.path.join(settings.MEDIA_ROOT, "resumes")
    os.makedirs(output_dir, exist_ok=True)

    file_path = os.path.join(output_dir, file_name)

    c = canvas.Canvas(file_path, pagesize=A4)
    width, height = A4

    y = height - 40

    def draw(text, size=11, space=18):
        nonlocal y
        c.setFont("Helvetica", size)
        c.drawString(40, y, text)
        y -= space

    # ---- HEADER ----
    draw(data["full_name"], 18, 26)
    draw(data["job_title"], 12)

    draw(f"Email: {data['email']}")
    draw(f"Phone: {data['phone']}")
    draw(f"Location: {data['location']}")

    y -= 20

    # ---- SUMMARY ----
    draw("Professional Summary", 14, 22)
    draw(data["summary"])

    y -= 20

    # ---- EXPERIENCE ----
    draw("Work Experience", 14, 22)
    for exp in data["experience"]:
        draw(f"{exp['job_title']} - {exp['company']}", 12)
        draw(exp["date"])
        draw(exp["description"])
        y -= 10

    y -= 20

    # ---- EDUCATION ----
    draw("Education", 14, 22)
    for edu in data["education"]:
        draw(f"{edu['degree']} - {edu['institution']}")
        draw(edu["date"])
        y -= 10

    y -= 20

    # ---- SKILLS ----
    draw("Skills", 14, 22)
    draw(", ".join(data["skills"]))

    y -= 20

    # ---- SOCIALS ----
    draw("Social Links", 14, 22)
    for key, value in data["socials"].items():
        if value:
            draw(f"{key.capitalize()}: {value}")

    c.showPage()
    c.save()

    return f"resumes/{file_name}"
