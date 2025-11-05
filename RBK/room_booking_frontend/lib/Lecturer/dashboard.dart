import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // For demo purpose; filter-by-lecturer can be added with real backend later.
    return const Scaffold(
      appBar: AppBar(title: Text('Lecturer Dashboard (Today)')),
      body: Center(child: Text('Your slots summary will appear here.')),
    );
  }
}
