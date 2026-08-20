import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/dashboard_analytics.dart';
import 'api_provider.dart';

final dashboardProvider =
    FutureProvider.autoDispose<DashboardAnalytics>((ref) {
  return ref.watch(dashboardRepositoryProvider).getAnalytics();
});
