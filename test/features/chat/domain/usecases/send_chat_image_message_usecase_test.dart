import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutrimind/features/chat/domain/repos/chat_repository.dart';
import 'package:nutrimind/features/chat/domain/usecases/send_chat_image_message_usecase.dart';

class _MockChatRepository extends Mock implements ChatRepository {}

void main() {
  test('delegates to ChatRepository.sendImage with the given arguments', () async {
    final repository = _MockChatRepository();
    final useCase = SendChatImageMessageUseCase(repository);
    when(
      () => repository.sendImage(imagePath: '/tmp/a.jpg', conversationId: 'c1'),
    ).thenAnswer((_) async => const Right('nice photo!'));

    final result = await useCase(imagePath: '/tmp/a.jpg', conversationId: 'c1');

    expect(result, const Right('nice photo!'));
    verify(
      () => repository.sendImage(imagePath: '/tmp/a.jpg', conversationId: 'c1'),
    ).called(1);
  });
}
