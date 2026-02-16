import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';

/// Service class for managing Hive database operations
/// Handles initialization and box management
class HiveService {
  static const String _habitBoxName = 'habits';

  /// Initialize Hive and register adapters
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register the Habit adapter (TypeId: 0)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitAdapter());
    }

    // Open the habits box
    await Hive.openBox<Habit>(_habitBoxName);
  }

  /// Get the habits box
  static Box<Habit> getHabitsBox() {
    return Hive.box<Habit>(_habitBoxName);
  }

  /// Close all boxes (call on app disposal if needed)
  static Future<void> closeAll() async {
    await Hive.close();
  }
}
