
class ChatMessageEntity {
  final String id;
  final String text;
  final String? note;
  final String? imagePath;
  final bool isUser;

  const ChatMessageEntity({
    required this.id,
    required this.isUser,
    this.text = '',
    this.note,
    this.imagePath,
  });
}
