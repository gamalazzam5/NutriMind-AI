import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutrimind/features/chat/domain/repos/chat_repository.dart';
import 'package:nutrimind/features/chat/domain/usecases/send_chat_text_message_usecase.dart';

class _MockChatRepository extends Mock implements ChatRepository {}

void main() {
  test('delegates to ChatRepository.sendText with the given arguments', () async {
    final repository = _MockChatRepository();
    final useCase = SendChatTextMessageUseCase(repository);
    when(
      () => repository.sendText(text: 'hi', conversationId: 'c1'),
    ).thenAnswer((_) async => const Right('hello!'));

    final result = await useCase(text: 'hi', conversationId: 'c1');

    expect(result, const Right('hello!'));
    verify(() => repository.sendText(text: 'hi', conversationId: 'c1')).called(1);
  });
}
