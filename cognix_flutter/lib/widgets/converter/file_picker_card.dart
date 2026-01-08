import 'package:flutter/material.dart';

class FilePickerCard extends StatelessWidget {
  final VoidCallback onTap;
  final String? fileName;
  final String? fileExtension;
  final String? fileSize;
  final bool hasFile;

  const FilePickerCard({
    super.key,
    required this.onTap,
    this.fileName,
    this.fileExtension,
    this.fileSize,
    this.hasFile = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFile ? const Color(0xFF007AFF) : const Color(0xFFE5E5EA),
            width: 2,
          ),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hasFile
                    ? const Color(0xFF007AFF).withOpacity(0.1)
                    : const Color(0xFFF5F5F7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFile ? Icons.insert_drive_file : Icons.upload_file,
                size: 48,
                color:
                    hasFile ? const Color(0xFF007AFF) : const Color(0xFF8E8E93),
              ),
            ),
            const SizedBox(height: 16),
            if (hasFile && fileName != null) ...[
              Text(
                fileName!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (fileExtension != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        fileExtension!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF007AFF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (fileSize != null)
                    Text(
                      fileSize!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                ],
              ),
            ] else ...[
              const Text(
                'Select a file',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap to choose from your device',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8E8E93),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
