import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/models/enums.dart';
import '../core/state/room_provider.dart';
import 'room_card.dart';

class GenericRoomPage extends StatefulWidget {
  final UserRole role;
  const GenericRoomPage({super.key, required this.role});

  @override
  State<GenericRoomPage> createState() => _GenericRoomPageState();
}

class _GenericRoomPageState extends State<GenericRoomPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RoomProvider>().fetchToday());
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RoomProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('${widget.role.name.toUpperCase()} Rooms')),
      body: Builder(
        builder: (_) {
          if (p.loading) return const Center(child: CircularProgressIndicator());
          if (p.error != null) return Center(child: Text(p.error!));
          if (p.rooms.isEmpty) return const Center(child: Text('No rooms'));

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (final r in p.rooms)
                RoomCard(
                  room: r,
                  role: widget.role,
                  onBooking: widget.role == UserRole.student
                    ? () => context.go('/student/room/slot/${r.id}')
                    : null,
                  onSeeDetails: widget.role != UserRole.student
                    ? () {
                        final base = widget.role == UserRole.staff ? '/staff' : '/lecturer';
                        context.go('$base/room/slot/${r.id}');
                      }
                    : null,
                  onEdit: widget.role == UserRole.staff ? () {} : null,
                  onDisable: widget.role == UserRole.staff ? () {} : null,
                  onHistory: () {},
                  onRequest: () {},
                ),
            ],
          );
        },
      ),
    );
  }
}
