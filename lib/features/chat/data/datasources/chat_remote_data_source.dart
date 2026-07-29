import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_response_parser.dart';
import '../../../../core/utils/image_encoding.dart';
import '../models/chat_response_model.dart';

/// Calls the `chat-support` n8n webhook, which detects text vs. image input
/// and routes it to Gemini / Gemini Vision.
class ChatRemoteDataSource {
  ChatRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ChatResponseModel> sendText({
    required String text,
    required String conversationId,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.chatSupport,
      data: {
        'type': 'text',
        'text': text,
        'conversationId': conversationId,
      },
    );
    return ChatResponseModel.fromJson(parseJsonResponse(response.data));
  }

  Future<ChatResponseModel> sendImage({
    required String imagePath,
    required String conversationId,
    String? caption,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.chatSupport,
      data: {
        'type': 'image',
        'image': await encodeImageFileToBase64(imagePath),
        'mimeType': resolveImageMimeType(imagePath),
        'conversationId': conversationId,
        if (caption != null && caption.trim().isNotEmpty) 'text': caption.trim(),
      },
    );
    return ChatResponseModel.fromJson(parseJsonResponse(response.data));
  }
}
