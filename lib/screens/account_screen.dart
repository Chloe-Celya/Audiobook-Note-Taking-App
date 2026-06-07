import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _authService = AuthService();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = _authService.currentUser?.displayName ?? '';
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      await _authService.updateProfile(displayName: _nameController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e}")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updatePassword() async {
    if (_passwordController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await _authService.updatePassword(_passwordController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password updated")));
        _passwordController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e}")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141428),
        title: const Text("Delete Account", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure? This action cannot be undone.", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text("Delete", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _authService.deleteAccount();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e}")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF080816),
      appBar: AppBar(
        title: const Text("Account Manager", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF141428),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text("Email: ${user?.email ?? 'Unknown'}", style: const TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Display Name",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                  child: const Text("Update Profile", style: TextStyle(color: Colors.white)),
                ),
                const Divider(color: Colors.grey, height: 48),
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updatePassword,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                  child: const Text("Update Password", style: TextStyle(color: Colors.white)),
                ),
                const Divider(color: Colors.grey, height: 48),
                ElevatedButton(
                  onPressed: _deleteAccount,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete Account", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () async {
                    await _authService.signOut();
                  },
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.deepPurpleAccent)),
                  child: const Text("Logout", style: TextStyle(color: Colors.deepPurpleAccent)),
                ),
              ],
            ),
          ),
    );
  }
}
