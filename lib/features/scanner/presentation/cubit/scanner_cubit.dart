import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/usecases/analyze_food_image_usecase.dart';
import 'scanner_state.dart';

/// Drives the AI Food Scanner: capture a photo and run it through the
/// `scanner` n8n webhook (Gemini Vision) for a nutrition breakdown.
class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit(this._picker, this._analyzeFoodImage) : super(const ScannerIdle());

  final ImagePicker _picker;
  final AnalyzeFoodImageUseCase _analyzeFoodImage;

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

  void reset() => emit(const ScannerIdle());
}
