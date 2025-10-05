import 'package:flutter/material.dart';
import 'package:graney/graney/cummunity/presentation/providers/community_provider.dart';
import 'package:graney/presentation/pages/home_screen.dart';
import 'package:graney/presentation/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:graney/graney/bloom_analysis/presentation/providers/bloom_analysis_provider.dart';
import 'package:graney/graney/statistics/presentation/providers/stats_provider.dart';
import 'package:graney/graney/timeline/presentation/providers/timeline_provider.dart';

import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BloomAnalysisProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
        ChangeNotifierProvider(create: (_) => TimelineProvider()),
      ],
      child: MaterialApp(
        title: 'Graney - Monitoreo de Floración',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _opacity = 0.0;
        });

        Timer(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.eco, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'Graney',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Monitoreo Inteligente',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: .9),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
