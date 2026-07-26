import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimind/features/scanner/data/models/scanner_response_model.dart';

void main() {
  group('ScannerResponseModel.fromJson', () {
    test('parses a successful scan response', () {
      final model = ScannerResponseModel.fromJson({
        'success': true,
        'scan': {
          'foodName': 'Grilled Chicken Salad',
          'servingSize': '1 bowl',
          'calories': 410.0,
          'protein': 36.2,
          'carbs': 22,
          'fat': 16,
          'healthScore': 91,
          'ingredients': ['chicken', 'lettuce'],
          'warnings': [],
        },
      });

      expect(model.success, isTrue);
      expect(model.scan, isNotNull);
      expect(model.scan!.foodName, 'Grilled Chicken Salad');
      expect(model.scan!.calories, 410);
      expect(model.scan!.proteinGrams, 36);
      expect(model.scan!.carbsGrams, 22);
      expect(model.scan!.fatGrams, 16);
      expect(model.scan!.healthScore, 91);
    });

    test('parses a failure response with no scan payload', () {
      final model = ScannerResponseModel.fromJson({
        'success': false,
        'error': 'Scanner service is temporarily unavailable.',
      });

      expect(model.success, isFalse);
      expect(model.scan, isNull);
      expect(model.error, 'Scanner service is temporarily unavailable.');
    });

    test('defaults missing numeric fields to 0 and foodName to Unknown', () {
      final model = ScannerResponseModel.fromJson({
        'success': true,
        'scan': <String, dynamic>{},
      });

      expect(model.scan!.foodName, 'Unknown');
      expect(model.scan!.calories, 0);
      expect(model.scan!.proteinGrams, 0);
    });
  });
}
