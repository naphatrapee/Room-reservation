import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/models/enums.dart';
import 'Student/Room/room_page.dart' as s_room;
import 'Staff/dashboard.dart' as st_dash;
import 'Lecturer/dashboard.dart' as lec_dash;
import 'Widget/show_time_slot.dart';
import 'Widget/room_page.dart' as generic;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/student/room', // Start at Student Room page as requested
  routes: [
    // Student
    GoRoute(
      path: '/student/room',
      builder: (_, __) => s_room.RoomPage(role: UserRole.student),
      routes: [
        GoRoute(
          path: 'slot/:roomId',
          builder: (ctx, st) => ShowTimeSlotPage(
            roomId: st.pathParameters['roomId']!,
            role: UserRole.student,
            date: DateTime.now(),
          ),
        ),
      ],
    ),

    // Staff
    GoRoute(
      path: '/staff/dashboard',
      builder: (_, __) => const st_dash.DashboardPage(),
    ),
    GoRoute(
      path: '/staff/room',
      builder: (_, __) => const generic.GenericRoomPage(role: UserRole.staff),
      routes: [
        GoRoute(
          path: 'slot/:roomId',
          builder: (ctx, st) => ShowTimeSlotPage(
            roomId: st.pathParameters['roomId']!,
            role: UserRole.staff,
            date: DateTime.now(),
          ),
        ),
      ],
    ),

    // Lecturer
    GoRoute(
      path: '/lecturer/dashboard',
      builder: (_, __) => const lec_dash.DashboardPage(),
    ),
    GoRoute(
      path: '/lecturer/room',
      builder: (_, __) => const generic.GenericRoomPage(role: UserRole.lecturer),
      routes: [
        GoRoute(
          path: 'slot/:roomId',
          builder: (ctx, st) => ShowTimeSlotPage(
            roomId: st.pathParameters['roomId']!,
            role: UserRole.lecturer,
            date: DateTime.now(),
          ),
        ),
      ],
    ),
  ],
);
