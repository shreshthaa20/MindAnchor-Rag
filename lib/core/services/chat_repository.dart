import '../../shared/models/chat_message.dart';
import 'api_client.dart';

class ChatRepository {
  ChatRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ChatMessage>> getHistory(String chatType) async {
    final response = await _apiClient.get('/chat?type=$chatType');
    return (response['messages'] as List<dynamic>)
        .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChatMessage>> sendMessage({
    required String message,
    required String chatType,
  }) async {
    if (chatType == 'wellness_guide') {
      final response = await _apiClient.post(
        '/rag/wellness-guide',
        body: {
          'question': message,
        },
      );

      return [
        ChatMessage.fromJson(
          response['userMessage'] as Map<String, dynamic>,
        ),
        ChatMessage.fromJson(
          response['assistantMessage'] as Map<String, dynamic>,
        ),
      ];
    }

    final response = await _apiClient.post(
      '/chat',
      body: {
        'message': message,
        'type': chatType,
      },
    );

    return [
      ChatMessage.fromJson(
        response['userMessage'] as Map<String, dynamic>,
      ),
      ChatMessage.fromJson(
        response['assistantMessage'] as Map<String, dynamic>,
      ),
    ];
  }
}
