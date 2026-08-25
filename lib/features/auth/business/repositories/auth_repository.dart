import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../entities/auth_user_entity.dart";

/// Data operations contract for the Auth module
abstract class AuthRepository {
  /// Retrieves the current authenticated user if one exists.
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser();

  /// Stream of authentication state changes.
  Stream<AuthUserEntity?> get authStateChanges;

  /// Signs in a user using email and password.
  Future<Either<Failure, AuthUserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs out the currently authenticated user.
  Future<Either<Failure, Unit>> signOut();

  /// Sends a password reset email to the specified address.
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  });
}
