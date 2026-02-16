import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../utils/constants.dart';
import 'add_edit_habit_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import 'habit_detail_screen.dart';

/// Main home screen displaying all habits
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habit Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Statistics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          final habits = habitProvider.habits;

          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.track_changes,
                    size: 100,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  Text(
                    'No Habits Yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    'Tap the + button to create your first habit',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            );
          }

          // Calculate today's progress
          final completedToday = habits.where((h) => h.isCompletedToday).length;
          final totalHabits = habits.length;
          final progress = totalHabits > 0 ? completedToday / totalHabits : 0.0;

          return Column(
            children: [
              // Today's Progress Card
              Container(
                margin: const EdgeInsets.all(AppConstants.paddingMedium),
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.lighten(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Today\'s Progress',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$completedToday',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          ' / $totalHabits',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSmall,
                      ),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% Complete',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // Habits List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return HabitCard(
                      habit: habit,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HabitDetailScreen(habit: habit),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditHabitScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
      ),
    );
  }
}
