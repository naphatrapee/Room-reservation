import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/room_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, int>? counts;
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { loading = true; error = null; });
    try {
      counts = await context.read<RoomService>().dashboardCounts(DateTime.now());
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Dashboard (Today)')),
      body: loading
        ? const Center(child: CircularProgressIndicator())
        : error != null
          ? Center(child: Text(error!))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 16, runSpacing: 16,
                children: [
                  _stat('Free', counts!['free']!),
                  _stat('Pending', counts!['pending']!),
                  _stat('Reserved', counts!['reserved']!),
                  _stat('Disabled', counts!['disabled']!),
                ],
              ),
            ),
    );
  }

  Widget _stat(String label, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$value', style: const TextStyle(fontSize: 28)),
          ],
        ),
      ),
    );
  }
}
