class FileConversion {
  final String targetType;
  final String fileName;
  final List<int> fileBytes; // file content

  FileConversion({
    required this.targetType,
    required this.fileName,
    required this.fileBytes,
  });
}
