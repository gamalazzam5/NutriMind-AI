import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repos/chat_repository.dart';

class SendChatImageMessageUseCase {
  SendChatImageMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<Either<Failure, String>> call({
    required String imagePath,
    required String conversationId,
    String? caption,
  }) {
    return _repository.sendImage(
      imagePath: imagePath,
      conversationId: conversationId,
      caption: caption,
    );
  }
}
