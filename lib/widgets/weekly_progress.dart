import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/constants.dart';

/// Widget displaying a 7-day progress grid for a habit
class WeeklyProgress extends StatelessWidget {
  final Habit habit;

  const WeeklyProgress({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final weeklyData = habit.getWeeklyCompletions();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final habitColor = Color(habit.color);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final date = today.subtract(Duration(days: 6 - index));
        final isCompleted = weeklyData[index];
        final isToday = index == 6;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              children: [
                Text(
                  ['M', 'T', 'W', 'T', 'F', 'S', 'S'][date.weekday - 1],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: AppConstants.shortAnimation,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? habitColor
                        : habitColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: isToday
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
