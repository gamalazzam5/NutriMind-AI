/// A single message in the AI chat conversation.
///
/// [text] may contain `**bold**` segments, rendered emphasized by
/// [ChatBubble]. [note] is an optional secondary, muted line shown below
/// the main text (used for the AI's follow-up remark). [imagePath] is set
/// for image attachments picked from the camera or gallery.
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
