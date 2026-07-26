import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repos/chat_repository.dart';

class SendChatTextMessageUseCase {
  SendChatTextMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<Either<Failure, String>> call({
    required String text,
    required String conversationId,
  }) {
    return _repository.sendText(text: text, conversationId: conversationId);
  }
}
