import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

import "../../../../core/errors/failures.dart";
import "../../business/entities/auth_user_entity.dart";
import "../../business/repositories/auth_repository.dart";
import "../data_sources/remote/auth_remote_data_source.dart";
import "../models/dtos/auth_user_model.dart";

/// Concrete implementation of [AuthRepository] using [AuthRemoteDataSource]
class AuthRepositoryImpl implements AuthRepository {
  /// Creates an [AuthRepositoryImpl] instance
  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  /// Remote data source instance for authentication operations
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser() async {
    try {
      final user = remoteDataSource.currentUser;
      if (user == null) {
        return const Right(null);
      }
      return Right(AuthUserModel.fromFirebaseUser(user).toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? "Failed to get current user",
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  @override
  Stream<AuthUserEntity?> get authStateChanges =>
      remoteDataSource.authStateChanges.map(
        (user) => user != null
            ? AuthUserModel.fromFirebaseUser(user).toEntity()
            : null,
      );

  @override
  Future<Either<Failure, AuthUserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        return Left(
          AuthFailure(
            message: "User not found after sign in",
          ),
        );
      }

      return Right(AuthUserModel.fromFirebaseUser(user).toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(
          message: _mapFirebaseAuthErrorCode(e.code, e.message),
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? "Failed to sign out",
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(
          message: _mapFirebaseAuthErrorCode(e.code, e.message),
        ),
      );
    } catch (e) {
      return Left(
        AppFailure.unexpected(
          e.toString(),
        ),
      );
    }
  }

  String _mapFirebaseAuthErrorCode(String code, String? defaultMessage) {
    switch (code) {
      case "user-not-found":
        return "No user found with this email.";
      case "wrong-password":
        return "Incorrect password.";
      case "invalid-email":
        return "The email address is invalid.";
      case "user-disabled":
        return "This user account has been disabled.";
      case "too-many-requests":
        return "Too many attempts. Please try again later.";
      case "invalid-credential":
        return "Invalid email or password.";
      default:
        return defaultMessage ?? "Authentication error occurred.";
    }
  }
}
