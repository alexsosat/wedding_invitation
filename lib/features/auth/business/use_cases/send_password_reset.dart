import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../data/models/params/password_reset_params.dart";
import "../repositories/auth_repository.dart";

/// Use case for sending a password reset email.
class SendPasswordReset extends UseCaseAsync<Unit, PasswordResetParams> {
  /// Creates a [SendPasswordReset] use case instance.
  SendPasswordReset({required this.authRepository});

  /// The auth repository.
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, Unit>> call({
    required PasswordResetParams params,
  }) =>
      authRepository.sendPasswordResetEmail(email: params.email);
}
