import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimind/core/error/failures.dart';
import 'package:nutrimind/core/network/dio_failure_mapper.dart';

DioException _exception(DioExceptionType type, {Response? response}) {
  return DioException(
    requestOptions: RequestOptions(path: '/test'),
    type: type,
    response: response,
  );
}

void main() {
  group('mapDioException', () {
    test('maps timeout types to NetworkFailure', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        expect(mapDioException(_exception(type)), isA<NetworkFailure>());
      }
    });

    test('maps connectionError to NetworkFailure', () {
      expect(
        mapDioException(_exception(DioExceptionType.connectionError)),
        isA<NetworkFailure>(),
      );
    });

    test('maps badResponse with a server error message to ServerFailure', () {
      final failure = mapDioException(
        _exception(
          DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: {'success': false, 'error': 'Gemini quota exceeded'},
            statusCode: 502,
          ),
        ),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Gemini quota exceeded');
    });

    test('maps badResponse without an error body to a generic ServerFailure', () {
      final failure = mapDioException(
        _exception(
          DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: null,
            statusCode: 500,
          ),
        ),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.message, isNotEmpty);
    });

    test('maps cancel/unknown/badCertificate to UnknownFailure', () {
      for (final type in [
        DioExceptionType.cancel,
        DioExceptionType.unknown,
        DioExceptionType.badCertificate,
      ]) {
        expect(mapDioException(_exception(type)), isA<UnknownFailure>());
      }
    });

    test('maps a non-Dio error to UnknownFailure', () {
      expect(mapDioException(Exception('boom')), isA<UnknownFailure>());
    });
  });
}
