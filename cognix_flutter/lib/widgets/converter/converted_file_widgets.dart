import 'package:flutter/material.dart';
import '../../utils/file_format_helper.dart';

/// Success animation card widget
class SuccessAnimationCard extends StatelessWidget {
  const SuccessAnimationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF34C759).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 64,
              color: Color(0xFF34C759),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Conversion Successful!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your file has been converted successfully',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8E8E93),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// File info card widget
class FileInfoCard extends StatelessWidget {
  final String fileName;
  final String targetType;
  final List<int> fileBytes;

  const FileInfoCard({
    super.key,
    required this.fileName,
    required this.targetType,
    required this.fileBytes,
  });

  @override
  Widget build(BuildContext context) {
    final color = FileFormatHelper.getColorForFormat(targetType);
    final icon = FileFormatHelper.getIconForFormat(targetType);
    final fileSize = FileFormatHelper.getFileSize(fileBytes);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1E),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        targetType,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      fileSize,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// File action buttons widget
class FileActionButtons extends StatelessWidget {
  final VoidCallback onView;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onConvertAnother;

  const FileActionButtons({
    super.key,
    required this.onView,
    required this.onSave,
    required this.onShare,
    required this.onConvertAnother,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: onView,
          icon: const Icon(Icons.visibility),
          label: const Text('View File'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007AFF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.download),
          label: const Text('Save to Cognix Folder'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF34C759),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onShare,
          icon: const Icon(Icons.share),
          label: const Text('Share File'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF007AFF),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(
              color: Color(0xFF007AFF),
              width: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: onConvertAnother,
          icon: const Icon(Icons.refresh),
          label: const Text('Convert Another File'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF8E8E93),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

/// File location info widget
class FileLocationInfo extends StatelessWidget {
  const FileLocationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF007AFF).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder,
            size: 20,
            color: const Color(0xFF007AFF).withOpacity(0.8),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Files are saved in Downloads/Cognix folder',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8E8E93),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
