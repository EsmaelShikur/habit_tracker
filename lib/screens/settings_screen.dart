import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/habit_provider.dart';
import '../utils/constants.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Appearance Section
          _SectionHeader(title: 'Appearance'),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme'),
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          const Divider(),

          // Data Section
          _SectionHeader(title: 'Data'),
          Consumer<HabitProvider>(
            builder: (context, habitProvider, child) {
              final archivedCount = habitProvider.archivedHabits.length;

              return ListTile(
                leading: const Icon(Icons.archive),
                title: const Text('Archived Habits'),
                subtitle: Text('$archivedCount archived'),
                trailing: const Icon(Icons.chevron_right),
                onTap: archivedCount > 0
                    ? () => _showArchivedHabits(context)
                    : null,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export Data'),
            subtitle: const Text('Download your habit data'),
            onTap: () => _showExportDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete all habits permanently'),
            onTap: () => _showClearDataDialog(context),
          ),
          const Divider(),

          // About Section
          _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Built with Flutter'),
            subtitle: const Text('Material 3 Design'),
          ),
        ],
      ),
    );
  }

  void _showArchivedHabits(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final archivedHabits = habitProvider.archivedHabits;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Archived Habits',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            ...archivedHabits.map((habit) {
              final habitColor = Color(habit.color);
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: habitColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusSmall,
                    ),
                  ),
                  child: Icon(
                    IconData(habit.iconCodePoint, fontFamily: 'MaterialIcons'),
                    color: habitColor,
                    size: 20,
                  ),
                ),
                title: Text(habit.title),
                subtitle: Text('Archived on ${habit.createdAt.formattedShort}'),
                trailing: IconButton(
                  icon: const Icon(Icons.unarchive),
                  onPressed: () {
                    habitProvider.toggleArchive(habit);
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'This feature will be available in a future update. '
          'It will allow you to export your habit data as CSV or JSON.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to delete all habits? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final habitProvider = Provider.of<HabitProvider>(
                context,
                listen: false,
              );

              // Delete all habits
              final allHabits = [...habitProvider.habits];
              for (final habit in allHabits) {
                habitProvider.deleteHabit(habit.id);
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingMedium,
        AppConstants.paddingLarge,
        AppConstants.paddingMedium,
        AppConstants.paddingSmall,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
