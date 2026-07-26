import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimind/core/network/dio_response_parser.dart';

void main() {
  group('parseJsonResponse', () {
    test('returns the map as-is when data is already a Map', () {
      final result = parseJsonResponse({'success': true});
      expect(result, {'success': true});
    });

    test('decodes a JSON-encoded string body', () {
      final result = parseJsonResponse('{"success": true, "reply": "hi"}');
      expect(result, {'success': true, 'reply': 'hi'});
    });

    test('returns an empty map for null data', () {
      expect(parseJsonResponse(null), <String, dynamic>{});
    });

    test('returns an empty map for an empty string', () {
      expect(parseJsonResponse(''), <String, dynamic>{});
    });

    test('returns an empty map for malformed JSON', () {
      expect(parseJsonResponse('{not valid json'), <String, dynamic>{});
    });

    test('returns an empty map when the JSON decodes to a non-Map', () {
      expect(parseJsonResponse('[1, 2, 3]'), <String, dynamic>{});
    });
  });
}
