import "package:flutter/material.dart";
import "package:flutter_common_classes/services/connection/network_info.dart";
import "package:flutter_flavor/flutter_flavor.dart";
import "package:get/get.dart";
import "package:get/get_core/get_core.dart";

import "../adapters/dio_adapter.dart";
import "environment_config.dart";

/// Class to inject the dependencies in the application
class DependencyInjection {
  /// Inject the services in the application
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    Get.put(
      DioAdapter(
        internetInfo: NetworkInfoImpl(
          InternetConnection(),
        ),
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1),
        baseUrl: FlavorConfig.instance.variables[EnvironmentConfig.apiUrlKey],
      ),
      permanent: true,
    );
  }
}
