from django.http import JsonResponse, FileResponse
from django.views.decorators.csrf import csrf_exempt
from .converters import (
    image_converter, pdf_converter, doc_converter, pptx_converter,
    txt_converter, csv_converter, json_converter
)
import logging

logger = logging.getLogger(__name__)

def get_file_extension(target_type):
    """Get appropriate file extension for target type"""
    ext_map = {
        'PDF': 'pdf', 'DOCX': 'docx', 'DOC': 'doc', 'TXT': 'txt',
        'PNG': 'png', 'JPG': 'jpg', 'JPEG': 'jpg', 'WEBP': 'webp',
        'GIF': 'gif', 'BMP': 'bmp', 'TIFF': 'tiff',
        'PPTX': 'pptx', 'CSV': 'csv', 'JSON': 'json',
        'XLS': 'xls', 'XLSX': 'xlsx'
    }
    return ext_map.get(target_type.upper(), target_type.lower())

def get_content_type(target_type):
    """Get appropriate content type for target type"""
    content_types = {
        'PDF': 'application/pdf',
        'DOCX': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'DOC': 'application/msword',
        'TXT': 'text/plain',
        'PNG': 'image/png',
        'JPG': 'image/jpeg',
        'JPEG': 'image/jpeg',
        'WEBP': 'image/webp',
        'GIF': 'image/gif',
        'BMP': 'image/bmp',
        'TIFF': 'image/tiff',
        'PPTX': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
        'CSV': 'text/csv',
        'JSON': 'application/json',
        'XLS': 'application/vnd.ms-excel',
        'XLSX': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'ZIP': 'application/zip'
    }
    return content_types.get(target_type.upper(), 'application/octet-stream')

@csrf_exempt
def convert_image(request):
    if request.method == 'POST' and 'file' in request.FILES:
        try:
            uploaded_file = request.FILES['file']
            target_type = request.POST.get('target_type')
            
            if not target_type:
                return JsonResponse({'error': 'target_type is required'}, status=400)
            
            converted_file = image_converter.convert(uploaded_file, target_type)
            ext = get_file_extension(target_type)
            content_type = get_content_type(target_type)
            
            response = FileResponse(converted_file, as_attachment=True, filename=f'converted.{ext}')
            response['Content-Type'] = content_type
            response['Content-Disposition'] = f'attachment; filename="converted.{ext}"'
            return response
        except Exception as e:
            logger.error(f"Image conversion error: {str(e)}")
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request'}, status=400)

@csrf_exempt
def convert_pdf(request):
    if request.method == 'POST' and 'file' in request.FILES:
        try:
            uploaded_file = request.FILES['file']
            target_type = request.POST.get('target_type')
            
            if not target_type:
                return JsonResponse({'error': 'target_type is required'}, status=400)
            
            converted_file = pdf_converter.convert(uploaded_file, target_type)
            
            # Check if it's a ZIP file (multi-page images)
            if target_type.upper() in ['PNG', 'JPG', 'JPEG', 'WEBP']:
                # Check file size to determine if it's a ZIP
                converted_file.seek(0, 2)  # Seek to end
                size = converted_file.tell()
                converted_file.seek(0)  # Reset to beginning
                
                # If larger than expected for single image, it's likely a ZIP
                if size > 1024 * 1024:  # > 1MB suggests ZIP
                    ext = 'zip'
                    content_type = 'application/zip'
                else:
                    ext = get_file_extension(target_type)
                    content_type = get_content_type(target_type)
            else:
                ext = get_file_extension(target_type)
                content_type = get_content_type(target_type)
            
            response = FileResponse(converted_file, as_attachment=True, filename=f'converted.{ext}')
            response['Content-Type'] = content_type
            return response
        except Exception as e:
            logger.error(f"PDF conversion error: {str(e)}")
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request'}, status=400)

