import 'package:flutter/material.dart';

class SelectorWindow extends StatelessWidget {
  const SelectorWindow({
    super.key,
    required this.child,
    required this.alignment,
  });
  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        child: child,
      ),
    );
  }
}
