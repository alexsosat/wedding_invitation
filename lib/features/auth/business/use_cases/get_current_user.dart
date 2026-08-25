import "package:flutter_common_classes/flutter_common_classes.dart";

import "../entities/auth_user_entity.dart";
import "../repositories/auth_repository.dart";

/// Use case to retrieve the currently signed-in user.
class GetCurrentUser extends UseCaseAsync<AuthUserEntity?, NoParams> {
  /// Creates a [GetCurrentUser] use case instance.
  GetCurrentUser({required this.authRepository});

  /// The auth repository dependency.
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, AuthUserEntity?>> call({
    required NoParams params,
  }) =>
      authRepository.getCurrentUser();
}
