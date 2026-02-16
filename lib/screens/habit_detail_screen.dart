import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/weekly_progress.dart';
import '../utils/constants.dart';
import 'add_edit_habit_screen.dart';

/// Detailed view of a single habit with statistics and actions
class HabitDetailScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${habit.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<HabitProvider>(
                context,
                listen: false,
              ).deleteHabit(habit.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close detail screen
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitColor = Color(habit.color);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditHabitScreen(habit: habit),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingLarge * 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [habitColor, habitColor.lighten(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusLarge,
                      ),
                    ),
                    child: Icon(
                      IconData(
                        habit.iconCodePoint,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    habit.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (habit.description.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      habit.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // Statistics Cards
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                children: [
                  // Streaks Row
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_fire_department,
                          iconColor: Colors.orange,
                          label: 'Current Streak',
                          value: '${habit.currentStreak}',
                          subtitle: 'days',
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.emoji_events,
                          iconColor: Colors.amber,
                          label: 'Best Streak',
                          value: '${habit.longestStreak}',
                          subtitle: 'days',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),

                  // Completions Row
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                          label: 'Total Completions',
                          value: '${habit.totalCompletions}',
                          subtitle: 'times',
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.show_chart,
                          iconColor: Colors.blue,
                          label: 'Success Rate',
                          value: '${habit.completionRate.toStringAsFixed(0)}%',
                          subtitle: 'overall',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),

                  // Weekly Progress
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last 7 Days',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          WeeklyProgress(habit: habit),
                        ],
                      ),
                    ),
                  ),

                  // Monthly Calendar (Current Month)
                  const SizedBox(height: AppConstants.paddingMedium),
                  _MonthlyCalendar(habit: habit),

                  // Archive Button
                  const SizedBox(height: AppConstants.paddingLarge),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Provider.of<HabitProvider>(
                          context,
                          listen: false,
                        ).toggleArchive(habit);
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        habit.isArchived ? Icons.unarchive : Icons.archive,
                      ),
                      label: Text(habit.isArchived ? 'Unarchive' : 'Archive'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Statistic card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Monthly calendar widget showing habit completion
class _MonthlyCalendar extends StatelessWidget {
  final Habit habit;

  const _MonthlyCalendar({required this.habit});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayWeekday = DateTime(now.year, now.month, 1).weekday;
    final habitColor = Color(habit.color);
    final monthlyData = habit.getMonthlyCompletions(now.year, now.month);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Month',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                  .map(
                    (day) => SizedBox(
                      width: 32,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: daysInMonth + firstDayWeekday - 1,
              itemBuilder: (context, index) {
                if (index < firstDayWeekday - 1) {
                  return const SizedBox();
                }

                final day = index - firstDayWeekday + 2;
                final isCompleted = monthlyData[day] ?? false;
                final isToday = day == now.day;

                return Container(
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? habitColor
                        : habitColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: isToday
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted ? Colors.white : null,
                        fontWeight: isToday ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
