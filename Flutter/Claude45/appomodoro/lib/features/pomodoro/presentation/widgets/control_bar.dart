import 'package:flutter/material.dart';

class ControlBar extends StatelessWidget {
  final bool isRunning;
  final bool isPaused;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;
  final VoidCallback onNext;

  const ControlBar({
    super.key,
    required this.isRunning,
    required this.isPaused,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onReset,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        if (!isRunning)
          _buildButton(
            context,
            icon: Icons.play_arrow,
            label: 'Start',
            onPressed: onStart,
            isPrimary: true,
          )
        else if (isPaused)
          _buildButton(
            context,
            icon: Icons.play_arrow,
            label: 'Resume',
            onPressed: onResume,
            isPrimary: true,
          )
        else
          _buildButton(
            context,
            icon: Icons.pause,
            label: 'Pause',
            onPressed: onPause,
            isPrimary: true,
          ),
        _buildButton(
          context,
          icon: Icons.refresh,
          label: 'Reset',
          onPressed: onReset,
        ),
        _buildButton(
          context,
          icon: Icons.skip_next,
          label: 'Next',
          onPressed: onNext,
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? accentColor.withOpacity(0.2)
            : theme.colorScheme.surface,
        foregroundColor: isPrimary ? accentColor : theme.textTheme.bodyLarge?.color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: isPrimary
              ? BorderSide(color: accentColor, width: 1.5)
              : BorderSide.none,
        ),
      ),
    );
  }
}
