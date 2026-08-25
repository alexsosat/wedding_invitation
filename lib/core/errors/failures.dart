import "package:flutter_common_classes/errors/failure.dart";

/// Failure representing server or Firestore database errors
class ServerFailure extends Failure {
  /// Creates a [ServerFailure]
  ServerFailure({
    required super.message,
    super.title = "Server Error",
  });
}

/// Failure representing when a requested entity or document is not found
class NotFoundFailure extends Failure {
  /// Creates a [NotFoundFailure]
  NotFoundFailure({
    required super.message,
    super.title = "Not Found",
  });
}

/// Failure representing authentication errors
class AuthFailure extends Failure {
  /// Creates an [AuthFailure]
  AuthFailure({
    required super.message,
    super.title = "Authentication Error",
  });
}
