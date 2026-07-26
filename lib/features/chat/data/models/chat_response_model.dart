/// Maps the JSON body returned by the `chat-support` n8n webhook:
/// `{ success, reply, conversationId, type, timestamp }` on success, or
/// `{ success: false, error, code }` on failure.
class ChatResponseModel {
  final bool success;
  final String? reply;
  final String? error;

  const ChatResponseModel({required this.success, this.reply, this.error});

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      success: json['success'] == true,
      reply: json['reply'] as String?,
      error: json['error'] as String?,
    );
  }
}
