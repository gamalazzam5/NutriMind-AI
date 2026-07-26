import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutrimind/core/error/failures.dart';
import 'package:nutrimind/features/chat/domain/usecases/send_chat_image_message_usecase.dart';
import 'package:nutrimind/features/chat/domain/usecases/send_chat_text_message_usecase.dart';
import 'package:nutrimind/features/chat/presentation/cubit/chat_cubit.dart';

class _MockSendChatTextMessageUseCase extends Mock implements SendChatTextMessageUseCase {}

class _MockSendChatImageMessageUseCase extends Mock implements SendChatImageMessageUseCase {}

void main() {
  late _MockSendChatTextMessageUseCase sendText;
  late _MockSendChatImageMessageUseCase sendImage;
  late ChatCubit cubit;

  setUp(() {
    sendText = _MockSendChatTextMessageUseCase();
    sendImage = _MockSendChatImageMessageUseCase();
    cubit = ChatCubit(sendText, sendImage);
  });

  tearDown(() => cubit.close());

  test('starts with a single greeting message from the AI', () {
    expect(cubit.state.messages, hasLength(1));
    expect(cubit.state.messages.single.isUser, isFalse);
    expect(cubit.state.isAiTyping, isFalse);
  });

  group('sendMessage', () {
    test('appends the user message, sets typing, then appends the AI reply', () async {
      when(
        () => sendText(text: 'How much protein in eggs?', conversationId: any(named: 'conversationId')),
      ).thenAnswer((_) async => const Right('About 6g per large egg.'));

      final future = cubit.sendMessage('How much protein in eggs?');
      expect(cubit.state.isAiTyping, isTrue);
      expect(cubit.state.messages.last.isUser, isTrue);
      expect(cubit.state.messages.last.text, 'How much protein in eggs?');

      await future;

      expect(cubit.state.isAiTyping, isFalse);
      expect(cubit.state.messages.last.isUser, isFalse);
      expect(cubit.state.messages.last.text, 'About 6g per large egg.');
    });

    test('ignores blank input', () async {
      final before = cubit.state.messages.length;
      await cubit.sendMessage('   ');
      expect(cubit.state.messages.length, before);
      verifyNever(
        () => sendText(text: any(named: 'text'), conversationId: any(named: 'conversationId')),
      );
    });

    test('shows the failure message as the AI reply on failure', () async {
      when(
        () => sendText(text: 'hi', conversationId: any(named: 'conversationId')),
      ).thenAnswer((_) async => const Left(NetworkFailure('No internet connection.')));

      await cubit.sendMessage('hi');

      expect(cubit.state.isAiTyping, isFalse);
      expect(cubit.state.messages.last.isUser, isFalse);
      expect(cubit.state.messages.last.text, 'No internet connection.');
    });
  });

  group('sendImage', () {
    test('appends the user image message, then the AI reply', () async {
      when(
        () => sendImage(imagePath: '/tmp/a.jpg', conversationId: any(named: 'conversationId')),
      ).thenAnswer((_) async => const Right('Looks like a salad!'));

      await cubit.sendImage('/tmp/a.jpg');

      expect(cubit.state.messages[cubit.state.messages.length - 2].imagePath, '/tmp/a.jpg');
      expect(cubit.state.messages.last.text, 'Looks like a salad!');
      expect(cubit.state.isAiTyping, isFalse);
    });
  });
}
