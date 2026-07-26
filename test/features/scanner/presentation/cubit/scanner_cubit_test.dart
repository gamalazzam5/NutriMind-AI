import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutrimind/core/error/failures.dart';
import 'package:nutrimind/features/scanner/domain/entities/scan_result_entity.dart';
import 'package:nutrimind/features/scanner/domain/usecases/analyze_food_image_usecase.dart';
import 'package:nutrimind/features/scanner/presentation/cubit/scanner_cubit.dart';
import 'package:nutrimind/features/scanner/presentation/cubit/scanner_state.dart';

class _MockImagePicker extends Mock implements ImagePicker {}

class _MockAnalyzeFoodImageUseCase extends Mock implements AnalyzeFoodImageUseCase {}

void main() {
  late _MockImagePicker picker;
  late _MockAnalyzeFoodImageUseCase analyzeFoodImage;
  late ScannerCubit cubit;

  const result = ScanResultEntity(
    foodName: 'Avocado Toast',
    calories: 340,
    healthScore: 85,
    proteinGrams: 12,
    carbsGrams: 38,
    fatGrams: 18,
  );

  setUp(() {
    picker = _MockImagePicker();
    analyzeFoodImage = _MockAnalyzeFoodImageUseCase();
    cubit = ScannerCubit(picker, analyzeFoodImage);
  });

  tearDown(() => cubit.close());

  test('starts idle', () {
    expect(cubit.state, isA<ScannerIdle>());
  });

  test('captureFromCamera does nothing when the user cancels the picker', () async {
    when(
      () => picker.pickImage(source: ImageSource.camera, imageQuality: 85),
    ).thenAnswer((_) async => null);

    await cubit.captureFromCamera();

    expect(cubit.state, isA<ScannerIdle>());
    verifyNever(() => analyzeFoodImage(imagePath: any(named: 'imagePath')));
  });

  test('emits ScannerResultReady with the analysis on success', () async {
    when(
      () => picker.pickImage(source: ImageSource.camera, imageQuality: 85),
    ).thenAnswer((_) async => XFile('/tmp/a.jpg'));
    when(
      () => analyzeFoodImage(imagePath: '/tmp/a.jpg'),
    ).thenAnswer((_) async => const Right(result));

    await cubit.captureFromCamera();

    final state = cubit.state;
    expect(state, isA<ScannerResultReady>());
    expect((state as ScannerResultReady).imagePath, '/tmp/a.jpg');
    expect(state.result.foodName, 'Avocado Toast');
  });

  test('emits ScannerError when analysis fails', () async {
    when(
      () => picker.pickImage(source: ImageSource.gallery, imageQuality: 85),
    ).thenAnswer((_) async => XFile('/tmp/a.jpg'));
    when(
      () => analyzeFoodImage(imagePath: '/tmp/a.jpg'),
    ).thenAnswer((_) async => const Left(ServerFailure('down')));

    await cubit.captureFromGallery();

    expect(cubit.state, isA<ScannerError>());
    expect((cubit.state as ScannerError).messageKey, 'scanner_error');
  });

  test('reset returns to idle', () async {
    when(
      () => picker.pickImage(source: ImageSource.camera, imageQuality: 85),
    ).thenAnswer((_) async => XFile('/tmp/a.jpg'));
    when(
      () => analyzeFoodImage(imagePath: '/tmp/a.jpg'),
    ).thenAnswer((_) async => const Right(result));
    await cubit.captureFromCamera();

    cubit.reset();

    expect(cubit.state, isA<ScannerIdle>());
  });
}
