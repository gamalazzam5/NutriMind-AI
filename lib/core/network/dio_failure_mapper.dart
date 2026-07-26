import 'package:dio/dio.dart';

import '../error/failures.dart';

/// Maps a caught error from a Dio call to a typed [Failure], used at the
/// data-layer boundary of every remote repository.
Failure mapDioException(Object error) {
  if (error is! DioException) {
    return const UnknownFailure('Something went wrong. Please try again.');
  }

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure('The request timed out. Please try again.');
    case DioExceptionType.connectionError:
      return const NetworkFailure(
        'No internet connection. Please check your network.',
      );
    case DioExceptionType.badResponse:
      final data = error.response?.data;
      final serverMessage = data is Map ? data['error']?.toString() : null;
      return ServerFailure(
        serverMessage ?? 'Something went wrong. Please try again.',
      );
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
    default:
      return const UnknownFailure('Something went wrong. Please try again.');
  }
}
