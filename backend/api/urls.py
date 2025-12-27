from django.urls import path
from . import views

urlpatterns = [
    path("process-file/", views.process_file, name="process_file"),
    path("process-text/", views.process_text, name="process_text"),
    path("generate-pdf/", views.generate_pdf, name="generate_pdf"),
    path("generate-resume/", views.generate_resume, name="generate_resume"),
    path("upload-photo/", views.upload_photo, name="upload_photo"),
]

