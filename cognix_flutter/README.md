**Cognix — Flutter client**

Overview

Lightweight Flutter client providing a clean chat-style interface for the
Cognix AI study assistant. The app handles user interaction, file downloads,
and presentation; AI processing is performed by the backend.

Highlights
- Minimal, focused UI optimized for mobile devices.
- Sends user input and files to the backend API and displays AI responses.
- Supports opening and sharing generated documents (PDF, DOCX, etc.).

Prerequisites
- Flutter SDK (see flutter.dev). Recommended stable channel with SDK >= 3.6.

Quick setup
1. Ensure the backend is running and reachable from your device (use IP,
	 not localhost for real devices).
2. From `cognix_flutter/` run:

```bash
flutter pub get
flutter run
```

Configuration
- Set the backend base URL in the app configuration (search for `baseUrl` or
	`api` constants in `lib/`), or pass it via flavors/environment variables.

Project layout (high level)
- `lib/` — main app code: screens, widgets, controllers, models.
- `assets/` — images and launcher icons.
- `pubspec.yaml` — dependencies and app metadata.

## Screenshots

| | | | |
|:---:|:---:|:---:|:---:|
| ![Screenshot](assets/screenshots/image1.png) | ![Screenshot](assets/screenshots/image2.png) | ![Screenshot](assets/screenshots/image3.png) | ![Screenshot](assets/screenshots/image4.png) |
| ![Screenshot](assets/screenshots/image5.png) | ![Screenshot](assets/screenshots/image6.png) | ![Screenshot](assets/screenshots/image7.png) | ![Screenshot](assets/screenshots/image8.png) |
| ![Screenshot](assets/screenshots/image9.png) | ![Screenshot](assets/screenshots/image10.png) | ![Screenshot](assets/screenshots/image11.png) | ![Screenshot](assets/screenshots/image12.png) |
| ![Screenshot](assets/screenshots/image13.png) | ![Screenshot](assets/screenshots/image14.png) | ![Screenshot](assets/screenshots/image15.png) | ![Screenshot](assets/screenshots/image16.png) |

Notes
- Test on a physical device or emulator with network access to the backend.
- Keep UI changes focused and maintain separation: client = UI, backend = AI.

License
See the project `LICENSE` (root) or `cognix_flutter/LICENSE` for terms.