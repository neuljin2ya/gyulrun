import 'package:flutter/material.dart';
import 'package:gyulrun/navigation/app_routes.dart';

void main() {
  runApp(const GyulrunApp());
}

class GyulrunApp extends StatelessWidget {
  const GyulrunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gyul Run',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFBAFF29)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.landing,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
