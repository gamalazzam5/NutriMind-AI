import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutrimind/core/error/failures.dart';
import 'package:nutrimind/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:nutrimind/features/chat/data/models/chat_response_model.dart';
import 'package:nutrimind/features/chat/data/repos/chat_repository_impl.dart';

class _MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource {}

void main() {
  late _MockChatRemoteDataSource dataSource;
  late ChatRepositoryImpl repository;

  setUp(() {
    dataSource = _MockChatRemoteDataSource();
    repository = ChatRepositoryImpl(dataSource);
  });

  group('sendText', () {
    test('returns Right(reply) when the webhook responds successfully', () async {
      when(() => dataSource.sendText(text: 'hi', conversationId: 'c1')).thenAnswer(
        (_) async => const ChatResponseModel(success: true, reply: 'Hello there!'),
      );

      final result = await repository.sendText(text: 'hi', conversationId: 'c1');

      expect(result, const Right('Hello there!'));
    });

    test('returns Left(ServerFailure) when the webhook reports failure', () async {
      when(() => dataSource.sendText(text: 'hi', conversationId: 'c1')).thenAnswer(
        (_) async => const ChatResponseModel(success: false, error: 'Gemini is down'),
      );

      final result = await repository.sendText(text: 'hi', conversationId: 'c1');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Gemini is down');
        },
        (_) => fail('expected a failure'),
      );
    });

    test('maps a thrown DioException to a Failure', () async {
      when(() => dataSource.sendText(text: 'hi', conversationId: 'c1')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/chat-support'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.sendText(text: 'hi', conversationId: 'c1');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('expected a failure'),
      );
    });
  });

  group('sendImage', () {
    test('returns Right(reply) when the webhook responds successfully', () async {
      when(
        () => dataSource.sendImage(imagePath: '/tmp/a.jpg', conversationId: 'c1'),
      ).thenAnswer(
        (_) async => const ChatResponseModel(success: true, reply: "That's a salad!"),
      );

      final result = await repository.sendImage(
        imagePath: '/tmp/a.jpg',
        conversationId: 'c1',
      );

      expect(result, const Right("That's a salad!"));
    });

    test('returns a generic ServerFailure when success but no reply is present', () async {
      when(
        () => dataSource.sendImage(imagePath: '/tmp/a.jpg', conversationId: 'c1'),
      ).thenAnswer((_) async => const ChatResponseModel(success: true, reply: null));

      final result = await repository.sendImage(
        imagePath: '/tmp/a.jpg',
        conversationId: 'c1',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('expected a failure'),
      );
    });
  });
}
