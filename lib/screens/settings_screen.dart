import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF080816),

      bottomNavigationBar: const BottomNav(
        currentIndex: 3,
      ),

      body: const Center(
        child: Text(
          "Settings Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}