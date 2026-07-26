import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/scan_result_entity.dart';
import 'scanner_state.dart';

const _mockResults = [
  ScanResultEntity(
    foodName: 'Avocado Sourdough Toast',
    calories: 340,
    healthScore: 85,
    proteinGrams: 12,
    carbsGrams: 38,
    fatGrams: 18,
  ),
  ScanResultEntity(
    foodName: 'Grilled Chicken Salad',
    calories: 410,
    healthScore: 91,
    proteinGrams: 36,
    carbsGrams: 22,
    fatGrams: 16,
  ),
  ScanResultEntity(
    foodName: 'Quinoa Power Bowl',
    calories: 540,
    healthScore: 88,
    proteinGrams: 21,
    carbsGrams: 62,
    fatGrams: 19,
  ),
];

/// Drives the AI Food Scanner: capture a photo, run (mocked) AI analysis,
/// and surface the estimated nutrition breakdown.
/// TODO: replace [_analyze]'s mocked delay with a real AI vision backend call.
class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit(this._picker) : super(const ScannerIdle());

  final ImagePicker _picker;
  int _resultIndex = 0;

  Future<void> captureFromCamera() => _pickAndAnalyze(ImageSource.camera);

  Future<void> captureFromGallery() => _pickAndAnalyze(ImageSource.gallery);

  Future<void> _pickAndAnalyze(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 85);
      if (file == null) return;
      await _analyze(file.path);
    } on PlatformException catch (e) {
      final denied = e.code.contains('access_denied') || e.code.contains('permission');
      emit(ScannerError(denied ? 'scanner_permission_denied' : 'scanner_error'));
    } catch (_) {
      emit(const ScannerError('scanner_error'));
    }
  }

  Future<void> _analyze(String imagePath) async {
    emit(ScannerScanning(imagePath));
    await Future.delayed(const Duration(milliseconds: 1600));
    if (isClosed) return;
    final result = _mockResults[_resultIndex % _mockResults.length];
    _resultIndex++;
    emit(ScannerResultReady(imagePath, result));
  }

  void reset() => emit(const ScannerIdle());
}
