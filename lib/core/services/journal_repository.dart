import '../../shared/models/journal_entry.dart';
import 'api_client.dart';

class JournalRepository {
  JournalRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<JournalEntry>> getJournals() async {
    final response = await _apiClient.get('/journals');
    return (response['journals'] as List<dynamic>)
        .map((item) => JournalEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<JournalEntry> createJournal({
    required String title,
    required String content,
  }) async {
    final response = await _apiClient.post(
      '/journals',
      body: {
        'title': title,
        'content': content,
      },
    );

    return JournalEntry.fromJson(
      response['journal'] as Map<String, dynamic>,
    );
  }

  Future<JournalEntry> updateJournal({
    required int id,
    required String title,
    required String content,
  }) async {
    final response = await _apiClient.put(
      '/journals/$id',
      body: {
        'title': title,
        'content': content,
      },
    );

    return JournalEntry.fromJson(
      response['journal'] as Map<String, dynamic>,
    );
  }

  Future<void> deleteJournal(int id) {
    return _apiClient.delete('/journals/$id');
  }
}
