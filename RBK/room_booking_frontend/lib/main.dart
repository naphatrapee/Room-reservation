import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/services/api_client.dart';
import 'core/services/room_service.dart';
import 'core/state/room_provider.dart';
import 'core/state/booking_provider.dart';

void main() {
  // Using a MockApiClient for now; replace with real base URL when backend is ready.
  final api = MockApiClient();
  runApp(MultiProvider(
    providers: [
      Provider<ApiClient>(create: (_) => api),
      Provider<RoomService>(create: (ctx) => RoomService(ctx.read<ApiClient>())),
      ChangeNotifierProvider(create: (ctx) => RoomProvider(ctx.read<RoomService>())),
      ChangeNotifierProvider(create: (_) => BookingProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }
}
