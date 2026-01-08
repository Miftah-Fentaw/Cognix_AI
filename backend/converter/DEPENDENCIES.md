# Converter App Dependencies

## Python Packages (install via pip)
```bash
pip install Pillow img2pdf PyPDF2 pdfplumber pdf2image python-docx python-pptx pandas reportlab openpyxl
```

## System Dependencies

### LibreOffice (Required for DOCX→PDF and PPTX→Images conversions)
```bash
# Ubuntu/Debian
sudo apt-get install libreoffice

# macOS
brew install libreoffice

# Windows
# Download and install from https://www.libreoffice.org/download/download/
```

### Poppler (Required for PDF→Images conversion)
```bash
# Ubuntu/Debian
sudo apt-get install poppler-utils

# macOS
brew install poppler

# Windows
# Download from http://blog.alivate.com.au/poppler-windows/
```

## Package Details

- **Pillow**: Image processing library
- **img2pdf**: Convert images to PDF
- **PyPDF2**: PDF manipulation
- **pdfplumber**: Extract text from PDFs
- **pdf2image**: Convert PDF pages to images (requires poppler)
- **python-docx**: Create and modify DOCX files
- **python-pptx**: Create and modify PPTX files
- **pandas**: Data manipulation for CSV/Excel/JSON
- **reportlab**: PDF generation
- **openpyxl**: Excel file handling

## Supported Conversions

### Images (PNG, JPG, JPEG, WEBP, BMP, TIFF, GIF)
- → GIF, PDF, DOCX, PNG, JPG, JPEG, WEBP, BMP, TIFF

### PDF
- → DOCX, TXT, Images (PNG, JPG, WEBP), PPTX

### DOC/DOCX
- → PDF, TXT, PPTX

### PPTX
- → PDF, Images (PNG, JPG), DOCX, TXT

### TXT
- → DOCX, PDF, PPTX

### CSV/XLS/XLSX
- → TXT, PDF, DOCX, JSON, CSV, XLS, XLSX

### JSON
- → TXT, CSV, XLS, XLSX, PDF, DOCX
