import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/send_chat_image_message_usecase.dart';
import '../../domain/usecases/send_chat_text_message_usecase.dart';
import 'chat_state.dart';

const _seedMessages = [
  ChatMessageEntity(
    id: 'seed-1',
    isUser: false,
    text: "Hello! I'm NutriMind AI. How can I help you reach your wellness "
        'goals today?',
  ),
];

/// Manages the AI chat conversation, backed by the `chat-support` n8n
/// webhook (text -> Gemini, image -> Gemini Vision).
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._sendText, this._sendImage)
      : _conversationId = DateTime.now().microsecondsSinceEpoch.toString(),
        super(const ChatState(messages: _seedMessages));

  final SendChatTextMessageUseCase _sendText;
  final SendChatImageMessageUseCase _sendImage;
  final String _conversationId;

  int _idCounter = 0;

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMessage = ChatMessageEntity(
      id: 'user-${_idCounter++}',
      isUser: true,
      text: trimmed,
    );
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isAiTyping: true,
    ));

    final result = await _sendText(
      text: trimmed,
      conversationId: _conversationId,
    );
    if (isClosed) return;
    _emitReply(result);
  }

  Future<void> sendImage(String imagePath) async {
    final userMessage = ChatMessageEntity(
      id: 'user-${_idCounter++}',
      isUser: true,
      imagePath: imagePath,
    );
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isAiTyping: true,
    ));

    final result = await _sendImage(
      imagePath: imagePath,
      conversationId: _conversationId,
    );
    if (isClosed) return;
    _emitReply(result);
  }

  void _emitReply(Either<Failure, String> result) {
    final replyText = result.fold((failure) => failure.message, (reply) => reply);
    final reply = ChatMessageEntity(id: 'ai-${_idCounter++}', isUser: false, text: replyText);
    emit(state.copyWith(
      messages: [...state.messages, reply],
      isAiTyping: false,
    ));
  }
}
