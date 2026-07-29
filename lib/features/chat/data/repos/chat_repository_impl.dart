import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_failure_mapper.dart';
import '../../domain/repos/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_response_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._dataSource);

  final ChatRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, String>> sendText({
    required String text,
    required String conversationId,
  }) async {
    try {
      final response = await _dataSource.sendText(
        text: text,
        conversationId: conversationId,
      );
      return _resultFrom(response);
    } catch (e) {
      return Left(mapDioException(e));
    }
  }

  @override
  Future<Either<Failure, String>> sendImage({
    required String imagePath,
    required String conversationId,
    String? caption,
  }) async {
    try {
      final response = await _dataSource.sendImage(
        imagePath: imagePath,
        conversationId: conversationId,
        caption: caption,
      );
      return _resultFrom(response);
    } catch (e) {
      return Left(mapDioException(e));
    }
  }

  Either<Failure, String> _resultFrom(ChatResponseModel response) {
    if (response.success && response.reply != null) {
      return Right(response.reply!);
    }
    return Left(
      ServerFailure(response.error ?? 'Something went wrong. Please try again.'),
    );
  }
}
