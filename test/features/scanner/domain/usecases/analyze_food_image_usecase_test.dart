import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutrimind/features/scanner/domain/entities/scan_result_entity.dart';
import 'package:nutrimind/features/scanner/domain/repos/scanner_repository.dart';
import 'package:nutrimind/features/scanner/domain/usecases/analyze_food_image_usecase.dart';

class _MockScannerRepository extends Mock implements ScannerRepository {}

void main() {
  test('delegates to ScannerRepository.analyzeImage with the given path', () async {
    final repository = _MockScannerRepository();
    final useCase = AnalyzeFoodImageUseCase(repository);
    const entity = ScanResultEntity(
      foodName: 'Quinoa Bowl',
      calories: 540,
      healthScore: 88,
      proteinGrams: 21,
      carbsGrams: 62,
      fatGrams: 19,
    );
    when(
      () => repository.analyzeImage(imagePath: '/tmp/a.jpg'),
    ).thenAnswer((_) async => const Right(entity));

    final result = await useCase(imagePath: '/tmp/a.jpg');

    expect(result, const Right(entity));
    verify(() => repository.analyzeImage(imagePath: '/tmp/a.jpg')).called(1);
  });
}
