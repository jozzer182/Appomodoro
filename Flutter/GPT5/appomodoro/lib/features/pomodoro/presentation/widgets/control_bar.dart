import 'package:flutter/material.dart';

class ControlBar extends StatelessWidget {
  const ControlBar({
    super.key,
    required this.isRunning,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onReset,
    required this.onNext,
  });

  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    Widget primary;
    if (!isRunning) {
      primary = _pill(
        context,
        label: 'Start',
        onPressed: onStart,
        bg: color.primary,
      );
    } else {
      primary = _pill(
        context,
        label: 'Pause',
        onPressed: onPause,
        bg: color.secondary,
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        primary,
        if (!isRunning)
          _pill(
            context,
            label: 'Resume',
            onPressed: onResume,
            bg: color.tertiary,
          ),
        _pill(
          context,
          label: 'Reset',
          onPressed: onReset,
          bg: Colors.grey.shade700,
        ),
        _pill(context, label: 'Next', onPressed: onNext, bg: color.primary),
      ],
    );
  }

  Widget _pill(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
    required Color bg,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: const StadiumBorder(),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
