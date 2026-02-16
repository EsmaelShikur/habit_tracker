import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/habit_provider.dart';
import '../utils/constants.dart';

/// Screen displaying overall statistics and charts
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          final stats = habitProvider.getOverallStats();
          final weeklyData = habitProvider.getWeeklyCompletionData();

          if (stats['totalHabits'] == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 100,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  Text(
                    'No Statistics Yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    'Start tracking habits to see your progress',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            children: [
              // Overview Cards
              _buildOverviewCard(context, stats),
              const SizedBox(height: AppConstants.paddingLarge),

              // Weekly Chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Activity',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      SizedBox(
                        height: 200,
                        child: _WeeklyBarChart(data: weeklyData),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              // Individual Habit Stats
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Habit Rankings',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      _buildHabitRankings(context, habitProvider),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    icon: Icons.track_changes,
                    iconColor: Colors.blue,
                    label: 'Total Habits',
                    value: '${stats['totalHabits']}',
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: _StatBox(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    label: 'Completed Today',
                    value: '${stats['completedToday']}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    icon: Icons.local_fire_department,
                    iconColor: Colors.orange,
                    label: 'Avg Streak',
                    value: '${stats['averageStreak'].toStringAsFixed(1)}',
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: _StatBox(
                    icon: Icons.trending_up,
                    iconColor: Colors.purple,
                    label: 'Avg Rate',
                    value:
                        '${stats['averageCompletionRate'].toStringAsFixed(0)}%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitRankings(BuildContext context, HabitProvider provider) {
    final habits = provider.habits.where((h) => !h.isArchived).toList();

    // Sort by current streak
    habits.sort((a, b) => b.currentStreak.compareTo(a.currentStreak));

    return Column(
      children: habits.take(5).map((habit) {
        final habitColor = Color(habit.color);
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: habitColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Icon(
                  IconData(habit.iconCodePoint, fontFamily: 'MaterialIcons'),
                  color: habitColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    LinearProgressIndicator(
                      value: habit.completionRate / 100,
                      backgroundColor: habitColor.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(habitColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.currentStreak}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    '${habit.completionRate.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Stat box widget for overview
class _StatBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatBox({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Weekly bar chart widget
class _WeeklyBarChart extends StatelessWidget {
  final Map<int, int> data;

  const _WeeklyBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxY = data.values.isEmpty
        ? 10.0
        : data.values.reduce((a, b) => a > b ? a : b).toDouble() + 2;

    return BarChart(
      BarChartData(
        maxY: maxY,
        barGroups: data.entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: Theme.of(context).colorScheme.primary,
                width: 20,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Text(
                    days[value.toInt()],
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Theme.of(context).dividerColor,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
