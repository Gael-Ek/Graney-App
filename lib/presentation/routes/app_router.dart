import 'package:flutter/material.dart';
import 'package:graney/graney/cummunity/presentation/pages/community_screen.dart';
import 'package:graney/graney/statistics/presentation/pages/stats_screen.dart';
import 'package:graney/graney/timeline/presentation/pages/timeline_page.dart';
import 'package:graney/presentation/pages/home_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String community = '/community';
  static const String stats = '/stats';
  static const String timeline = '/timeline';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case community:
        return MaterialPageRoute(builder: (_) => const CommunityScreen());
      case stats:
        return MaterialPageRoute(builder: (_) => const StatsScreen());
      case timeline:
        return MaterialPageRoute(builder: (_) => const TimelinePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
