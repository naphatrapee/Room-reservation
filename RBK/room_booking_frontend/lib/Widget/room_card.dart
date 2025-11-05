import 'package:flutter/material.dart';
import '../core/models/enums.dart';
import '../core/models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final UserRole role;
  final VoidCallback? onSeeDetails;
  final VoidCallback? onBooking;
  final VoidCallback? onEdit;
  final VoidCallback? onDisable;
  final VoidCallback? onHistory;
  final VoidCallback? onRequest;

  const RoomCard({
    super.key,
    required this.room,
    required this.role,
    this.onSeeDetails,
    this.onBooking,
    this.onEdit,
    this.onDisable,
    this.onHistory,
    this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];

    switch (role) {
      case UserRole.student:
        actions.addAll([
          if (onBooking != null) ElevatedButton(onPressed: onBooking, child: const Text('Book')),
          if (onHistory != null) OutlinedButton(onPressed: onHistory, child: const Text('History')),
          if (onRequest != null) TextButton(onPressed: onRequest, child: const Text('Request')),
        ]);
        break;
      case UserRole.staff:
        actions.addAll([
          if (onSeeDetails != null) ElevatedButton(onPressed: onSeeDetails, child: const Text('See details')),
          if (onEdit != null) OutlinedButton(onPressed: onEdit, child: const Text('Edit')),
          if (onDisable != null) TextButton(onPressed: onDisable, child: const Text('Disable')),
          if (onHistory != null) TextButton(onPressed: onHistory, child: const Text('History(all)')),
        ]);
        break;
      case UserRole.lecturer:
        actions.addAll([
          if (onSeeDetails != null) ElevatedButton(onPressed: onSeeDetails, child: const Text('See details')),
          if (onHistory != null) OutlinedButton(onPressed: onHistory, child: const Text('My History')),
          if (onRequest != null) TextButton(onPressed: onRequest, child: const Text('Request')),
        ]);
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(room.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('Capacity: ${room.capacity}'),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: actions),
          ],
        ),
      ),
    );
  }
}
