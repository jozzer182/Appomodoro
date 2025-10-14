import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../../core/responsive.dart';
import '../../domain/engine.dart';
import '../../domain/models.dart';
import '../widgets/dial_painter.dart';
import '../widgets/control_bar.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final PomodoroEngine engine;
  final Function(PomodoroPhase phase) onPhaseComplete;

  const HomePage({
    super.key,
    required this.engine,
    required this.onPhaseComplete,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      setState(() {});
    });
    _ticker.start();
    widget.engine.addListener(_onEngineUpdate);
  }

  void _onEngineUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    widget.engine.removeListener(_onEngineUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrLarger = Responsive.isTabletOrLarger(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appomodoro'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(engine: widget.engine),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: isTabletOrLarger
            ? _buildTabletLayout()
            : _buildPhoneLayout(),
      ),
    );
  }

  Widget _buildPhoneLayout() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPhaseSelector(),
            const SizedBox(height: 32),
            _buildDial(),
            const SizedBox(height: 24),
            _buildTimeDisplay(),
            const SizedBox(height: 32),
            ControlBar(
              isRunning: widget.engine.state.isRunning,
              isPaused: widget.engine.state.isPaused,
              onStart: widget.engine.start,
              onPause: widget.engine.pause,
              onResume: widget.engine.resume,
              onReset: widget.engine.reset,
              onNext: () {
                widget.onPhaseComplete(widget.engine.state.currentPhase);
                widget.engine.nextPhase();
              },
            ),
            const SizedBox(height: 24),
            _buildSessionCounter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDial(),
                const SizedBox(height: 24),
                _buildTimeDisplay(),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPhaseSelector(),
                  const SizedBox(height: 32),
                  ControlBar(
                    isRunning: widget.engine.state.isRunning,
                    isPaused: widget.engine.state.isPaused,
                    onStart: widget.engine.start,
                    onPause: widget.engine.pause,
                    onResume: widget.engine.resume,
                    onReset: widget.engine.reset,
                    onNext: () {
                      widget.onPhaseComplete(widget.engine.state.currentPhase);
                      widget.engine.nextPhase();
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSessionCounter(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDial() {
    final dialSize = Responsive.getDialSize(context);
    final elapsedSeconds = widget.engine.getElapsedSeconds();

    return Semantics(
      label: _buildSemanticLabel(),
      child: SizedBox(
        width: dialSize,
        height: dialSize,
        child: CustomPaint(
          painter: DialPainter(
            elapsedSeconds: elapsedSeconds,
            accentColor: Color(widget.engine.settings.accentColorValue),
            backgroundColor: Theme.of(context).colorScheme.surface,
            textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final (minutes, seconds) = widget.engine.getRemainingTime();
    final accentColor = Color(widget.engine.settings.accentColorValue);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          minutes.toString().padLeft(2, '0'),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentColor, width: 1.5),
          ),
          child: Text(
            seconds.toString().padLeft(2, '0'),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 32,
                  color: accentColor,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: PomodoroPhase.values.map((phase) {
        final isSelected = widget.engine.state.currentPhase == phase;
        final accentColor = Color(widget.engine.settings.accentColorValue);

        return ChoiceChip(
          label: Text(phase.displayName),
          selected: isSelected,
          onSelected: widget.engine.state.isRunning
              ? null
              : (selected) {
                  if (selected) {
                    widget.engine.setPhase(phase);
                  }
                },
          selectedColor: accentColor.withOpacity(0.2),
          backgroundColor: Theme.of(context).colorScheme.surface,
          labelStyle: TextStyle(
            color: isSelected ? accentColor : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? accentColor : Colors.transparent,
            width: 1.5,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSessionCounter() {
    return Text(
      'Completed sessions: ${widget.engine.state.completedFocusSessions}',
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }

  String _buildSemanticLabel() {
    final (minutes, seconds) = widget.engine.getRemainingTime();
    return 'Time remaining: $minutes minutes and $seconds seconds';
  }
}
