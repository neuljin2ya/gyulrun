import 'package:flutter/material.dart';
import 'package:gyulrun/screen/free_run_summary_screen.dart';
import 'package:gyulrun/screen/history_screen.dart';
import 'package:gyulrun/screen/home_screen.dart';
import 'package:gyulrun/screen/landing_screen.dart';
import 'package:gyulrun/screen/running_screen.dart';
import 'package:gyulrun/model/course.dart';
import 'package:gyulrun/model/run_result.dart';
import 'package:gyulrun/screen/run_complete_screen.dart';

abstract final class AppRoutes {
  static const landing = '/landing';
  static const home = '/';
  static const history = '/history';
  static const running = '/running';
  static const freeRunSummary = '/free-run-summary';
  static const runComplete = '/run-complete';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      landing => const LandingScreen(),
      history => const HistoryScreen(),
      running => RunningScreen(
        courseName: switch (settings.arguments) {
          Course course => course.name,
          String name => name,
          _ => '자유런',
        },
        hasGuideRoute: settings.arguments is Course,
        targetDistanceKm: switch (settings.arguments) {
          Course course => course.distanceKm,
          _ => 0,
        },
        guideRoute: switch (settings.arguments) {
          Course course => course.route,
          _ => const [],
        },
        nearbyPlaces: switch (settings.arguments) {
          Course course => course.nearbyPlaces,
          _ => const [],
        },
      ),
      runComplete => RunCompleteScreen(
        result: settings.arguments! as RunResult,
      ),
      freeRunSummary => FreeRunSummaryScreen(
        result: settings.arguments! as RunResult,
      ),
      _ => const HomeScreen(),
    };

    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (_, _, _) => page,
    );
  }

  static void replace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }
}
