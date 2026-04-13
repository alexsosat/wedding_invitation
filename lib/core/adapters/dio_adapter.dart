import "dart:async";

import "package:dio/browser.dart";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter_common_classes/flutter_common_classes.dart"
    hide EnvironmentConfig;
import "package:flutter_flavor/flutter_flavor.dart";
import "package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart";

import "../config/environment_config.dart";

/// Adapter for the Dio client
///
/// This adapter is used to create a Dio client with the necessary
/// configurations for the application. It also includes the necessary
/// error handling for the application.
class DioAdapter extends DioForBrowser {
  /// Adapter for the Dio client
  ///
  /// This adapter is used to create a Dio client with the necessary
  /// configurations for the application. It also includes the necessary
  /// error handling for the application.
  DioAdapter({
    required this.internetInfo,
    required this.baseUrl,
    this.receiveTimeout,
    this.connectTimeout,
    this.sendTimeout,
  }) {
    _initializeAdapter();
  }

  /// Information about the internet connection
  final NetworkInfo internetInfo;

  /// The timeout for the receive operation
  final Duration? receiveTimeout;

  /// The timeout for the connect operation
  final Duration? connectTimeout;

  /// The timeout for the send operation
  final Duration? sendTimeout;

  /// The base URL for the Dio client
  final String baseUrl;

  void _initializeAdapter() {
    final environment = FlavorConfig.instance.variables;

    options = BaseOptions(
      baseUrl: baseUrl,
      sendTimeout: sendTimeout,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      contentType: "application/json",
      responseType: ResponseType.json,
      headers: {
        "Authorization": "Bearer ${environment[EnvironmentConfig.apiKeyKey]}",
        "Connection": "keep-alive",
        "Accept": "application/json",
      },
    );

    interceptors
      ..add(
        PrettyDioLogger(
          requestHeader: true,
          queryParameters: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          showProcessingTime: false,
          showCUrl: false,
          canShowLog: kDebugMode,
        ),
      )
      ..add(RetryInterceptor(dio: this))
      ..add(
        InterceptorsWrapper(
          onRequest: onRequestMethod,
          onResponse: onResponseMethod,
          onError: onErrorMethod,
        ),
      );
  }

  /// Handles the request prior to being sent
  FutureOr<void> onRequestMethod(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    handler.next(options);
  }

  /// Handles the response prior to being returned
  FutureOr<void> onResponseMethod(
    Response response,
    ResponseInterceptorHandler handler,
  ) async =>
      handler.next(response);

  /// Handles the error prior to being thrown
  FutureOr<void> onErrorMethod(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    HttpCallException? errorObject;

    switch (error.type) {
      case DioExceptionType.connectionError:
        errorObject = await internetInfo.isConnected
            ? ConnectionErrorException.serverDown()
            : ConnectionErrorException.clientOffline();

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorObject = await internetInfo.isConnected
            ? ConnectionErrorException.serverDown()
            : ConnectionErrorException.clientOffline();

      case DioExceptionType.badResponse:
        final statusCode = error.response!.statusCode!;

        if (statusCode.isBetween(300, 499)) {
          if (error.response?.data is String) {
            errorObject = ClientErrorException.badRequest(
              message: error.response?.data as String,
            );
          } else {
            final errorMessage = error.response?.data["Message"] != null
                ? (error.response!.data["Message"] as String).trim()
                : "Error al procesar la solicitud";

            errorObject = statusCode.isBetween(401, 403)
                ? ClientErrorException.unauthorized(
                    data: error.response?.data,
                  )
                : ClientErrorException.badRequest(
                    message: errorMessage,
                    data: error.response?.data,
                  );
          }
        } else if (statusCode.isBetween(500, 599)) {
          final String? generalMessage =
              error.response?.data["ExceptionMessage"] as String?;

          final Map<String, dynamic>? innerException =
              error.response?.data["InnerException"];
          final String? innerMessage =
              innerException?["ExceptionMessage"] as String?;

          errorObject = ServerErrorException(
            title: "Error del servidor",
            message: innerMessage ??
                generalMessage ??
                "Error al procesar la solicitud",
            data: error.response?.data,
          );
        } else {
          errorObject = ClientErrorException.badRequest();
        }
      case DioExceptionType.cancel:
        errorObject = ClientErrorException.cancelRequest();
      case DioExceptionType.badCertificate:
        errorObject = ServerErrorException.badCertificate();
      case DioExceptionType.unknown:
        errorObject = await internetInfo.isConnected
            ? ConnectionErrorException.serverDown()
            : ConnectionErrorException.clientOffline();
    }

    final customError = error.copyWith(
      error: errorObject,
    );

    handler.reject(customError);

    return;
  }
}

/// Interceptor to retry the request if it fails
class RetryInterceptor extends Interceptor {
  /// The constructor for the RetryInterceptor
  ///
  /// It receives the [dio] instance and the [maxRetries] and [retryDelay]
  /// parameters.
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  /// The Dio instance
  final Dio dio;

  /// The maximum number of retries
  final int maxRetries;

  /// The delay between each retry
  final Duration retryDelay;

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    int retryCount = 0;

    if (_shouldRetry(err)) {
      while (retryCount < maxRetries) {
        try {
          retryCount++;

          await Future.delayed(retryDelay * retryCount);

          final response = await dio.request(
            err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );

          return handler.resolve(response);
        } on DioException catch (e) {
          if (retryCount >= maxRetries) {
            return handler.next(e);
          }
        }
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException error) =>
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.unknown;
}
