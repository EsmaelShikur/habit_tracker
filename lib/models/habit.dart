import 'package:hive/hive.dart';

part 'habit.g.dart';

/// Habit model representing a user's habit to track
/// Uses Hive for local storage persistence
@HiveType(typeId: 0)
class Habit extends HiveObject {
  /// Unique identifier for the habit
  @HiveField(0)
  String id;

  /// Title of the habit (e.g., "Morning Exercise")
  @HiveField(1)
  String title;

  /// Optional description providing more context
  @HiveField(2)
  String description;

  /// Color value (ARGB format) for visual identification
  @HiveField(3)
  int color;

  /// Icon code point for visual representation
  @HiveField(4)
  int iconCodePoint;

  /// Timestamp when habit was created
  @HiveField(5)
  DateTime createdAt;

  /// List of dates when the habit was completed (stored as milliseconds since epoch)
  @HiveField(6)
  List<int> completedDatesMillis;

  /// Current consecutive days streak
  @HiveField(7)
  int currentStreak;

  /// Longest streak ever achieved
  @HiveField(8)
  int longestStreak;

  /// Whether the habit is archived
  @HiveField(9)
  bool isArchived;

  Habit({
    required this.id,
    required this.title,
    this.description = '',
    required this.color,
    required this.iconCodePoint,
    required this.createdAt,
    List<int>? completedDatesMillis,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.isArchived = false,
  }) : completedDatesMillis = completedDatesMillis ?? [];

  /// Get completed dates as DateTime objects
  List<DateTime> get completedDates {
    return completedDatesMillis
        .map((millis) => DateTime.fromMillisecondsSinceEpoch(millis))
        .toList();
  }

  /// Check if habit was completed on a specific date (ignoring time)
  bool isCompletedOnDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return completedDates.any((completedDate) {
      final completedDateOnly = DateTime(
        completedDate.year,
        completedDate.month,
        completedDate.day,
      );
      return completedDateOnly.isAtSameMomentAs(dateOnly);
    });
  }

  /// Check if habit is completed today
  bool get isCompletedToday {
    return isCompletedOnDate(DateTime.now());
  }

  /// Toggle completion for today
  void toggleToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (isCompletedToday) {
      // Remove today's completion
      completedDatesMillis.removeWhere((millis) {
        final date = DateTime.fromMillisecondsSinceEpoch(millis);
        final dateOnly = DateTime(date.year, date.month, date.day);
        return dateOnly.isAtSameMomentAs(today);
      });
    } else {
      // Add today's completion
      completedDatesMillis.add(today.millisecondsSinceEpoch);
    }

    // Recalculate streaks
    _calculateStreaks();
    save();
  }

  /// Calculate current and longest streaks
  void _calculateStreaks() {
    if (completedDates.isEmpty) {
      currentStreak = 0;
      return;
    }

    // Sort dates in descending order
    final sortedDates = completedDates.map((date) {
      return DateTime(date.year, date.month, date.day);
    }).toList()..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final yesterday = todayOnly.subtract(const Duration(days: 1));

    // Calculate current streak
    currentStreak = 0;
    DateTime checkDate = todayOnly;

    // Check if completed today or yesterday to start streak
    if (sortedDates.first.isAtSameMomentAs(todayOnly) ||
        sortedDates.first.isAtSameMomentAs(yesterday)) {
      for (final date in sortedDates) {
        if (date.isAtSameMomentAs(checkDate)) {
          currentStreak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else if (date.isBefore(checkDate)) {
          // Gap found, streak broken
          break;
        }
      }
    }

    // Calculate longest streak
    int tempStreak = 1;
    longestStreak = 1;

    for (int i = 0; i < sortedDates.length - 1; i++) {
      final diff = sortedDates[i].difference(sortedDates[i + 1]).inDays;

      if (diff == 1) {
        tempStreak++;
        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
      } else {
        tempStreak = 1;
      }
    }

    // Update longest streak if current is longer
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
  }

  /// Get total number of completions
  int get totalCompletions => completedDates.length;

  /// Calculate completion rate as percentage
  double get completionRate {
    final daysSinceCreation = DateTime.now().difference(createdAt).inDays + 1;
    if (daysSinceCreation == 0) return 0.0;
    return (totalCompletions / daysSinceCreation) * 100;
  }

  /// Get completions for the last 7 days
  List<bool> getWeeklyCompletions() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      return isCompletedOnDate(date);
    });
  }

  /// Get completions for a specific month
  Map<int, bool> getMonthlyCompletions(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final completions = <int, bool>{};

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      completions[day] = isCompletedOnDate(date);
    }

    return completions;
  }

  /// Copy with method for immutability
  Habit copyWith({
    String? title,
    String? description,
    int? color,
    int? iconCodePoint,
    bool? isArchived,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      createdAt: createdAt,
      completedDatesMillis: List.from(completedDatesMillis),
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
