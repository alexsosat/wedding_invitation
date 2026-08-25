import "package:firebase_auth/firebase_auth.dart";

import "../../../business/entities/auth_user_entity.dart";

/// Data transfer object for [AuthUserEntity].
class AuthUserModel extends AuthUserEntity {
  /// Creates an [AuthUserModel] instance.
  const AuthUserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.isEmailVerified = false,
  });

  /// Factory creating an [AuthUserModel] from a Firebase [User].
  factory AuthUserModel.fromFirebaseUser(User user) => AuthUserModel(
        id: user.uid,
        email: user.email ?? "",
        displayName: user.displayName,
        photoUrl: user.photoURL,
        isEmailVerified: user.emailVerified,
      );

  /// Factory creating an [AuthUserModel] from a Map.
  factory AuthUserModel.fromMap(Map<String, dynamic> map) => AuthUserModel(
        id: map["id"] as String? ?? "",
        email: map["email"] as String? ?? "",
        displayName: map["displayName"] as String?,
        photoUrl: map["photoUrl"] as String?,
        isEmailVerified: map["isEmailVerified"] as bool? ?? false,
      );

  /// Factory creating an [AuthUserModel] from an [AuthUserEntity].
  factory AuthUserModel.fromEntity(AuthUserEntity entity) => AuthUserModel(
        id: entity.id,
        email: entity.email,
        displayName: entity.displayName,
        photoUrl: entity.photoUrl,
        isEmailVerified: entity.isEmailVerified,
      );

  /// Converts this model into a map.
  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "displayName": displayName,
        "photoUrl": photoUrl,
        "isEmailVerified": isEmailVerified,
      };

  /// Converts this model into an [AuthUserEntity].
  AuthUserEntity toEntity() => AuthUserEntity(
        id: id,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        isEmailVerified: isEmailVerified,
      );
}
