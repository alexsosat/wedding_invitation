import "package:equatable/equatable.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";

import "../../business/entities/auth_user_entity.dart";

/// Base state for authentication operations.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial authentication state.
class AuthInitial extends AuthState {
  /// Creates an [AuthInitial] state.
  const AuthInitial();
}

/// State when an authentication operation is in progress.
class AuthLoading extends AuthState {
  /// Creates an [AuthLoading] state.
  const AuthLoading();
}

/// State when a user is authenticated.
class Authenticated extends AuthState {
  /// Creates an [Authenticated] state.
  const Authenticated({required this.user});

  /// The authenticated user.
  final AuthUserEntity user;

  @override
  List<Object?> get props => [user];
}

/// State when no user is authenticated.
class Unauthenticated extends AuthState {
  /// Creates an [Unauthenticated] state.
  const Unauthenticated();
}

/// State when an authentication operation encounters an error.
class AuthError extends AuthState {
  /// Creates an [AuthError] state.
  const AuthError({required this.failure});

  /// The failure describing the error.
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
