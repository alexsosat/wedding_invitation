import "package:flutter_common_classes/flutter_common_classes.dart";

/// Parameters for signing in with email and password.
class SignInParams extends Params {
  /// Creates a [SignInParams] instance.
  SignInParams({
    required this.email,
    required this.password,
  });

  /// The email address.
  final String email;

  /// The password.
  final String password;
}
