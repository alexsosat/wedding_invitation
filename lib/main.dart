import "package:flutter/material.dart";

import "boda_ma_app.dart";
import "core/config/dependency_injection.dart";
import "core/config/environment_config.dart";

void main() async {
  EnvironmentConfig.init(
    flavor: Flavor.production,
  );

  await DependencyInjection.init();

  runApp(const BodaMaApp());
}
