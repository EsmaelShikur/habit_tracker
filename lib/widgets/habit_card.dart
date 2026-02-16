import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/constants.dart';

/// Card widget displaying a single habit with completion toggle
class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;

  const HabitCard({super.key, required this.habit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final isCompleted = habit.isCompletedToday;
    final habitColor = Color(habit.color);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // Habit Icon and Color
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: habitColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: Icon(
                  IconData(habit.iconCodePoint, fontFamily: 'MaterialIcons'),
                  color: habitColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),

              // Habit Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Current Streak
                        Icon(
                          Icons.local_fire_department,
                          size: 16,
                          color: habit.currentStreak > 0
                              ? Colors.orange
                              : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${habit.currentStreak} days',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        // Completion Rate
                        Icon(Icons.show_chart, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${habit.completionRate.toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Completion Checkbox
              AnimatedContainer(
                duration: AppConstants.shortAnimation,
                curve: Curves.easeInOut,
                child: Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: isCompleted,
                    activeColor: habitColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (value) {
                      habitProvider.toggleCompletion(habit);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
