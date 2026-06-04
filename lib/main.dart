import 'package:flutter/material.dart';
import 'screens/library_screen.dart';

void main() {
  runApp(const AudiobookApp());
}

class AudiobookApp extends StatelessWidget {
  const AudiobookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LibraryScreen(),
    );
  }
}