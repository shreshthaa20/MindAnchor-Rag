import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/chat_message.dart';
import 'api_provider.dart';

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  ChatNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  final Ref _ref;
  String _chatType = 'wellness_guide';

  String get chatType => _chatType;

  Future<void> setChatType(String chatType) async {
    if (_chatType == chatType) return;

    _chatType = chatType;
    await loadHistory();
  }

  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    try {
      final messages =
          await _ref.read(chatRepositoryProvider).getHistory(_chatType);
      state = AsyncValue.data(messages);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> sendMessage(String message) async {
    final previous = state.value ?? [];
    try {
      final newMessages =
          await _ref.read(chatRepositoryProvider).sendMessage(
                message: message,
                chatType: _chatType,
              );
      state = AsyncValue.data([...previous, ...newMessages]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      state = AsyncValue.data(previous);
      rethrow;
    }
  }
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<List<ChatMessage>>>(
  (ref) => ChatNotifier(ref),
);
