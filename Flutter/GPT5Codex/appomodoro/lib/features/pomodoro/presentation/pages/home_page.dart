import 'package:flutter/material.dart';

import '../../../../core/localization.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appTitle),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
