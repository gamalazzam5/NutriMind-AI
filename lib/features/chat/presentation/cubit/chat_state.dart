import '../../domain/entities/chat_message_entity.dart';

class ChatState {
  final List<ChatMessageEntity> messages;
  final bool isAiTyping;

  const ChatState({this.messages = const [], this.isAiTyping = false});

  ChatState copyWith({List<ChatMessageEntity>? messages, bool? isAiTyping}) {
    return ChatState(
      messages: messages ?? this.messages,
      isAiTyping: isAiTyping ?? this.isAiTyping,
    );
  }
}
