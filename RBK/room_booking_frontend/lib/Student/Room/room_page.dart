import 'package:flutter/material.dart';
import '../../core/models/enums.dart';
import '../../Widget/room_page.dart' as generic;

class RoomPage extends StatelessWidget {
  final UserRole role;
  const RoomPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return generic.GenericRoomPage(role: role);
  }
}
