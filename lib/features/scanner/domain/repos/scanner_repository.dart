import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/scan_result_entity.dart';

abstract class ScannerRepository {
  Future<Either<Failure, ScanResultEntity>> analyzeImage({
    required String imagePath,
  });
}
