import '../models/room.dart';
import '../models/enums.dart';
import 'api_client.dart';

class RoomService {
  final ApiClient api;
  RoomService(this.api);

  Future<List<Room>> listRoomsForToday() async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final data = await api.get('/rooms?date=$today');
    return (data as List).map((e) => Room(
      id: e['id'],
      name: e['name'],
      capacity: e['capacity'],
      status: e['status'] == 'disabled' ? RoomStatus.disabled : RoomStatus.active,
    )).toList();
  }

  Future<Map<String, String>> fetchSlots(String roomId, DateTime date) async {
    final d = date.toIso8601String().split('T').first;
    final m = await api.get('/rooms/$roomId/slots?date=$d') as Map;
    return m.map((k, v) => MapEntry(k as String, v as String));
  }

  Future<bool> meBookedToday() async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final resp = await api.get('/bookings/me?date=$today') as Map<String, dynamic>;
    return resp['booked'] == true;
  }

  Future<void> book(String roomId, DateTime date, String slotCode) async {
    final d = date.toIso8601String().split('T').first;
    await api.post('/bookings', {'roomId': roomId, 'date': d, 'slot': slotCode});
  }

  Future<Map<String, int>> dashboardCounts(DateTime date) async {
    final d = date.toIso8601String().split('T').first;
    final resp = await api.get('/dashboard?date=$d') as Map<String, dynamic>;
    return {
      'free': resp['free'] as int,
      'pending': resp['pending'] as int,
      'reserved': resp['reserved'] as int,
      'disabled': resp['disabled'] as int,
    };
  }
}
