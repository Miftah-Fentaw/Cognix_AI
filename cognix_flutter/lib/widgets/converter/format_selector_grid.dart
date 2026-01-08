import 'package:flutter/material.dart';

class FormatSelectorGrid extends StatelessWidget {
  final List<String> formats;
  final String? selectedFormat;
  final Function(String) onFormatSelected;

  const FormatSelectorGrid({
    super.key,
    required this.formats,
    required this.selectedFormat,
    required this.onFormatSelected,
  });

  IconData _getIconForFormat(String format) {
    switch (format.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'DOCX':
      case 'DOC':
        return Icons.description;
      case 'PPTX':
        return Icons.slideshow;
      case 'TXT':
        return Icons.text_snippet;
      case 'PNG':
      case 'JPG':
      case 'JPEG':
      case 'WEBP':
      case 'BMP':
      case 'TIFF':
      case 'GIF':
        return Icons.image;
      case 'CSV':
      case 'XLS':
      case 'XLSX':
        return Icons.table_chart;
      case 'JSON':
        return Icons.code;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getColorForFormat(String format) {
    switch (format.toUpperCase()) {
      case 'PDF':
        return const Color(0xFFFF3B30);
      case 'DOCX':
      case 'DOC':
        return const Color(0xFF007AFF);
      case 'PPTX':
        return const Color(0xFFFF9500);
      case 'TXT':
        return const Color(0xFF8E8E93);
      case 'PNG':
      case 'JPG':
      case 'JPEG':
      case 'WEBP':
      case 'BMP':
      case 'TIFF':
      case 'GIF':
        return const Color(0xFF34C759);
      case 'CSV':
      case 'XLS':
      case 'XLSX':
        return const Color(0xFF5856D6);
      case 'JSON':
        return const Color(0xFFAF52DE);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (formats.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Select a file to see available formats',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8E8E93),
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: formats.length,
      itemBuilder: (context, index) {
        final format = formats[index];
        final isSelected = format == selectedFormat;
        final color = _getColorForFormat(format);

        return GestureDetector(
          onTap: () => onFormatSelected(format),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : const Color(0xFFE5E5EA),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIconForFormat(format),
                  size: 32,
                  color: isSelected ? color : const Color(0xFF8E8E93),
                ),
                const SizedBox(height: 8),
                Text(
                  format,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? color : const Color(0xFF1C1C1E),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
