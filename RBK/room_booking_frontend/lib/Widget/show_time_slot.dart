import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/enums.dart';
import '../core/services/room_service.dart';
import '../core/state/booking_provider.dart';

class ShowTimeSlotPage extends StatefulWidget {
  final String roomId;
  final UserRole role;
  final DateTime date;
  const ShowTimeSlotPage({super.key, required this.roomId, required this.role, required this.date});

  @override
  State<ShowTimeSlotPage> createState() => _ShowTimeSlotPageState();
}

class _ShowTimeSlotPageState extends State<ShowTimeSlotPage> {
  Map<String, String>? slots;
  bool loading = true;
  String? error;
  bool meBookedToday = false;

  static const codes = ['08_10','10_12','13_15','15_17'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { loading = true; error = null; });
    final svc = context.read<RoomService>();
    try {
      final m = await svc.fetchSlots(widget.roomId, widget.date);
      final booked = await svc.meBookedToday();
      setState(() { slots = m; meBookedToday = booked; });
      context.read<BookingProvider>().setBooked(booked);
    } catch (e) {
      setState(() { error = e.toString(); });
    } finally {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = now.year == widget.date.year && now.month == widget.date.month && now.day == widget.date.day;

    return Scaffold(
      appBar: AppBar(title: Text(widget.role == UserRole.student ? 'Book time slot' : 'Room details')),
      body: loading
        ? const Center(child: CircularProgressIndicator())
        : error != null
          ? Center(child: Text(error!))
          : ListView(
              children: codes.map((code) {
                final label = _label(code);
                final st = slots![code] ?? 'free';
                final slotStart = _startForCode(widget.date, code);
                final inFuture = now.isBefore(slotStart);
                final canBook = widget.role == UserRole.student
                    && isToday && inFuture && !meBookedToday && st == 'free';

                return ListTile(
                  title: Text('$label • ${st.toUpperCase()}'),
                  trailing: widget.role == UserRole.student
                    ? ElevatedButton(
                        onPressed: canBook ? () async {
                          try {
                            await context.read<RoomService>().book(widget.roomId, widget.date, code);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booked (pending)')));
                            await _load();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        } : null,
                        child: const Text('Book'),
                      )
                    : null,
                );
              }).toList(),
            ),
    );
  }

  String _label(String code) {
    switch (code) {
      case '08_10': return '08:00 - 10:00';
      case '10_12': return '10:00 - 12:00';
      case '13_15': return '13:00 - 15:00';
      case '15_17': return '15:00 - 17:00';
    }
    return code;
    }

  DateTime _startForCode(DateTime d, String code) {
    switch (code) {
      case '08_10': return DateTime(d.year, d.month, d.day, 8);
      case '10_12': return DateTime(d.year, d.month, d.day, 10);
      case '13_15': return DateTime(d.year, d.month, d.day, 13);
      case '15_17': return DateTime(d.year, d.month, d.day, 15);
    }
    return d;
  }
}
