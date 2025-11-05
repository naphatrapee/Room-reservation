import 'package:flutter/foundation.dart';

class BookingProvider extends ChangeNotifier {
  bool hasBookedToday = false;
  void setBooked(bool v) { hasBookedToday = v; notifyListeners(); }
}
