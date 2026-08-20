class DashboardAnalytics {
  final int totalMoods;
  final int totalJournals;
  final String? latestMood;
  final List<MoodDistributionItem> moodDistribution;
  final List<MoodTrendItem> moodTrends;
  final WeeklySummary weeklySummary;
  final DashboardInsights insights;

  const DashboardAnalytics({
    required this.totalMoods,
    required this.totalJournals,
    required this.latestMood,
    required this.moodDistribution,
    required this.moodTrends,
    required this.weeklySummary,
    required this.insights,
  });

  factory DashboardAnalytics.fromJson(Map<String, dynamic> json) {
    final latestMoodJson = json['latestMood'] as Map<String, dynamic>?;

    return DashboardAnalytics(
      totalMoods: json['totalMoods'] as int,
      totalJournals: json['totalJournals'] as int,
      latestMood: latestMoodJson?['mood'] as String?,
      moodDistribution: (json['moodDistribution'] as List<dynamic>)
          .map(
            (item) => MoodDistributionItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      moodTrends: (json['moodTrends'] as List<dynamic>)
          .map(
            (item) => MoodTrendItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      weeklySummary: WeeklySummary.fromJson(
        json['weeklySummary'] as Map<String, dynamic>,
      ),
      insights: DashboardInsights.fromJson(
        json['insights'] as Map<String, dynamic>,
      ),
    );
  }
}

class MoodDistributionItem {
  final String mood;
  final int count;

  const MoodDistributionItem({
    required this.mood,
    required this.count,
  });

  factory MoodDistributionItem.fromJson(Map<String, dynamic> json) {
    return MoodDistributionItem(
      mood: json['mood'] as String,
      count: json['count'] as int,
    );
  }
}

class MoodTrendItem {
  final String day;
  final String mood;
  final int count;

  const MoodTrendItem({
    required this.day,
    required this.mood,
    required this.count,
  });

  factory MoodTrendItem.fromJson(Map<String, dynamic> json) {
    return MoodTrendItem(
      day: json['day'] as String,
      mood: json['mood'] as String,
      count: json['count'] as int,
    );
  }
}

class WeeklySummary {
  final String startDate;
  final String endDate;
  final int moodCount;
  final int journalCount;
  final String? topMood;

  const WeeklySummary({
    required this.startDate,
    required this.endDate,
    required this.moodCount,
    required this.journalCount,
    required this.topMood,
  });

  factory WeeklySummary.fromJson(Map<String, dynamic> json) {
    return WeeklySummary(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      moodCount: json['moodCount'] as int,
      journalCount: json['journalCount'] as int,
      topMood: json['topMood'] as String?,
    );
  }
}

class DashboardInsights {
  final int moodStreakDays;
  final String? mostCommonMood;
  final int journalEntriesThisWeek;
  final int moodEntriesThisWeek;
  final String trendDirection;

  const DashboardInsights({
    required this.moodStreakDays,
    required this.mostCommonMood,
    required this.journalEntriesThisWeek,
    required this.moodEntriesThisWeek,
    required this.trendDirection,
  });

  factory DashboardInsights.fromJson(Map<String, dynamic> json) {
    return DashboardInsights(
      moodStreakDays: json['moodStreakDays'] as int,
      mostCommonMood: json['mostCommonMood'] as String?,
      journalEntriesThisWeek: json['journalEntriesThisWeek'] as int,
      moodEntriesThisWeek: json['moodEntriesThisWeek'] as int,
      trendDirection: json['trendDirection'] as String,
    );
  }
}
