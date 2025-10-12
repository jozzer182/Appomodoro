import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/engine.dart';
import '../../domain/models.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late PomodoroSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = context.read<PomodoroEngine>().settings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111214),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF111214),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTimeSetting('Focus Duration', _settings.focusMinutes, (value) {
            setState(() => _settings = _settings.copyWith(focusMinutes: value));
          }),
          _buildTimeSetting('Short Break', _settings.shortBreakMinutes, (value) {
            setState(() => _settings = _settings.copyWith(shortBreakMinutes: value));
          }),
          _buildTimeSetting('Long Break', _settings.longBreakMinutes, (value) {
            setState(() => _settings = _settings.copyWith(longBreakMinutes: value));
          }),
          _buildTimeSetting('Custom', _settings.customMinutes, (value) {
            setState(() => _settings = _settings.copyWith(customMinutes: value));
          }),
          SwitchListTile(
            title: const Text('Auto Advance', style: TextStyle(color: Colors.white)),
            value: _settings.autoAdvance,
            onChanged: (value) {
              setState(() => _settings = _settings.copyWith(autoAdvance: value));
            },
          ),
          SwitchListTile(
            title: const Text('Notifications', style: TextStyle(color: Colors.white)),
            value: _settings.notificationsEnabled,
            onChanged: (value) {
              setState(() => _settings = _settings.copyWith(notificationsEnabled: value));
            },
          ),
          ListTile(
            title: const Text('Accent Color', style: TextStyle(color: Colors.white)),
            trailing: Container(
              width: 24,
              height: 24,
              color: _settings.accentColor,
            ),
            onTap: _selectColor,
          ),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSetting(String label, int value, ValueChanged<int> onChanged) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          Text('$value min', style: const TextStyle(color: Colors.white)),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _selectColor() {
    // Simple color picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final color in [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple])
              ListTile(
                leading: Container(width: 24, height: 24, color: color),
                title: Text(color.toString()),
                onTap: () {
                  setState(() => _settings = _settings.copyWith(accentColor: color));
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _save() {
    context.read<PomodoroEngine>().updateSettings(_settings);
    Navigator.pop(context);
  }
}