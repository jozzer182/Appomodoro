import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appomodoro/features/pomodoro/domain/engine.dart';
import 'package:appomodoro/features/pomodoro/presentation/widgets/dial_painter.dart';
import 'package:appomodoro/features/pomodoro/presentation/widgets/control_bar.dart';
import 'package:appomodoro/core/responsive.dart';
import 'package:appomodoro/features/pomodoro/presentation/pages/settings_page.dart';

final pomodoroEngineProvider = ChangeNotifierProvider((ref) => PomodoroEngine());

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(pomodoroEngineProvider);
    final state = engine.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appomodoro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (Responsive.isMobile(context)) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomPaint(
                      size: Size(constraints.maxWidth * 0.8, constraints.maxWidth * 0.8),
                      painter: DialPainter(
                        remainingTime: state.remainingTime,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ControlBar(),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    child: CustomPaint(
                      size: Size(constraints.maxHeight * 0.8, constraints.maxHeight * 0.8),
                      painter: DialPainter(
                        remainingTime: state.remainingTime,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ControlBar(),
                        // Settings can be shown here for tablet layout
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
