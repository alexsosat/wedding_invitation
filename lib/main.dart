import "package:device_preview_minus/device_preview_minus.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:http/http.dart" as http;

import "boda_ma_app.dart";
import "core/config/dependency_injection.dart";
import "core/config/environment_config.dart";

void main() async {
  EnvironmentConfig.init(
    flavor: Flavor.production,
  );

  await DependencyInjection.injectCriticalServices();
  await loadAdobeFont();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const BodaMaApp(),
    ),
  );
}

/// Helper function to dynamically load Adobe web font for CanvasKit rendering
Future<void> loadAdobeFont() async {
  try {
    // Direct font binary URL extracted from your Typekit CSS @font-face block
    final Uri fontUri = Uri.parse(
      "https://use.typekit.net/af/5f2949/00000000000000007735ec1a/31/l?primer=7cdcb44be4a7db8877ffa5c0007b8dd865b3bbc383831fe2ea177f62257a9191&fvd=n4&v=3",
    );

    final response = await http.get(fontUri);

    if (response.statusCode == 200) {
      final Uint8List fontBytes = response.bodyBytes;
      final ByteData byteData = ByteData.sublistView(fontBytes);

      final FontLoader fontLoader = FontLoader("altesse-std-24pt")
        ..addFont(Future.value(byteData));
      await fontLoader.load();
      debugPrint("Font successfully injected into CanvasKit");
    } else {
      debugPrint("HTTP error loading font: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("Failed to load external web font: $e");
  }
}
