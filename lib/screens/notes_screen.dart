import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF080816),

      bottomNavigationBar: const BottomNav(
        currentIndex: 2,
      ),

      body: const Center(
        child: Text(
          "Notes Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}