import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;



enum AppPlatform { mobile, web}

class PlatformChecker {
  static AppPlatform detectPlatform() {
    if (kIsWeb) return AppPlatform.web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return AppPlatform.mobile;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return AppPlatform.web;
      default:
        return AppPlatform.mobile;
    }
  }
}