import "package:dio/dio.dart";
import "package:flutter_common_classes/flutter_common_classes.dart";
import "package:fpdart/fpdart.dart";

/// The [ErrorHandler] class is responsible for handling the exceptions
class ErrorHandler {
  static final Logger _logger = getLogger("ErrorHandler");

  /// Handles the exceptions that can be thrown in the application
  /// during an API call.
  ///
  /// It receives a [function] that is the API call to be executed.
  /// Returns an [Either] with the [Failure] or the [T] value.
  /// Handles the exceptions that can be thrown in the application
  /// during an API call.
  ///
  /// It receives a [function] that is the API call to be executed.
  /// Returns an [Either] with the [Failure] or the [T] value.
  static Future<Either<Failure, T>> handleApiCall<T>(
    Future<T> Function() function,
  ) async {
    try {
      return Right(await function());
    } on HttpCallException catch (exception) {
      return Left(HttpCallFailure.fromException(exception));
    } on DioException catch (exception) {
      if (exception.error is HttpCallException) {
        return Left(
          HttpCallFailure.fromException(
            exception.error! as HttpCallException,
          ),
        );
      }

      return Left(
        AppFailure.unexpected(
          exception.message ?? "Error desconocido",
        ),
      );
    } catch (e, stackTrace) {
      _logger.e("Error: $e - Stack trace: $stackTrace", stackTrace: stackTrace);

      return Left(
        AppFailure.unexpected(e.toString()),
      );
    }
  }
}
