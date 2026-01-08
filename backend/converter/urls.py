from django.urls import path
from . import views

urlpatterns = [
    path('convert-image/', views.convert_image, name='convert-image'),
    path('convert-pdf/', views.convert_pdf, name='convert-pdf'),
    path('convert-doc/', views.convert_doc, name='convert-doc'),
    path('convert-pptx/', views.convert_pptx, name='convert-pptx'),
    path('convert-txt/', views.convert_txt, name='convert-txt'),
    path('convert-csv/', views.convert_csv, name='convert-csv'),
    path('convert-json/', views.convert_json, name='convert-json'),
]
