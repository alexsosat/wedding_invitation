// ignore_for_file: prefer-match-file-name, sort_constructors_first

import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Failure for Postgrest exceptions
class PostgressFailure extends Failure {
  /// Failure for Postgrest exceptions
  PostgressFailure({
    required super.message,
    required super.title,
    this.code,
    this.details,
    this.hint,
  });

  /// Create a [PostgressFailure] from a [PostgrestException]
  factory PostgressFailure.fromException(PostgrestException exception) =>
      PostgressFailure(
        title: "Error en la base de datos",
        message: exception.message,
        code: exception.code,
        details: exception.details,
        hint: exception.hint,
      );

  /// Code of the exception
  final String? code;

  /// Details of the exception
  final Object? details;

  /// Hint of the exception
  final String? hint;
}
