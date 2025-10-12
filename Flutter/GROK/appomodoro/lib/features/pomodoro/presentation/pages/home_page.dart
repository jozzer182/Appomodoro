import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/engine.dart';
import '../../domain/models.dart';
import '../widgets/dial_painter.dart';
import '../widgets/control_bar.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<PomodoroEngine>();
    final state = engine.state;
    final settings = engine.settings;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    if (isTablet) {
      return Scaffold(
        backgroundColor: const Color(0xFF111214),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _phaseName(state.currentPhase),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.4,
                        child: CustomPaint(
                          painter: DialPainter(
                            elapsedSeconds: engine.elapsedSeconds,
                            accentColor: settings.accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Semantics(
                        label: 'Time remaining ${state.minutes} minutes ${state.seconds} seconds',
                        child: Text(
                          '${state.minutes.toString().padLeft(2, '0')}:${state.seconds.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: settings.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ControlBar(
                      engine: engine,
                      onSettingsPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color(0xFF111214),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _phaseName(state.currentPhase),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        child: CustomPaint(
                          painter: DialPainter(
                            elapsedSeconds: engine.elapsedSeconds,
                            accentColor: settings.accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Semantics(
                        label: 'Time remaining ${state.minutes} minutes ${state.seconds} seconds',
                        child: Text(
                          '${state.minutes.toString().padLeft(2, '0')}:${state.seconds.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: settings.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ControlBar(
                engine: engine,
                onSettingsPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }
  }  String _phaseName(Phase phase) {
    switch (phase) {
      case Phase.focus:
        return 'Focus';
      case Phase.shortBreak:
        return 'Short Break';
      case Phase.longBreak:
        return 'Long Break';
      case Phase.custom:
        return 'Custom';
    }
  }
}