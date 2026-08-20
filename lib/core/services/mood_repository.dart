import '../../shared/models/mood_entry.dart';
import 'api_client.dart';

class MoodRepository {
  MoodRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<MoodEntry>> getMoods() async {
    final response = await _apiClient.get('/moods');
    return (response['moods'] as List<dynamic>)
        .map((item) => MoodEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<MoodEntry> createMood(String mood) async {
    final response = await _apiClient.post(
      '/moods',
      body: {'mood': mood},
    );

    return MoodEntry.fromJson(response['mood'] as Map<String, dynamic>);
  }

  Future<MoodEntry> updateMood({
    required int id,
    required String mood,
  }) async {
    final response = await _apiClient.put(
      '/moods/$id',
      body: {'mood': mood},
    );

    return MoodEntry.fromJson(response['mood'] as Map<String, dynamic>);
  }

  Future<void> deleteMood(int id) {
    return _apiClient.delete('/moods/$id');
  }
}
