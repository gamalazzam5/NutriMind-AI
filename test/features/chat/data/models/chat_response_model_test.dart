import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimind/features/chat/data/models/chat_response_model.dart';

void main() {
  group('ChatResponseModel.fromJson', () {
    test('parses a successful response', () {
      final model = ChatResponseModel.fromJson({
        'success': true,
        'reply': 'Greek yogurt has ~15g of protein per serving.',
        'conversationId': 'abc123',
      });

      expect(model.success, isTrue);
      expect(model.reply, 'Greek yogurt has ~15g of protein per serving.');
      expect(model.error, isNull);
    });

    test('parses a failure response', () {
      final model = ChatResponseModel.fromJson({
        'success': false,
        'error': 'Gemini quota exceeded',
        'code': 'GEMINI_ERROR',
      });

      expect(model.success, isFalse);
      expect(model.reply, isNull);
      expect(model.error, 'Gemini quota exceeded');
    });

    test('treats a missing success field as failure', () {
      final model = ChatResponseModel.fromJson(const {});
      expect(model.success, isFalse);
    });
  });
}
