import 'package:flutter/material.dart';
import '../../domain/engine.dart';

class ControlBar extends StatelessWidget {
  final PomodoroEngine engine;
  final VoidCallback onSettingsPressed;

  const ControlBar({super.key, required this.engine, required this.onSettingsPressed});

  @override
  Widget build(BuildContext context) {
    final state = engine.state;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!state.isRunning)
          ElevatedButton(
            onPressed: engine.start,
            child: const Text('Start'),
          )
        else if (state.isPaused)
          ElevatedButton(
            onPressed: engine.resume,
            child: const Text('Resume'),
          )
        else
          ElevatedButton(
            onPressed: engine.pause,
            child: const Text('Pause'),
          ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: engine.reset,
          child: const Text('Reset'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: engine.nextPhase,
          child: const Text('Next'),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: onSettingsPressed,
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}