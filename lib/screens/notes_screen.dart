import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/bottom_nav.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  void _editNote(Note note) {
    final controller = TextEditingController(text: note.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141428),
        title: const Text("Edit Note", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text("Cancel")
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
            onPressed: () {
              setState(() {
                NotesRepository.updateNote(note.id, controller.text.trim());
              });
              Navigator.pop(ctx);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteNote(String id) {
    setState(() {
      NotesRepository.deleteNote(id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note deleted')),
    );
  }

  String _formatTime(double minutes) {
    final int mins = minutes.floor();
    final int secs = ((minutes - mins) * 60).round();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final notes = NotesRepository.notes;

    return Scaffold(
      backgroundColor: const Color(0xFF080816),
      appBar: AppBar(
        title: const Text("My Notes", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF141428),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                "No notes yet.\nListen to an audiobook and record some notes!",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  color: const Color(0xFF1E1E3A),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${note.audiobookTitle} • ${_formatTime(note.timestamp)}",
                              style: const TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                                  onPressed: () => _editNote(note),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () => _deleteNote(note.id),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          note.text,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Created ${note.createdAt.month}/${note.createdAt.day}/${note.createdAt.year}",
                          style: const TextStyle(color: Colors.white38, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}