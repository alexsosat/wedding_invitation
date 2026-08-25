import "package:equatable/equatable.dart";

/// Entity that represents an authenticated user in the administration module.
class AuthUserEntity extends Equatable {
  /// Creates an [AuthUserEntity] instance.
  const AuthUserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isEmailVerified = false,
  });

  /// Unique user ID from Firebase Authentication.
  final String id;

  /// Email address of the user.
  final String email;

  /// Optional display name.
  final String? displayName;

  /// Optional photo URL.
  final String? photoUrl;

  /// Whether the user has verified their email address.
  final bool isEmailVerified;

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        isEmailVerified,
      ];

  @override
  bool get stringify => true;
}
