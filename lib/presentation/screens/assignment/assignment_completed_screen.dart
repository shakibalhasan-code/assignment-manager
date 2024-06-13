import 'package:flutter/material.dart';

import '../../widgets/app_background_widget.dart';
import '../../widgets/profile_app_bar.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: const AppBackgroundWidget(
        child: Center(
          child: Text('Completed Screen'),
        ),
      ),
    );
  }
}