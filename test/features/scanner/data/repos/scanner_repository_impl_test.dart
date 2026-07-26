import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutrimind/core/error/failures.dart';
import 'package:nutrimind/features/scanner/data/datasources/scanner_remote_data_source.dart';
import 'package:nutrimind/features/scanner/data/models/scanner_response_model.dart';
import 'package:nutrimind/features/scanner/data/repos/scanner_repository_impl.dart';

class _MockScannerRemoteDataSource extends Mock implements ScannerRemoteDataSource {}

void main() {
  late _MockScannerRemoteDataSource dataSource;
  late ScannerRepositoryImpl repository;

  setUp(() {
    dataSource = _MockScannerRemoteDataSource();
    repository = ScannerRepositoryImpl(dataSource);
  });

  test('returns Right(ScanResultEntity) when the webhook responds successfully', () async {
    const scan = ScanResultModel(
      foodName: 'Avocado Toast',
      calories: 340,
      healthScore: 85,
      proteinGrams: 12,
      carbsGrams: 38,
      fatGrams: 18,
    );
    when(() => dataSource.analyzeImage(imagePath: '/tmp/a.jpg')).thenAnswer(
      (_) async => const ScannerResponseModel(success: true, scan: scan),
    );

    final result = await repository.analyzeImage(imagePath: '/tmp/a.jpg');

    expect(result.isRight(), isTrue);
    result.fold(
      (_) => fail('expected a success'),
      (entity) => expect(entity.foodName, 'Avocado Toast'),
    );
  });

  test('returns Left(ServerFailure) when the webhook reports failure', () async {
    when(() => dataSource.analyzeImage(imagePath: '/tmp/a.jpg')).thenAnswer(
      (_) async => const ScannerResponseModel(success: false, error: 'Vision service down'),
    );

    final result = await repository.analyzeImage(imagePath: '/tmp/a.jpg');

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Vision service down');
      },
      (_) => fail('expected a failure'),
    );
  });

  test('maps a thrown DioException (e.g. timeout) to a Failure', () async {
    when(() => dataSource.analyzeImage(imagePath: '/tmp/a.jpg')).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/scanner'),
        type: DioExceptionType.receiveTimeout,
      ),
    );

    final result = await repository.analyzeImage(imagePath: '/tmp/a.jpg');

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure, isA<NetworkFailure>()),
      (_) => fail('expected a failure'),
    );
  });
}
