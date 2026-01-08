import io
from PIL import Image
import img2pdf
from docx import Document
from docx.shared import Inches

def convert(file, target_type):
    """
    Convert image files to various formats.
    Supports: PNG, JPG, JPEG, WEBP, BMP, TIFF, GIF → GIF, PDF, DOCX
    """
    try:
        img = Image.open(file)
        output = io.BytesIO()

        if target_type.upper() == 'PDF':
            # Convert image to PDF
            file_bytes = io.BytesIO()
            # Convert RGBA to RGB for PDF compatibility
            if img.mode in ('RGBA', 'LA', 'P'):
                img = img.convert('RGB')
            img.save(file_bytes, format='JPEG')
            file_bytes.seek(0)
            pdf_bytes = img2pdf.convert(file_bytes)
            output.write(pdf_bytes)

        elif target_type.upper() in ['JPEG', 'JPG']:
            # Convert to JPEG
            if img.mode in ('RGBA', 'LA', 'P'):
                img = img.convert('RGB')
            img.save(output, format='JPEG', quality=95)

        elif target_type.upper() == 'PNG':
            # Convert to PNG
            img.save(output, format='PNG')

        elif target_type.upper() == 'WEBP':
            # Convert to WEBP
            img.save(output, format='WEBP', quality=95)

        elif target_type.upper() == 'BMP':
            # Convert to BMP
            if img.mode in ('RGBA', 'LA'):
                img = img.convert('RGB')
            img.save(output, format='BMP')

        elif target_type.upper() == 'TIFF':
            # Convert to TIFF
            img.save(output, format='TIFF')

        elif target_type.upper() == 'GIF':
            # Convert to GIF
            if img.mode not in ('P', 'L', 'RGB'):
                img = img.convert('RGB')
            img.save(output, format='GIF')

        elif target_type.upper() in ['DOC', 'DOCX']:
            # Convert image to DOCX by embedding it
            doc = Document()
            
            # Save image to temporary BytesIO
            img_bytes = io.BytesIO()
            if img.mode in ('RGBA', 'LA', 'P'):
                img = img.convert('RGB')
            img.save(img_bytes, format='PNG')
            img_bytes.seek(0)
            
            # Add image to document with appropriate sizing
            width, height = img.size
            aspect_ratio = height / width
            doc_width = Inches(6)  # Max width for document
            doc_height = doc_width * aspect_ratio
            
            # Limit height to reasonable size
            if doc_height > Inches(8):
                doc_height = Inches(8)
                doc_width = doc_height / aspect_ratio
            
            doc.add_picture(img_bytes, width=doc_width, height=doc_height)
            doc.save(output)
        
        else:
            raise ValueError(f"Unsupported target format: {target_type}")

        output.seek(0)
        return output
    
    except Exception as e:
        raise Exception(f"Image conversion error: {str(e)}")
