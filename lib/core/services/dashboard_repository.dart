import '../../shared/models/dashboard_analytics.dart';
import 'api_client.dart';

class DashboardRepository {
  DashboardRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<DashboardAnalytics> getAnalytics() async {
    final response = await _apiClient.get('/dashboard');
    return DashboardAnalytics.fromJson(
      response['dashboard'] as Map<String, dynamic>,
    );
  }
}
