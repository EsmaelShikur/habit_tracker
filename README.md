# Habit Tracker 🎯

A beautiful, feature-rich Flutter mobile app for tracking daily habits with streaks and statistics.

## Features ✨

### Core Features

- ✅ **Habit Management** - Create, edit, delete, and archive habits
- ✅ **Daily Tracking** - Mark habits as completed each day with visual feedback
- 🔥 **Streak System** - Track current and longest streaks with automatic calculation
- 📊 **Statistics** - Comprehensive stats with charts and progress visualization
- 🎨 **Customization** - Choose from 16 colors and 24+ icons for each habit
- 🌓 **Dark Mode** - Full dark mode support with theme persistence
- 💾 **Local Storage** - All data persists locally using Hive database

### Statistics & Insights

- Weekly completion charts
- Monthly calendar view
- Overall completion rate
- Total completions counter
- Habit rankings by streak
- Individual habit analytics

### UI/UX Highlights

- Material 3 design system
- Smooth animations and transitions
- Responsive layout
- Clean, modern interface
- Google Fonts (Inter)
- Intuitive navigation

## Screenshots

(Add your screenshots here)

## Getting Started 🚀

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- iOS Simulator / Android Emulator or physical device

### Installation

1. **Clone the repository**

   ```bash
   git clone <your-repo-url>
   cd habit_tracker
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure 📁

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── habit.dart           # Habit data model
│   └── habit.g.dart         # Generated Hive adapter
├── providers/
│   ├── habit_provider.dart  # Habit state management
│   └── theme_provider.dart  # Theme state management
├── screens/
│   ├── home_screen.dart           # Main habit list
│   ├── add_edit_habit_screen.dart # Add/Edit habit form
│   ├── habit_detail_screen.dart   # Detailed habit view
│   ├── statistics_screen.dart     # Charts and analytics
│   └── settings_screen.dart       # App settings
├── widgets/
│   ├── habit_card.dart      # Habit list item widget
│   └── weekly_progress.dart # Weekly progress grid
├── services/
│   └── hive_service.dart    # Database service
└── utils/
    └── constants.dart       # App constants and extensions
```

## Architecture 🏗️

The app follows **Clean Architecture** principles:

- **Models**: Data structures and business logic
- **Providers**: State management using Provider pattern
- **Screens**: UI screens and navigation
- **Widgets**: Reusable UI components
- **Services**: External services (database, etc.)
- **Utils**: Helper functions and constants

## Dependencies 📦

### Core

- `provider: ^6.1.1` - State management
- `hive: ^2.2.3` - Local database
- `hive_flutter: ^1.1.0` - Hive Flutter integration

### UI

- `google_fonts: ^6.1.0` - Custom fonts
- `fl_chart: ^0.66.0` - Charts and graphs
- `flex_color_picker: ^3.4.1` - Color picker
- `flutter_iconpicker: ^3.2.4` - Icon picker

### Utilities

- `uuid: ^4.3.3` - Unique ID generation
- `intl: ^0.19.0` - Internationalization

### Dev Dependencies

- `hive_generator: ^2.0.1` - Code generation for Hive
- `build_runner: ^2.4.8` - Build tool

## Usage Guide 📖

### Creating a Habit

1. Tap the **"New Habit"** floating action button
2. Enter a title (required)
3. Add an optional description
4. Choose a color and icon
5. Tap the checkmark to save

### Tracking Daily Progress

1. On the home screen, tap the checkbox next to a habit to mark it complete
2. Tap again to unmark if needed
3. Watch your streak grow! 🔥

### Viewing Statistics

1. Tap the bar chart icon in the app bar
2. View overall stats, weekly charts, and habit rankings
3. See your progress over time

### Habit Details

1. Tap on any habit card to see detailed information
2. View weekly and monthly progress
3. See current and longest streaks
4. Edit or delete the habit

### Settings

1. Toggle dark mode on/off
2. View and restore archived habits
3. Manage your data

## Data Model 📝

### Habit

```dart
{
  id: String (UUID)
  title: String
  description: String
  color: int (ARGB)
  iconCodePoint: int
  createdAt: DateTime
  completedDatesMillis: List<int>
  currentStreak: int
  longestStreak: int
  isArchived: bool
}
```

## Streak Calculation Algorithm 🔥

The streak system works as follows:

1. **Current Streak**: Counts consecutive days from today or yesterday backwards
2. If you completed today or yesterday, streak continues
3. If you missed more than one day, streak resets to 0
4. **Longest Streak**: Automatically tracked and never decreases

## Future Enhancements 🚀

- [ ] Push notifications for habit reminders
- [ ] Habit categories and filtering
- [ ] Data backup to cloud (Firebase/Supabase)
- [ ] Export data as CSV/JSON
- [ ] Gamification with badges and achievements
- [ ] Weekly/Monthly goals
- [ ] Social features (share progress)
- [ ] Custom habit schedules (not just daily)
- [ ] Multi-language support

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License.

## Author ✍️

Created with ❤️ using Flutter

## Acknowledgments 🙏

- Flutter team for the amazing framework
- Material Design for UI guidelines
- fl_chart for beautiful charts
- Hive for efficient local storage

---

**Happy Habit Tracking! 🎯**
