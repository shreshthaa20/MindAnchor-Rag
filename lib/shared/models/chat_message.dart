class ChatMessage {
  final int id;
  final String role;
  final String chatType;
  final String content;
  final DateTime createdAt;
  final List<dynamic> recommendations;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.chatType,
    required this.content,
    required this.createdAt,
    this.recommendations = const [],
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      role: json['role'] as String,
      chatType: json['chat_type'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      recommendations: json['recommendations'] as List<dynamic>? ?? const [],
    );
  }
}
