import '../../domain/entities/scan_result_entity.dart';

class ScanResultModel extends ScanResultEntity {
  const ScanResultModel({
    required super.foodName,
    required super.calories,
    required super.healthScore,
    required super.proteinGrams,
    required super.carbsGrams,
    required super.fatGrams,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      foodName: json['foodName'] as String? ?? 'Unknown',
      calories: (json['calories'] as num?)?.round() ?? 0,
      healthScore: (json['healthScore'] as num?)?.round() ?? 0,
      proteinGrams: (json['protein'] as num?)?.round() ?? 0,
      carbsGrams: (json['carbs'] as num?)?.round() ?? 0,
      fatGrams: (json['fat'] as num?)?.round() ?? 0,
    );
  }
}


class ScannerResponseModel {
  final bool success;
  final ScanResultModel? scan;
  final String? error;

  const ScannerResponseModel({required this.success, this.scan, this.error});

  factory ScannerResponseModel.fromJson(Map<String, dynamic> json) {
    final scanJson = json['scan'] as Map<String, dynamic>?;
    return ScannerResponseModel(
      success: json['success'] == true,
      scan: scanJson == null ? null : ScanResultModel.fromJson(scanJson),
      error: json['error'] as String?,
    );
  }
}
