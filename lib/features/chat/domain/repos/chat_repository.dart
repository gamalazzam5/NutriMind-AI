import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class ChatRepository {
  Future<Either<Failure, String>> sendText({
    required String text,
    required String conversationId,
  });

  Future<Either<Failure, String>> sendImage({
    required String imagePath,
    required String conversationId,
    String? caption,
  });
}
