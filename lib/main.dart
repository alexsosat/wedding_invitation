import "package:device_preview_minus/device_preview_minus.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "boda_ma_app.dart";
import "core/config/dependency_injection.dart";
import "core/config/environment_config.dart";

void main() async {
  EnvironmentConfig.init(
    flavor: Flavor.production,
  );

  await DependencyInjection.injectCriticalServices();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const BodaMaApp(),
    ),
  );
}
