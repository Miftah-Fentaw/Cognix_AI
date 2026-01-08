import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/converter_provider.dart';
import '../../../widgets/converter/file_picker_card.dart';
import '../../../widgets/converter/format_selector_grid.dart';
import '../../../widgets/converter/conversion_progress_card.dart';
import '../../../utils/notification_helper.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  Future<void> _pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        if (context.mounted) {
          context.read<ConverterProvider>().selectFile(file);
        }
      }
    } catch (e) {
      if (context.mounted) {
        NotificationHelper.showError(
          context,
          'Error picking file: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _convertFile(BuildContext context) async {
    final provider = context.read<ConverterProvider>();

    final success = await provider.convertFile();

    if (context.mounted) {
      if (success) {
        // Navigate to output screen
        context.push('/converter/output');
      } else {
        // Show error
        NotificationHelper.showError(
          context,
          provider.errorMessage ?? 'Conversion failed',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () => context.pushReplacement('/'),
        ),
        centerTitle: true,
        title: const Text(
          'File Converter',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<ConverterProvider>(
            builder: (context, provider, _) {
              if (provider.hasSelectedFile) {
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    provider.clearSelection();
                  },
                  tooltip: 'Clear selection',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ConverterProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // File Picker Section
                  const Text(
                    'Select File',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilePickerCard(
                    onTap: () => _pickFile(context),
                    fileName: provider.getFileName(),
                    fileExtension: provider.getFileExtension(),
                    fileSize: provider.getFileSize(),
                    hasFile: provider.hasSelectedFile,
                  ),

                  // Error Message
                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF3B30).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFFF3B30),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              provider.errorMessage!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFF3B30),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Color(0xFFFF3B30),
                            ),
                            onPressed: provider.clearError,
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Format Selector Section
                  const Text(
                    'Convert To',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FormatSelectorGrid(
                    formats: provider.availableFormats,
                    selectedFormat: provider.selectedTargetType,
                    onFormatSelected: provider.selectTargetType,
                  ),

                  const SizedBox(height: 32),

                  // Progress Card
                  ConversionProgressCard(
                    progress: provider.conversionProgress,
                    isConverting: provider.isConverting,
                  ),

                  if (provider.isConverting || provider.conversionProgress > 0)
                    const SizedBox(height: 32),

                  // Convert Button
                  ElevatedButton(
                    onPressed: provider.canConvert && !provider.isConverting
                        ? () => _convertFile(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: const Color(0xFFE5E5EA),
                      disabledForegroundColor: const Color(0xFF8E8E93),
                    ),
                    child: provider.isConverting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Convert File',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Supported Formats Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: const Color(0xFF007AFF).withOpacity(0.8),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Supported Formats',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF007AFF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Images (PNG, JPG, WEBP, GIF, BMP, TIFF), Documents (PDF, DOC, DOCX, TXT, PPTX), Data (CSV, XLS, XLSX, JSON)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8E8E93),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
