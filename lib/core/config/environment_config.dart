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

  /// Key to access the api key.
  static const String apiKeyKey = "API_KEY";

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
    apiUrlKey: "localhost:1337/api",
    apiKeyKey:
        "f5a83a9806d1e1132dd5369cd6078d6ccba67849ab46fb07b0b105d69f11167056d2f06c15fe113083124ba97d0f136186f960497cafd72c47db3178804f4b559740c141c1b3940fc22f0f594caee0531ed32b00a6be1d9034f4f931abf9558e77c29cd4106aed98006625c58879cf7f5f145a5e9adc6e2cd9e50785045853d0",
  };

  static const Map<String, dynamic> _testVariables = {
    apiUrlKey: "",
    apiKeyKey: "",
  };

  static const Map<String, dynamic> _prodVariables = {
    apiUrlKey: "https://leading-frog-d85e022261.strapiapp.com/api",
    apiKeyKey:
        "b47cbb982c98d33c3ff18016933169709fbeacedb9706a4c0fd1f99a4843fdf57deab4b769a440b3f3feaf2803db78a8169d9e636aaef51c83fa88d687fe1e68acda5f29b36ac4775f9e7c05dcb2c6a4c303e3b7f4840afa2a7f6820c4bb19ee1c76ea98d6274c509ed43c43a3b033626a624cab897100c1dc8e8bc548ad031c",
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
