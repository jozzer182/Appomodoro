import 'package:flutter/material.dart';
import '../../domain/engine.dart';
import '../../domain/models.dart';
import '../widgets/dial_painter.dart';
import '../widgets/control_bar.dart';
import '../../../../core/responsive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late PomodoroEngine engine;

  @override
  void initState() {
    super.initState();
    engine = PomodoroEngine()..init();
    engine.addListener(_onChange);
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    engine.removeListener(_onChange);
    engine.disposeEngine();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isTablet = c.isTablet;
        final accent = Theme.of(context).colorScheme.primary;
        final dial = _buildDial(context, accent);
        final controls = _buildControls(context);
        if (isTablet) {
          return Row(
            children: [
              Expanded(child: dial),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      controls,
                      const SizedBox(height: 24),
                      _phaseChips(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                dial,
                const SizedBox(height: 24),
                controls,
                const SizedBox(height: 16),
                _phaseChips(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDial(BuildContext context, Color accent) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Semantics(
            label: 'Rotating dial',
            child: CustomPaint(
              painter: DialPainter(
                thetaS: engine.thetaS,
                thetaM: engine.thetaM,
                accent: accent,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Center(child: _centerReadout(context)),
        ],
      ),
    );
  }

  Widget _centerReadout(BuildContext context) {
    final rem = engine.remaining;
    final mm = rem.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = rem.inSeconds.remainder(60).toString().padLeft(2, '0');
    final color = Theme.of(context).colorScheme.primary;
    return Semantics(
      label: 'Time remaining $mm minutes $ss seconds',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            mm,
            style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              ss,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return ControlBar(
      isRunning: engine.isRunning,
      onStart: engine.start,
      onPause: engine.pause,
      onResume: engine.resume,
      onReset: engine.reset,
      onNext: engine.nextPhase,
    );
  }

  Widget _phaseChips() {
    Widget chip(String label, Phase p) {
      final selected = engine.phase == p;
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          if (p == Phase.custom) {
            engine.setCustom(const Duration(minutes: 20));
          } else {
            engine.setPhase(p);
          }
          setState(() {});
        },
      );
    }

    return Wrap(
      spacing: 8,
      children: [
        chip('Focus', Phase.focus),
        chip('Short', Phase.shortBreak),
        chip('Long', Phase.longBreak),
        chip('Custom', Phase.custom),
      ],
    );
  }
}
