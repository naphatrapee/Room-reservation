import 'package:flutter/foundation.dart';
import '../models/room.dart';
import '../services/room_service.dart';

class RoomProvider extends ChangeNotifier {
  final RoomService service;
  RoomProvider(this.service);

  List<Room> rooms = [];
  bool loading = false;
  String? error;

  Future<void> fetchToday() async {
    loading = true; error = null; notifyListeners();
    try {
      rooms = await service.listRoomsForToday();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }
}
