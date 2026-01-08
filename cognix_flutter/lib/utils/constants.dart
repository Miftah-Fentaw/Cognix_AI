class AppConstants {
  // Network Configuration
  static const String baseIpAddress = '192.168.0.132';
  static const String basePort = '8000';
  static const String baseUrl = 'http://$baseIpAddress:$basePort';


  // API Endpoints

  static const String resumeGenerateEndpoint = '/api/generate-resume/';
  static const String resumeUploadPhotoEndpoint = '/api/upload-photo/';
  static const String chatProcessTextEndpoint = '/api/process-text/';
  static const String chatProcessFileEndpoint = '/api/process-file/';
  static const String generatePdfEndpoint = '/api/generate-pdf/';



// Translation Endpoints
static const String translateEndpoint = '$baseUrl/dictionary/translate/';





  // Converter Endpoints
  static const String converterBaseEndpoint = '/converter';
  static const String convertImageEndpoint =
      '$converterBaseEndpoint/convert-image/';
  static const String convertPdfEndpoint =
      '$converterBaseEndpoint/convert-pdf/';
  static const String convertDocEndpoint =
      '$converterBaseEndpoint/convert-doc/';
  static const String convertPptxEndpoint =
      '$converterBaseEndpoint/convert-pptx/';
  static const String convertTxtEndpoint =
      '$converterBaseEndpoint/convert-txt/';
  static const String convertCsvEndpoint =
      '$converterBaseEndpoint/convert-csv/';
  static const String convertJsonEndpoint =
      '$converterBaseEndpoint/convert-json/';

  // Full API URLs
  static const String resumeGenerateUrl = '$baseUrl$resumeGenerateEndpoint';
  static const String resumeUploadPhotoUrl =
      '$baseUrl$resumeUploadPhotoEndpoint';
  static const String chatProcessTextUrl = '$baseUrl$chatProcessTextEndpoint';
  static const String chatProcessFileUrl = '$baseUrl$chatProcessFileEndpoint';
  static const String generatePdfUrl = '$baseUrl$generatePdfEndpoint';
  // Converter URLs
  static const String converterBaseUrl = '$baseUrl$converterBaseEndpoint';
  static const String convertImageUrl = '$baseUrl$convertImageEndpoint';
  static const String convertPdfUrl = '$baseUrl$convertPdfEndpoint';
  static const String convertDocUrl = '$baseUrl$convertDocEndpoint';
  static const String convertPptxUrl = '$baseUrl$convertPptxEndpoint';
  static const String convertTxtUrl = '$baseUrl$convertTxtEndpoint';
  static const String convertCsvUrl = '$baseUrl$convertCsvEndpoint';
  static const String convertJsonUrl = '$baseUrl$convertJsonEndpoint';

  // App Configuration
  static const String appName = 'Cognix AI';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String resumeHistoryKey = 'resume_history';
  static const String resumeDraftKey = 'resume_draft';
  static const String onboardingSeenKey = 'has_seen_onboarding';

  // File Configuration
  static const String resumesFolderName = 'resumes';
  static const int maxResumeHistoryCount = 50;

  // Network Timeouts (in seconds)
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 60;

  // UI Configuration
  static const double defaultBorderRadius = 16.0;
  static const double cardBorderRadius = 20.0;
  static const double sectionBorderRadius = 24.0;
}

// Quick access methods for easy IP changes
class NetworkConfig {
  /// Change this IP address when your backend server IP changes
  /// Common scenarios:
  /// - Local development: '127.0.0.1' or 'localhost'
  /// - USB debugging with mobile: Your computer's local IP
  /// - WiFi network: Your computer's WiFi IP
  /// - Production: Your server's public IP or domain
  static String get currentBaseUrl => AppConstants.baseUrl;

  /// Quick method to update IP for development
  /// Usage: NetworkConfig.updateIpAddress('192.168.1.100');
  static String updateIpAddress(String newIp, {String port = '8000'}) {
    return 'http://$newIp:$port';
  }

  /// Common IP configurations for quick switching
  static const String localhost = 'http://127.0.0.1:8000';
  static const String localNetwork = 'http://192.168.1.100:8000'; // Example
  static const String currentMobile = 'http://10.230.37.240:8000'; // Current IP
}
