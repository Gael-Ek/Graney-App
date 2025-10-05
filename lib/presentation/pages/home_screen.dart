import 'package:flutter/material.dart';
import 'package:graney/graney/bloom_analysis/presentation/pages/home_page.dart';
import '../widgets/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(
        onClose: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
        onItemSelected: (index) {
          setState(() {});
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
      body: const HomePage(),
    );
  }
}
