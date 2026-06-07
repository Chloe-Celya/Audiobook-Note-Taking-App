class Note {
  final String id;
  String text;
  final String audiobookTitle;
  final double timestamp;
  final DateTime createdAt;

  Note({
    String? id,
    required this.text,
    required this.audiobookTitle,
    required this.timestamp,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();
}

class NotesRepository {
  static final List<Note> _notes = [];

  static List<Note> get notes => _notes;

  static void addNote(Note note) {
    _notes.insert(0, note);
  }

  static void updateNote(String id, String newText) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index].text = newText;
    }
  }

  static void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
  }
}
