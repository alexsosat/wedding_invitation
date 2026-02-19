import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "app_failures.dart";

/// The [ErrorHandler] class is responsible for handling the exceptions
class ErrorHandler {
  static final Logger _logger = getLogger("ErrorHandler");

  /// Handles the exceptions that can be thrown in the application
  /// during a Postgrest call.
  ///
  /// It receives a [function] that is the API call to be executed.
  /// Returns an [Either] with the [Failure] or the [T] value.
  static Future<Either<Failure, T>> handlePostgrestCall<T>(
    Future<T> Function() function, [
    NetworkInfo? networkInfo,
  ]) async {
    try {
      if (networkInfo != null && !(await networkInfo.isConnected)) {
        throw ConnectionErrorException.clientOffline();
      }

      _logger.i("Handling Postgrest call: $function");

      return Right(await function());
    } on ConnectionErrorException catch (exception) {
      return Left(HttpCallFailure.fromException(exception));
    } on PostgrestException catch (exception) {
      _logger.e("Error handling Postgrest call: $exception");

      return Left(
        PostgressFailure.fromException(exception),
      );
    } catch (e, s) {
      _logger.e("Error handling Postgrest call: $e with stack trace: $s");

      return Left(AppFailure.unexpected(e.toString()));
    }
  }

  /// Handles the exceptions that can be thrown in the application
  /// during a cache call.
  ///
  /// It receives a [function] that is the cache call to be executed.
  /// Returns an [Either] with the [Failure] or the [T] value.
  static Either<Failure, T> handleCacheCall<T>(
    T Function() function,
  ) {
    try {
      return Right(function());
    } on CacheException catch (exception) {
      return Left(AppFailure.cacheException(exception));
    } catch (e) {
      return Left(
        AppFailure.unexpected(e.toString()),
      );
    }
  }

  /// Handles the exceptions that can be thrown in the application
  /// during a secure cache call.
  ///
  /// It receives a [function] that is the secure cache call to be executed.
  /// Returns an [Either] with the [Failure] or the [T] value.
  static Future<Either<Failure, T>> handleCacheCallAsync<T>(
    Future<T> Function() function,
  ) async {
    try {
      return Right(await function());
    } on CacheException catch (exception) {
      return Left(AppFailure.cacheException(exception));
    } catch (e) {
      return Left(
        AppFailure.unexpected(e.toString()),
      );
    }
  }
}
