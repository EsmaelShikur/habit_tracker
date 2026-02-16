import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../services/hive_service.dart';

/// Provider for managing habit state and operations
/// Uses ChangeNotifier for reactive UI updates
class HabitProvider extends ChangeNotifier {
  late Box<Habit> _habitBox;
  List<Habit> _habits = [];
  bool _showArchived = false;

  HabitProvider() {
    _habitBox = HiveService.getHabitsBox();
    _loadHabits();
  }

  /// Get all non-archived habits
  List<Habit> get habits =>
      _showArchived ? _habits : _habits.where((h) => !h.isArchived).toList();

  /// Get archived habits
  List<Habit> get archivedHabits => _habits.where((h) => h.isArchived).toList();

  /// Toggle showing archived habits
  bool get showArchived => _showArchived;

  void toggleShowArchived() {
    _showArchived = !_showArchived;
    notifyListeners();
  }

  /// Load habits from Hive
  void _loadHabits() {
    _habits = _habitBox.values.toList();
    // Sort by creation date (newest first)
    _habits.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  /// Add a new habit
  Future<void> addHabit(Habit habit) async {
    try {
      await _habitBox.put(habit.id, habit);
      _loadHabits();
    } catch (e) {
      debugPrint('Error adding habit: $e');
      rethrow;
    }
  }

  /// Update an existing habit
  Future<void> updateHabit(Habit habit) async {
    try {
      await habit.save();
      _loadHabits();
    } catch (e) {
      debugPrint('Error updating habit: $e');
      rethrow;
    }
  }

  /// Delete a habit
  Future<void> deleteHabit(String id) async {
    try {
      await _habitBox.delete(id);
      _loadHabits();
    } catch (e) {
      debugPrint('Error deleting habit: $e');
      rethrow;
    }
  }

  /// Archive/Unarchive a habit
  Future<void> toggleArchive(Habit habit) async {
    try {
      habit.isArchived = !habit.isArchived;
      await habit.save();
      _loadHabits();
    } catch (e) {
      debugPrint('Error archiving habit: $e');
      rethrow;
    }
  }

  /// Toggle completion for today
  Future<void> toggleCompletion(Habit habit) async {
    try {
      habit.toggleToday();
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling completion: $e');
      rethrow;
    }
  }

  /// Get habit by ID
  Habit? getHabitById(String id) {
    return _habitBox.get(id);
  }

  /// Get overall statistics
  Map<String, dynamic> getOverallStats() {
    final activeHabits = habits.where((h) => !h.isArchived).toList();

    if (activeHabits.isEmpty) {
      return {
        'totalHabits': 0,
        'completedToday': 0,
        'averageStreak': 0.0,
        'totalCompletions': 0,
        'averageCompletionRate': 0.0,
      };
    }

    final completedToday = activeHabits.where((h) => h.isCompletedToday).length;
    final totalCompletions = activeHabits.fold<int>(
      0,
      (sum, habit) => sum + habit.totalCompletions,
    );

    final averageStreak =
        activeHabits.fold<double>(
          0.0,
          (sum, habit) => sum + habit.currentStreak,
        ) /
        activeHabits.length;

    final averageCompletionRate =
        activeHabits.fold<double>(
          0.0,
          (sum, habit) => sum + habit.completionRate,
        ) /
        activeHabits.length;

    return {
      'totalHabits': activeHabits.length,
      'completedToday': completedToday,
      'averageStreak': averageStreak,
      'totalCompletions': totalCompletions,
      'averageCompletionRate': averageCompletionRate,
    };
  }

  /// Get completion data for the last 7 days across all habits
  Map<int, int> getWeeklyCompletionData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekData = <int, int>{};

    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: 6 - i));
      int completions = 0;

      for (final habit in habits.where((h) => !h.isArchived)) {
        if (habit.isCompletedOnDate(date)) {
          completions++;
        }
      }

      weekData[i] = completions;
    }

    return weekData;
  }

  @override
  void dispose() {
    // Don't close the box here, as it might be used elsewhere
    super.dispose();
  }
}
