import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appomodoro/features/pomodoro/presentation/pages/home_page.dart';

class ControlBar extends ConsumerWidget {
  const ControlBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(pomodoroEngineProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if (engine.state.isRunning) {
              ref.read(pomodoroEngineProvider.notifier).pause();
            } else {
              ref.read(pomodoroEngineProvider.notifier).resume();
            }
          },
          child: Text(engine.state.isRunning ? 'Pause' : 'Resume'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
             ref.read(pomodoroEngineProvider.notifier).start();
          },
          child: const Text('Start'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            ref.read(pomodoroEngineProvider.notifier).reset();
          },
          child: const Text('Reset'),
        ),
      ],
    );
  }
}