@csrf_exempt
def convert_doc(request):
    if request.method == 'POST' and 'file' in request.FILES:
        try:
            uploaded_file = request.FILES['file']
            target_type = request.POST.get('target_type')
            
            if not target_type:
                return JsonResponse({'error': 'target_type is required'}, status=400)
            
            converted_file = doc_converter.convert(uploaded_file, target_type)
            ext = get_file_extension(target_type)
            content_type = get_content_type(target_type)
            
            response = FileResponse(converted_file, as_attachment=True, filename=f'converted.{ext}')
            response['Content-Type'] = content_type
            return response
        except Exception as e:
            logger.error(f"DOC conversion error: {str(e)}")
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request'}, status=400)

@csrf_exempt
def convert_pptx(request):
    if request.method == 'POST' and 'file' in request.FILES:
        try:
            uploaded_file = request.FILES['file']
            target_type = request.POST.get('target_type')
            
            if not target_type:
                return JsonResponse({'error': 'target_type is required'}, status=400)
            
            converted_file = pptx_converter.convert(uploaded_file, target_type)
            
            # Check if it's a ZIP file (multi-slide images)
            if target_type.upper() in ['PNG', 'JPG', 'JPEG']:
                converted_file.seek(0, 2)
                size = converted_file.tell()
                converted_file.seek(0)
                
                if size > 1024 * 1024:  # > 1MB suggests ZIP
                    ext = 'zip'
                    content_type = 'application/zip'
                else:
                    ext = get_file_extension(target_type)
                    content_type = get_content_type(target_type)
            else:
                ext = get_file_extension(target_type)
                content_type = get_content_type(target_type)
            
            response = FileResponse(converted_file, as_attachment=True, filename=f'converted.{ext}')
            response['Content-Type'] = content_type
            return response
        except Exception as e:
            logger.error(f"PPTX conversion error: {str(e)}")
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request'}, status=400)

@csrf_exempt
def convert_txt(request):
    if request.method == 'POST' and 'file' in request.FILES:
        try:
            uploaded_file = request.FILES['file']
            target_type = request.POST.get('target_type')
            
            if not target_type:
                return JsonResponse({'error': 'target_type is required'}, status=400)
            
            converted_file = txt_converter.convert(uploaded_file, target_type)
            ext = get_file_extension(target_type)
            content_type = get_content_type(target_type)
            
            response = FileResponse(converted_file, as_attachment=True, filename=f'converted.{ext}')
            response['Content-Type'] = content_type
            return response
        except Exception as e:
            logger.error(f"TXT conversion error: {str(e)}")
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request'}, status=400)

@csrf_exempt
def convert_csv(request):
    if request.method == 'POST' and 'file' in request.FILES:
        try:
            uploaded_file = request.FILES['file']
            target_type = request.POST.get('target_type')
            
            if not target_type:
                return JsonResponse({'error': 'target_type is required'}, status=400)
            
            converted_file = csv_converter.convert(uploaded_file, target_type)
            ext = get_file_extension(target_type)
            content_type = get_content_type(target_type)
            
            response = FileResponse(converted_file, as_attachment=True, filename=f'converted.{ext}')
            response['Content-Type'] = content_type
            return response
        except Exception as e:
            logger.error(f"CSV conversion error: {str(e)}")
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request'}, status=400)

@csrf_exempt
def convert_json(request):
    if request.method == 'POST' and 'file' in request.FILES:
        try:
            uploaded_file = request.FILES['file']
            target_type = request.POST.get('target_type')
            
            if not target_type:
                return JsonResponse({'error': 'target_type is required'}, status=400)
            
            converted_file = json_converter.convert(uploaded_file, target_type)
            ext = get_file_extension(target_type)
            content_type = get_content_type(target_type)
            
            response = FileResponse(converted_file, as_attachment=True, filename=f'converted.{ext}')
            response['Content-Type'] = content_type
            return response
        except Exception as e:
            logger.error(f"JSON conversion error: {str(e)}")
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request'}, status=400)

