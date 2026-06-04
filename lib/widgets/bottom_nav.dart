import 'package:flutter/material.dart';

import '../screens/library_screen.dart';
import '../screens/player_screen.dart';
import '../screens/notes_screen.dart';
import '../screens/settings_screen.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {

    if (index == currentIndex) return;

    Widget destination;

    switch (index) {

      case 0:
        destination = const LibraryScreen();
        break;

      case 1:
        destination = const PlayerScreen();
        break;

      case 2:
        destination = const NotesScreen();
        break;

      case 3:
        destination = const SettingsScreen();
        break;

      default:
        destination = const LibraryScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => destination,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(

      currentIndex: currentIndex,

      selectedItemColor: Colors.deepPurpleAccent,

      unselectedItemColor: Colors.grey,

      backgroundColor: const Color(0xFF141428),

      type: BottomNavigationBarType.fixed,

      onTap: (index) => _onItemTapped(context, index),

      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: "Library",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle),
          label: "Player",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: "Notes",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}