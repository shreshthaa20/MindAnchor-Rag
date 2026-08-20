import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/user_session.dart';
import 'api_provider.dart';
import 'chat_provider.dart';
import 'journal_provider.dart';
import 'mood_provider.dart';
import 'dashboard_provider.dart';

class AuthNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  AuthNotifier(this._ref) : super(const AsyncValue.loading()) {
    restoreSession();
  }

  final Ref _ref;

  Future<void> restoreSession() async {
    state = const AsyncValue.loading();
    try {
      final user = await _ref.read(authRepositoryProvider).currentUser();
      state = AsyncValue.data(user);
    } catch (_) {
      await _ref.read(authRepositoryProvider).logout();
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final session = await _ref.read(authRepositoryProvider).login(
          email: email,
          password: password,
        );
    state = AsyncValue.data(session.user);
    _invalidateCachedProviders();
  }

  Future<void> logout() async {
    await _ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
    _invalidateCachedProviders();
  }

  void _invalidateCachedProviders() {
    // Invalidate providers to force them to reload fresh data for the new user
    _ref.invalidate(chatProvider);
    _ref.invalidate(journalProvider);
    _ref.invalidate(moodProvider);
    _ref.invalidate(dashboardProvider);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AppUser?>>(
  (ref) => AuthNotifier(ref),
);
