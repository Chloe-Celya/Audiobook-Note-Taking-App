import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../models/audiobook.dart';
import '../models/note.dart';
import '../widgets/bottom_nav.dart';

import '../screens/library_screen.dart';

double _playerSpeed = 1.0;
Audiobook? _currentBook;

class PlayerScreen extends StatefulWidget {
  final Audiobook? book;

  const PlayerScreen({super.key, this.book});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool isPlaying = true;
  double sliderValue = 0.00; // minutes
  double totalDuration = 0.00; // minutes
  bool showSpeedMenu = false;

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _currentWords = '';

  final List<double> speedOptions = [0.75, 1.0, 1.25, 1.5, 2.0];

  List<Note> get markers =>
    NotesRepository.notes
        .where((n) => n.audiobookTitle == _currentBook?.title)
        .toList();

  @override
  void initState() {
    super.initState();
    final book = widget.book;
    if (book != null) {
      _currentBook = book;
      totalDuration = book.duration;
    }
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            if (mounted) setState(() => _isListening = false);
            _saveNote();
          }
        },
        onError: (val) {
          debugPrint('Speech error: $val');
          if (mounted) setState(() => _isListening = false);
        },
      );
      if (available) {
        if (mounted) setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            if (mounted) {
              setState(() {
                _currentWords = val.recognizedWords;
              });
            }
          },
        );
      }
    } else {
      if (mounted) setState(() => _isListening = false);
      _speech.stop();
      _saveNote();
    }
  }

  void _saveNote() {
    if (_currentWords.trim().isNotEmpty) {
      NotesRepository.addNote(Note(
        text: _currentWords,
        audiobookTitle: _currentBook?.title ?? 'Unknown',
        timestamp: sliderValue,
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vocal note saved!')),
        );
      }
      _currentWords = '';
    }
  }


  String _formatTime(double minutes) {
    final int mins = minutes.floor();
    final int secs = ((minutes - mins) * 60).round();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _speedLabel(double speed) {
    if (speed == speed.truncateToDouble()) {
      return '${speed.toInt()}x';
    }
    return '${speed}x';
  }

  void _addMarker() {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF141428),

      title: const Text(
        "Add Marker",
        style: TextStyle(color: Colors.white),
      ),

      content: TextField(
        controller: controller,
        maxLines: 4,
        style: const TextStyle(color: Colors.white),

        decoration: const InputDecoration(
          hintText: "Write your note...",
          hintStyle: TextStyle(color: Colors.white38),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () {

            final text = controller.text.trim();

            if (text.isNotEmpty && _currentBook != null) {


              NotesRepository.addNote(
                Note(
                  text: text,
                  audiobookTitle: _currentBook!.title,
                  timestamp: sliderValue,
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Marker saved"),
                ),
              );
            }

            Navigator.pop(ctx);
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final book = _currentBook;

    return Scaffold(
      backgroundColor: const Color(0xFF080816),

      bottomNavigationBar: const BottomNav(
        currentIndex: 1,
      ),

      body: SafeArea(
        child: Stack(
          children: [

            // MAIN CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

                  const SizedBox(height: 12),

                  // TOP BAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LibraryScreen()),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      Row(
                        children: [
                          const Text(
                            'Now Playing',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // BOOK COVER
                  Container(
                    width: 200,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF1E1E3A),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: book != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              book.cover,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.book,
                                color: Colors.white38,
                                size: 80,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.book,
                            color: Colors.white38,
                            size: 80,
                          ),
                  ),

                  const SizedBox(height: 28),

                  // CHAPTER TITLE
                  Text(
                    book != null ? (book.title+" by "+book.author) : 'No audiobook selected',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 16),
                  
                  if (_isListening)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurpleAccent),
                      ),
                      child: Text(
                        _currentWords.isEmpty ? 'Speak now...' : _currentWords,
                        style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // SEEK BAR
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: 40,
                        child: Stack(
                      alignment: Alignment.center,
                      children: [

                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.deepPurpleAccent,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: Colors.deepPurpleAccent,
                            trackHeight: 3.0,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                          ),

                          child: Slider(
                            value: sliderValue,
                            min: 0,
                            max: totalDuration,
                            onChanged: (value) {
                              setState(() {
                                sliderValue = value;
                              });
                            },
                          ),
                        ),

                        // MARKERS 
                        ...NotesRepository.notes
                            .where((n) => n.audiobookTitle == _currentBook?.title)
                            .map((note) {

                          final position = totalDuration == 0
                              ? 0.0
                              : note.timestamp / totalDuration;

                          return Positioned(
                            left: constraints.maxWidth * position,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              ),
                  

                  // TIME LABELS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(sliderValue),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatTime(totalDuration),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // PLAYBACK CONTROLS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isPlaying = !isPlaying;
                            });
                          },
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: const Color(0xFF080816),
                            size: 32,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ACTION BUTTONS ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      // SPEED
                      _ActionButton(
                        label: _speedLabel(_playerSpeed),
                        icon: Icons.speed,
                        isLabelBold: true,
                        onTap: () {
                          setState(() {
                            showSpeedMenu = !showSpeedMenu;
                          });
                        },
                      ),

                      // Marker
                      _ActionButton(
                        label: 'Add Marker',
                        icon: Icons.location_on,
                        onTap: _addMarker,
                      ),


                      // VOCAL NOTE
                      _ActionButton(
                        label: _isListening ? 'Listening...' : 'Vocal Note',
                        icon: _isListening ? Icons.mic : Icons.mic_none,
                        onTap: _toggleListening,
                        isLabelBold: _isListening,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // SPEED MENU OVERLAY
            if (showSpeedMenu)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showSpeedMenu = false;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 80),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C2E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Padding(
                              padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                              child: Text(
                                'Playback Speed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            ...speedOptions.map((speed) {
                              final isSelected = _playerSpeed == speed;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _playerSpeed = speed;
                                    showSpeedMenu = false;
                                  });
                                },
                                child: Container(
                                  color: isSelected
                                      ? Colors.deepPurpleAccent.withOpacity(0.3)
                                      : Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _speedLabel(speed),
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.deepPurpleAccent
                                              : Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable action button widget ──────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLabelBold;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isLabelBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight:
                  isLabelBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}