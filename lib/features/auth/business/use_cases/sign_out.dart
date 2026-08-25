import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../repositories/auth_repository.dart";

/// Use case for signing out the current user.
class SignOut extends UseCaseAsync<Unit, NoParams> {
  /// Creates a [SignOut] use case instance.
  SignOut({required this.authRepository});

  /// The auth repository.
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, Unit>> call({
    required NoParams params,
  }) =>
      authRepository.signOut();
}
