import 'dart:async';
import 'dart:collection';
import '../models/enums.dart';
import '../models/room.dart';

abstract class ApiClient {
  Future<dynamic> get(String path);
  Future<dynamic> post(String path, Map<String, dynamic> body);
  Future<dynamic> put(String path, Map<String, dynamic> body);
}

// Simple in-memory mock to let the frontend run on simulator.
class MockApiClient implements ApiClient {
  final Map<String, Room> _rooms = {
    'r1': Room(id: 'r1', name: 'Room A', capacity: 10, status: RoomStatus.active),
    'r2': Room(id: 'r2', name: 'Room B', capacity: 20, status: RoomStatus.active),
    'r3': Room(id: 'r3', name: 'Room C', capacity: 15, status: RoomStatus.active),
  };

  // slots[date][roomId][slotCode] = SlotStatus
  final Map<String, Map<String, Map<String, SlotStatus>>> _slots = {};
  // simplistic tracking: user 'student1' booked today?
  final Map<String, Set<String>> _userBookedByDate = {}; // date -> set(userId)

  static const slotCodes = ['08_10','10_12','13_15','15_17'];

  String _dateKey(DateTime d) => d.toIso8601String().split('T').first;

  void _ensureDate(DateTime date) {
    final key = _dateKey(date);
    _slots.putIfAbsent(key, () => {});
    for (final r in _rooms.values) {
      _slots[key]!.putIfAbsent(r.id, () => {});
      for (final code in slotCodes) {
        _slots[key]![r.id]!.putIfAbsent(code, () => SlotStatus.free);
      }
    }
    _userBookedByDate.putIfAbsent(key, () => <String>{});
  }

  @override
  Future get(String path) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (path.startsWith('/rooms?date=')) {
      final dateStr = path.split('=')[1];
      final date = DateTime.parse(dateStr);
      _ensureDate(date);
      return _rooms.values.map((r) => {
        'id': r.id, 'name': r.name, 'capacity': r.capacity,
        'status': r.status == RoomStatus.active ? 'active' : 'disabled',
      }).toList();
    }

    if (path.startsWith('/rooms/') && path.contains('/slots?date=')) {
      final segs = path.split('/');
      final roomId = segs[2];
      final dateStr = path.split('=')[1];
      final date = DateTime.parse(dateStr);
      _ensureDate(date);
      final m = _slots[_dateKey(date)]![roomId]!;
      return m.map((k, v) => MapEntry(k, v.name));
    }

    if (path.startsWith('/bookings/me?date=')) {
      final dateStr = path.split('=')[1];
      final date = DateTime.parse(dateStr);
      _ensureDate(date);
      final booked = _userBookedByDate[_dateKey(date)]!.contains('student1');
      return {'booked': booked};
    }

    if (path.startsWith('/dashboard?date=')) {
      final dateStr = path.split('=')[1].split('&')[0];
      final date = DateTime.parse(dateStr);
      _ensureDate(date);
      int free = 0, pending = 0, reserved = 0, disabled = 0;
      final map = _slots[_dateKey(date)]!;
      for (final roomId in map.keys) {
        for (final st in map[roomId]!.values) {
          switch (st) {
            case SlotStatus.free: free++; break;
            case SlotStatus.pending: pending++; break;
            case SlotStatus.reserved: reserved++; break;
            case SlotStatus.disabled: disabled++; break;
          }
        }
      }
      return {'free': free, 'pending': pending, 'reserved': reserved, 'disabled': disabled};
    }

    throw UnimplementedError('GET $path not implemented in mock');
  }

  @override
  Future post(String path, Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (path == '/bookings') {
      final roomId = body['roomId'] as String;
      final date = DateTime.parse(body['date'] as String);
      final slot = body['slot'] as String;
      _ensureDate(date);
      // "today only" rule
      final now = DateTime.now();
      if (!(now.year == date.year && now.month == date.month && now.day == date.day)) {
        throw Exception('Only bookings for today are allowed');
      }
      // one per day per user
      if (_userBookedByDate[_dateKey(date)]!.contains('student1')) {
        throw Exception('User already booked a slot today');
      }
      // slot must be free
      if (_slots[_dateKey(date)]![roomId]![slot] != SlotStatus.free) {
        throw Exception('Slot is not free');
      }
      _slots[_dateKey(date)]![roomId]![slot] = SlotStatus.pending;
      _userBookedByDate[_dateKey(date)]!.add('student1');
      return {'ok': true};
    }

    throw UnimplementedError('POST $path not implemented in mock');
  }

  @override
  Future put(String path, Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw UnimplementedError('PUT $path not implemented in mock');
  }
}
