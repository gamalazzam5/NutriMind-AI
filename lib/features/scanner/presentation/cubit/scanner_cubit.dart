import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/meal_log/domain/entities/logged_meal_entity.dart';
import '../../../../core/meal_log/domain/usecases/log_meal_usecase.dart';
import '../../domain/usecases/analyze_food_image_usecase.dart';
import 'scanner_state.dart';

/// Drives the AI Food Scanner: capture a photo and run it through the
/// `scanner` n8n webhook (Gemini Vision) for a nutrition breakdown.
class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit(this._picker, this._analyzeFoodImage, this._logMeal)
      : super(const ScannerIdle());

  final ImagePicker _picker;
  final AnalyzeFoodImageUseCase _analyzeFoodImage;
  final LogMealUseCase _logMeal;

  int _idCounter = 0;

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
    final result = await _analyzeFoodImage(imagePath: imagePath);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (kDebugMode) debugPrint('Scanner analysis failed: ${failure.message}');
        emit(const ScannerError('scanner_error'));
      },
      (scan) => emit(ScannerResultReady(imagePath, scan)),
    );
  }

  /// Persists the current scan result to the local meal log. Returns whether
  /// the log succeeded so the screen can surface a success or error message.
  /// On failure, the result stays on screen so the user can retry without
  /// rescanning.
  Future<bool> logCurrentMeal() async {
    final current = state;
    if (current is! ScannerResultReady) return false;

    final result = current.result;
    final logResult = await _logMeal(
      LoggedMealEntity(
        id: 'meal-${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}',
        foodName: result.foodName,
        calories: result.calories,
        healthScore: result.healthScore,
        proteinGrams: result.proteinGrams,
        carbsGrams: result.carbsGrams,
        fatGrams: result.fatGrams,
        imagePath: current.imagePath,
        loggedAt: DateTime.now(),
      ),
    );
    if (isClosed) return false;
    return logResult.fold(
      (failure) {
        if (kDebugMode) debugPrint('Failed to log meal: ${failure.message}');
        return false;
      },
      (_) {
        reset();
        return true;
      },
    );
  }

  void reset() => emit(const ScannerIdle());
}
