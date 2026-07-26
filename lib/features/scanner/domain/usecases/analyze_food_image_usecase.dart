import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/scan_result_entity.dart';
import '../repos/scanner_repository.dart';

class AnalyzeFoodImageUseCase {
  AnalyzeFoodImageUseCase(this._repository);

  final ScannerRepository _repository;

  Future<Either<Failure, ScanResultEntity>> call({required String imagePath}) {
    return _repository.analyzeImage(imagePath: imagePath);
  }
}
