import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/dashboard_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    return Scaffold(
      // Transparent — the gradient background living in HomeScreen shows
      // through. Individual tab screens should never paint their own
      // solid background, or they'd cover the gradient the whole app
      // is built around.
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: dashboard.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.pink),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
        data: (analytics) {
          final distribution = analytics.moodDistribution;

          return RefreshIndicator(
            onRefresh: () => ref.refresh(dashboardProvider.future),
            color: AppTheme.pink,
            backgroundColor: AppTheme.surface,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Stat row: mood entries + journal entries ──
                  // Two GlassCards side by side, replacing two separate
                  // full-width Cards from before — same info, half the
                  // vertical space, and reads as one cohesive stat pair.
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.favorite_rounded,
                          iconColor: AppTheme.pink,
                          value: "${analytics.totalMoods}",
                          label: "mood entries",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.book_rounded,
                          iconColor: AppTheme.violet,
                          value: "${analytics.totalJournals}",
                          label: "journal entries",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Latest mood + weekly summary, combined ──
                  GlassCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: _LabelValue(
                            label: "Latest mood",
                            value: analytics.latestMood ?? "No mood logged",
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 32,
                          color: Colors.white24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _LabelValue(
                            label: "This week",
                            value:
                                "${analytics.weeklySummary.moodCount} moods · "
                                "${analytics.weeklySummary.journalCount} journals",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Insights: streak, most common mood, trend ──
                  // Was 3 separate ListTiles inside one Card before —
                  // now compact rows with thin dividers inside one glass
                  // panel, so it reads as one connected "insights" unit
                  // rather than 3 stacked list items.
                  GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 6,
                    ),
                    child: Column(
                      children: [
                        _InsightRow(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFF59E0B),
                          label: "Mood streak",
                          value: "${analytics.insights.moodStreakDays} days",
                        ),
                        const Divider(color: Colors.white12, height: 1),
                        _InsightRow(
                          icon: Icons.star_rounded,
                          iconColor: AppTheme.pink,
                          label: "Most common mood",
                          value:
                              analytics.insights.mostCommonMood ??
                              "No mood data yet",
                        ),
                        const Divider(color: Colors.white12, height: 1),
                        _InsightRow(
                          icon: Icons.trending_up_rounded,
                          iconColor: AppTheme.blue,
                          label: "Weekly trend",
                          value: analytics.insights.trendDirection.replaceAll(
                            "_",
                            " ",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Mood Analytics",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: distribution.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "No mood analytics yet",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : Column(
                            children: [
                              for (int i = 0; i < distribution.length; i++) ...[
                                if (i > 0)
                                  const Divider(
                                    color: Colors.white12,
                                    height: 1,
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        distribution[i].mood,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "${distribution[i].count}",
                                        style: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// One of the two small stat tiles at the top (mood entries / journal
/// entries) — extracted as its own widget since the same shape is used
/// twice with different data.
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

/// A small "label above value" pair — used for latest mood / weekly
/// summary inside the combined glass card.
class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// One row inside the insights glass card (icon, label, value).
class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}