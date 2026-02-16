import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/constants.dart';

/// Screen for adding a new habit or editing an existing one
class AddEditHabitScreen extends StatefulWidget {
  final Habit? habit;

  const AddEditHabitScreen({super.key, this.habit});

  @override
  State<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends State<AddEditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late Color _selectedColor;
  late IconData _selectedIcon;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.habit != null) {
      // Editing existing habit
      _titleController.text = widget.habit!.title;
      _descriptionController.text = widget.habit!.description;
      _selectedColor = Color(widget.habit!.color);
      _selectedIcon = IconData(
        widget.habit!.iconCodePoint,
        fontFamily: 'MaterialIcons',
      );
    } else {
      // New habit - set defaults
      _selectedColor = AppConstants.habitColors[0];
      _selectedIcon = AppConstants.habitIcons[0];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final habitProvider = Provider.of<HabitProvider>(context, listen: false);

      if (widget.habit != null) {
        // Update existing habit
        final updatedHabit = widget.habit!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          color: _selectedColor.value,
          iconCodePoint: _selectedIcon.codePoint,
        );
        await habitProvider.updateHabit(updatedHabit);
      } else {
        // Create new habit
        final newHabit = Habit(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          color: _selectedColor.value,
          iconCodePoint: _selectedIcon.codePoint,
          createdAt: DateTime.now(),
        );
        await habitProvider.addHabit(newHabit);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving habit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: AppConstants.habitColors.length,
            itemBuilder: (context, index) {
              final color = AppConstants.habitColors[index];
              final isSelected = color.value == _selectedColor.value;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedColor = color);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          )
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showIconPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Icon'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: AppConstants.habitIcons.length,
            itemBuilder: (context, index) {
              final icon = AppConstants.habitIcons[index];
              final isSelected = icon.codePoint == _selectedIcon.codePoint;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIcon = icon);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _selectedColor.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusSmall,
                    ),
                    border: isSelected
                        ? Border.all(color: _selectedColor, width: 2)
                        : Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? _selectedColor
                        : Theme.of(context).iconTheme.color,
                    size: 28,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit != null ? 'Edit Habit' : 'New Habit'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(icon: const Icon(Icons.check), onPressed: _saveHabit),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            // Preview Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _selectedColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusLarge,
                        ),
                      ),
                      child: Icon(
                        _selectedIcon,
                        color: _selectedColor,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Habit Title *',
                hintText: 'e.g., Morning Exercise',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Add more details about this habit',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Color Selection
            Card(
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                  ),
                ),
                title: const Text('Color'),
                subtitle: const Text('Tap to change'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showColorPicker,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),

            // Icon Selection
            Card(
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _selectedColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_selectedIcon, color: _selectedColor),
                ),
                title: const Text('Icon'),
                subtitle: const Text('Tap to change'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showIconPicker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
