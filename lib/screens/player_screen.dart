import 'package:flutter/material.dart';

import '../models/audiobook.dart';
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

  final List<double> speedOptions = [0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    final book = widget.book;
    if (book != null) {
      _currentBook = book;
      totalDuration = book.duration;
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

                  // SEEK BAR
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
                        onTap: () {},
                      ),


                      // SNIPPET
                      _ActionButton(
                        label: 'Snippet',
                        icon: Icons.mic_none,
                        onTap: () {},
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