import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/converter_provider.dart';
import '../../../services/file_action_service.dart';
import '../../../utils/notification_helper.dart';
import '../../../widgets/converter/converted_file_widgets.dart';

class ConvertedOutputScreen extends StatelessWidget {
  const ConvertedOutputScreen({super.key});

  Future<void> _saveFile(BuildContext context) async {
    final provider = context.read<ConverterProvider>();
    final convertedFile = provider.convertedFile;

    if (convertedFile == null) return;

    final response = await FileActionService.saveConvertedFile(
      fileBytes: convertedFile.fileBytes,
      fileName: convertedFile.fileName,
    );

    if (context.mounted) {
      if (response['success']) {
        NotificationHelper.showSuccess(context, response['message']);
      } else {
        NotificationHelper.showError(context, response['message']);
      }
    }
  }

  Future<void> _viewFile(BuildContext context) async {
    final provider = context.read<ConverterProvider>();
    final convertedFile = provider.convertedFile;

    if (convertedFile == null) return;

    final response = await FileActionService.viewConvertedFile(
      fileBytes: convertedFile.fileBytes,
      fileName: convertedFile.fileName,
    );

    if (context.mounted && !response['success']) {
      NotificationHelper.showError(context, response['message']);
    }
  }

  Future<void> _shareFile(BuildContext context) async {
    final provider = context.read<ConverterProvider>();
    final convertedFile = provider.convertedFile;

    if (convertedFile == null) return;

    final response = await FileActionService.shareConvertedFile(
      fileBytes: convertedFile.fileBytes,
      fileName: convertedFile.fileName,
    );

    if (context.mounted && !response['success']) {
      NotificationHelper.showError(context, response['message']);
    }
  }

  void _convertAnother(BuildContext context) {
    context.read<ConverterProvider>().clearSelection();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Converted File',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _convertAnother(context),
        ),
      ),
      body: SafeArea(
        child: Consumer<ConverterProvider>(
          builder: (context, provider, _) {
            final convertedFile = provider.convertedFile;

            if (convertedFile == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Color(0xFF8E8E93),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No converted file available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Success Animation
                  const SuccessAnimationCard(),

                  const SizedBox(height: 24),

                  // File Info Card
                  FileInfoCard(
                    fileName: convertedFile.fileName,
                    targetType: convertedFile.targetType,
                    fileBytes: convertedFile.fileBytes,
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  FileActionButtons(
                    onView: () => _viewFile(context),
                    onSave: () => _saveFile(context),
                    onShare: () => _shareFile(context),
                    onConvertAnother: () => _convertAnother(context),
                  ),

                  const SizedBox(height: 24),

                  // Info Card
                  const FileLocationInfo(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
