import 'package:flutter/material.dart';
import '../../domain/engine.dart';

class SettingsPage extends StatefulWidget {
  final PomodoroEngine engine;

  const SettingsPage({super.key, required this.engine});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _focusController;
  late TextEditingController _shortBreakController;
  late TextEditingController _longBreakController;
  late TextEditingController _customController;
  late TextEditingController _sessionsController;

  late bool _autoAdvance;
  late bool _notificationsEnabled;
  late Color _accentColor;

  final List<Color> _colorOptions = [
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFFFF5722), // Deep Orange
    const Color(0xFF4CAF50), // Green
    const Color(0xFF9C27B0), // Purple
    const Color(0xFFFFC107), // Amber
    const Color(0xFFE91E63), // Pink
    const Color(0xFF2196F3), // Blue
    const Color(0xFFFF9800), // Orange
  ];

  @override
  void initState() {
    super.initState();
    final settings = widget.engine.settings;
    
    _focusController = TextEditingController(text: settings.focusDuration.toString());
    _shortBreakController = TextEditingController(text: settings.shortBreakDuration.toString());
    _longBreakController = TextEditingController(text: settings.longBreakDuration.toString());
    _customController = TextEditingController(text: settings.customDuration.toString());
    _sessionsController = TextEditingController(text: settings.focusSessionsBeforeLongBreak.toString());
    
    _autoAdvance = settings.autoAdvance;
    _notificationsEnabled = settings.notificationsEnabled;
    _accentColor = Color(settings.accentColorValue);
  }

  @override
  void dispose() {
    _focusController.dispose();
    _shortBreakController.dispose();
    _longBreakController.dispose();
    _customController.dispose();
    _sessionsController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final newSettings = widget.engine.settings.copyWith(
      focusDuration: int.tryParse(_focusController.text) ?? 25,
      shortBreakDuration: int.tryParse(_shortBreakController.text) ?? 5,
      longBreakDuration: int.tryParse(_longBreakController.text) ?? 15,
      customDuration: int.tryParse(_customController.text) ?? 10,
      focusSessionsBeforeLongBreak: int.tryParse(_sessionsController.text) ?? 4,
      autoAdvance: _autoAdvance,
      notificationsEnabled: _notificationsEnabled,
      accentColorValue: _accentColor.value,
    );

    widget.engine.updateSettings(newSettings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Durations (minutes)'),
              const SizedBox(height: 16),
              _buildDurationField('Focus', _focusController),
              const SizedBox(height: 12),
              _buildDurationField('Short Break', _shortBreakController),
              const SizedBox(height: 12),
              _buildDurationField('Long Break', _longBreakController),
              const SizedBox(height: 12),
              _buildDurationField('Custom', _customController),
              const SizedBox(height: 32),
              _buildSectionTitle('Pomodoro Settings'),
              const SizedBox(height: 16),
              _buildDurationField('Focus sessions before long break', _sessionsController),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Auto-advance to next phase'),
                value: _autoAdvance,
                onChanged: (value) {
                  setState(() {
                    _autoAdvance = value;
                  });
                },
                activeColor: _accentColor,
              ),
              SwitchListTile(
                title: const Text('Enable notifications'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: _accentColor,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Accent Color'),
              const SizedBox(height: 16),
              _buildColorPicker(),
              const SizedBox(height: 32),
              _buildPresetButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildDurationField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _accentColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _colorOptions.map((color) {
        final isSelected = color.value == _accentColor.value;
        return GestureDetector(
          onTap: () {
            setState(() {
              _accentColor = color;
            });
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPresetButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Presets'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _focusController.text = '25';
              _shortBreakController.text = '5';
              _longBreakController.text = '15';
            });
          },
          child: const Text('25/5 Preset'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _focusController.text = '50';
              _shortBreakController.text = '10';
              _longBreakController.text = '20';
            });
          },
          child: const Text('50/10 Preset'),
        ),
      ],
    );
  }
}
