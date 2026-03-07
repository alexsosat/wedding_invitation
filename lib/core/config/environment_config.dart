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
        "c58dc08bd42dfb2cf64a1561fdd3b445be0d1f5d14b79658c970d419fc7f702c5a4d6877426b3e0898ebbea77b20a5af913727433ea5c33dd27a8a98ad94a7f421b9d9d2fa2786481f04a662f052618ec5fc7e942d210b03a4286946ece87d5aec3cce8b319375ba4e17986d439bbb4f65206c92b476e118e21ce4745a28dcf3"
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
