import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gyulrun/navigation/app_routes.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1400), _goHome);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goHome() {
    if (!mounted) return;
    AppRoutes.replace(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: InkWell(
          onTap: _goHome,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icon/logo.png',
                  width: 210,
                  height: 210,
                  fit: BoxFit.contain,
                  semanticLabel: 'Gyul Run logo',
                ),
                const SizedBox(height: 22),
                const Text(
                  'Gyul Run',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
