import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'account_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080816),
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF141428),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const BottomNav(
        currentIndex: 3,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.deepPurpleAccent),
            title: const Text("Account Manager", style: TextStyle(color: Colors.white)),
            subtitle: const Text("Manage your profile, password, or delete account", style: TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountScreen()),
              );
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.deepPurpleAccent),
            title: const Text("Notifications", style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () {
              // Placeholder for notifications
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.deepPurpleAccent),
            title: const Text("About", style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            onTap: () {
              // Placeholder for about screen
            },
          ),
        ],
      ),
    );
  }
}