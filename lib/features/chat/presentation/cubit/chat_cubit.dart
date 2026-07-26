import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message_entity.dart';
import 'chat_state.dart';

const _seedMessages = [
  ChatMessageEntity(
    id: 'seed-1',
    isUser: false,
    text: "Hello! I'm NutriMind AI. How can I help you reach your wellness "
        'goals today?',
  ),
  ChatMessageEntity(
    id: 'seed-2',
    isUser: true,
    text: 'How much protein is in Greek yogurt?',
  ),
  ChatMessageEntity(
    id: 'seed-3',
    isUser: false,
    text: 'A typical 6-ounce (170g) serving of plain, non-fat Greek yogurt '
        'contains about **15 to 17 grams of protein**.',
    note: "It's a fantastic, nutrient-dense choice for muscle recovery and "
        'satiety!',
  ),
];

/// Manages the AI chat conversation. The AI reply is currently mocked;
/// TODO: wire to the NutriMind AI backend once the chat endpoint is ready.
class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState(messages: _seedMessages));

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

    await Future.delayed(const Duration(milliseconds: 800));
    if (isClosed) return;

    final reply = ChatMessageEntity(
      id: 'ai-${_idCounter++}',
      isUser: false,
      text: "That's a great question! I'm still learning — full AI-powered "
          "answers are coming soon.",
    );
    emit(state.copyWith(
      messages: [...state.messages, reply],
      isAiTyping: false,
    ));
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

    await Future.delayed(const Duration(milliseconds: 800));
    if (isClosed) return;

    final reply = ChatMessageEntity(
      id: 'ai-${_idCounter++}',
      isUser: false,
      text: 'Got your photo! Image-based meal analysis is coming soon.',
    );
    emit(state.copyWith(
      messages: [...state.messages, reply],
      isAiTyping: false,
    ));
  }
}
