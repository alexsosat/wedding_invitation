import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../data/models/params/sign_in_params.dart";
import "../entities/auth_user_entity.dart";
import "../repositories/auth_repository.dart";

/// Use case for signing in with email and password.
class SignInWithEmail extends UseCaseAsync<AuthUserEntity, SignInParams> {
  /// Creates a [SignInWithEmail] usecase instance.
  SignInWithEmail({required this.authRepository});

  /// The auth repository.
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, AuthUserEntity>> call({
    required SignInParams params,
  }) =>
      authRepository.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
}
