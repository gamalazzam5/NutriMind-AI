import '../../domain/entities/scan_result_entity.dart';

sealed class ScannerState {
  const ScannerState();
}

class ScannerIdle extends ScannerState {
  const ScannerIdle();
}

class ScannerScanning extends ScannerState {
  const ScannerScanning(this.imagePath);
  final String imagePath;
}

class ScannerResultReady extends ScannerState {
  const ScannerResultReady(this.imagePath, this.result);
  final String imagePath;
  final ScanResultEntity result;
}

class ScannerError extends ScannerState {
  const ScannerError(this.messageKey);
  final String messageKey;
}
