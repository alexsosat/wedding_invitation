import "package:flutter_common_classes/flutter_common_classes.dart";

/// Parameters for sending a password reset email.
class PasswordResetParams extends Params {
  /// Creates a [PasswordResetParams] instance.
  PasswordResetParams({
    required this.email,
  });

  /// The target email address for password reset.
  final String email;
}
