import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF080816),

      bottomNavigationBar: const BottomNav(
        currentIndex: 1,
      ),

      body: const Center(
        child: Text(
          "Player Screen",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}