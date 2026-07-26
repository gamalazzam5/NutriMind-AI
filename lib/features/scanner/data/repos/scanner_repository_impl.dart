import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_failure_mapper.dart';
import '../../domain/entities/scan_result_entity.dart';
import '../../domain/repos/scanner_repository.dart';
import '../datasources/scanner_remote_data_source.dart';

class ScannerRepositoryImpl implements ScannerRepository {
  ScannerRepositoryImpl(this._dataSource);

  final ScannerRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, ScanResultEntity>> analyzeImage({
    required String imagePath,
  }) async {
    try {
      final response = await _dataSource.analyzeImage(imagePath: imagePath);
      if (response.success && response.scan != null) {
        return Right(response.scan!);
      }
      return Left(
        ServerFailure(
          response.error ?? "Couldn't analyze this photo. Please try again.",
        ),
      );
    } catch (e) {
      return Left(mapDioException(e));
    }
  }
}
