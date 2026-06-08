import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/bottom_nav.dart';
import '../models/audiobook.dart';
import '../data/audiobooks.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Audiobook? selectedBook;
  final TextEditingController controller = TextEditingController();

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

  void _addManualNote() {
  controller.clear();
  selectedBook = null;

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setStateDialog) {
        return AlertDialog(
          backgroundColor: const Color(0xFF141428),
          title: const Text(
            "New Note",
            style: TextStyle(color: Colors.white),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // TEXT
              TextField(
                controller: controller,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Write your note...",
                  hintStyle: TextStyle(color: Colors.white38),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // BOOK SELECT
              DropdownButton<Audiobook>(
                dropdownColor: const Color(0xFF1C1C2E),
                value: selectedBook,
                hint: const Text(
                  "Select audiobook",
                  style: TextStyle(color: Colors.white38),
                ),
                items: audiobooks.map((book) {
                  return DropdownMenuItem(
                    value: book,
                    child: Text(
                      book.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setStateDialog(() {
                    selectedBook = value;
                  });
                },
              ),

              const SizedBox(height: 12),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              onPressed: () {
                final text = controller.text.trim();

                if (text.isNotEmpty && selectedBook != null) {
                  setState(() {
                    NotesRepository.addNote(
                      Note(
                        text: text,
                        audiobookTitle: selectedBook!.title,
                        timestamp: 0,
                      ),
                    );
                  });
                }

                Navigator.pop(ctx);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final notes = NotesRepository.notes;

    return Scaffold(
      backgroundColor: const Color(0xFF080816),
      
      appBar: AppBar(
        title: const Text("My Notes", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF141428),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _addManualNote,
          ),
        ],
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