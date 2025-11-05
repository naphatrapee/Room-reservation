import 'enums.dart';

class Room {
  final String id;
  final String name;
  final int capacity;
  final RoomStatus status;

  Room({required this.id, required this.name, required this.capacity, required this.status});
}
