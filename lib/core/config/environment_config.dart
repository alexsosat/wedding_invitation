import "package:flutter/material.dart";
import "package:flutter_flavor/flutter_flavor.dart";

/// A class that provides the environment configuration for the application.
///
/// This class is used to set the environment variables for the application.
class EnvironmentConfig {
  /// Key to access a resource of the environment.
  ///
  /// example: The key to access the api url.
  static const String apiUrlKey = "API_URL";

  /// Initializes the environment configuration.
  static void init({
    required Flavor flavor,
  }) {
    FlavorConfig(
      name: flavor.name,
      color: Colors.red,
      location: BannerLocation.topStart,
      variables: _getVariables(flavor),
    );
  }

  static Map<String, dynamic> _getVariables(Flavor flavor) => switch (flavor) {
        Flavor.local => _localVariables,
        Flavor.test => _testVariables,
        Flavor.production => _prodVariables,
      };

  static const Map<String, dynamic> _localVariables = {
    apiUrlKey: "",
  };

  static const Map<String, dynamic> _testVariables = {
    apiUrlKey: "",
  };

  static const Map<String, dynamic> _prodVariables = {
    apiUrlKey: "",
  };
}

/// The different environments for the application.
enum Flavor {
  /// The local environment.
  local,

  /// The test environment.
  test,

  /// The production environment.
  production,
}
