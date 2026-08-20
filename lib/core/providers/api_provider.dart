import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';
import '../services/auth_repository.dart';
import '../services/chat_repository.dart';
import '../services/dashboard_repository.dart';
import '../services/journal_repository.dart';
import '../services/mood_repository.dart';
import '../services/token_storage_service.dart';

final tokenStorageProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService(const FlutterSecureStorage());
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    ref.watch(tokenStorageProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(tokenStorageProvider),
  );
});

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository(ref.watch(apiClientProvider));
});

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(ref.watch(apiClientProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(apiClientProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(apiClientProvider));
});
