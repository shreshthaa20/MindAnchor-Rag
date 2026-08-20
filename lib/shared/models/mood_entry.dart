class MoodEntry {
  final int id;
  final String mood;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MoodEntry({
    required this.id,
    required this.mood,
    required this.createdAt,
    this.updatedAt,
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as int,
      mood: json['mood'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }
}
