import 'package:flutter/material.dart';

import '../data/audiobooks.dart';
import '../widgets/audiobook_card.dart';
import '../widgets/bottom_nav.dart';
import 'player_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int selectedBookIndex = 0;

  String searchQuery = "";

  final List<String> categories = [
    "All",
    "Fiction",
    "Self-Help",
    "Sci-Fi",
  ];

  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {

    final filteredBooks = audiobooks.where((book) {

      final matchesSearch =
          book.title
              .toLowerCase()
              .contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == "All"
          || book.category == selectedCategory;

      return matchesSearch && matchesCategory;

    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF080816),

      bottomNavigationBar: const BottomNav(
        currentIndex: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // TITLE

              const Text(
                "Library",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // SEARCH BAR

              TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },

                decoration: InputDecoration(
                  hintText: "Search audiobooks...",
                  hintStyle: const TextStyle(
                    color: Colors.white70,
                  ),

                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white70,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white54,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepPurpleAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),  
                ),
              ),

              const SizedBox(height: 24),

              // RECENTLY ADDED

              const Text(
                "Recently Added",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 240,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,

                  itemCount: filteredBooks.length,

                  itemBuilder: (context, index) {

                    final book = filteredBooks[index];

                    return AudiobookCard(
                      book: book,

                      isSelected:
                          selectedBookIndex == index,

                      onTap: () {

                        setState(() {
                          selectedBookIndex = index;
                        });

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                const PlayerScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // CATEGORIES

              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: Row(
                  children: categories.map((category) {

                    final isSelected =
                        selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),

                      child: ChoiceChip(
                        label: Text(category),

                        selected: isSelected,

                        onSelected: (_) {

                          setState(() {
                            selectedCategory = category;
                          });
                        },

                        selectedColor:
                            Colors.deepPurpleAccent,
                      ),
                    );

                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}