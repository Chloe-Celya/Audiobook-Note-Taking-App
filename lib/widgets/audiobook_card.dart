import 'package:flutter/material.dart';
import '../models/audiobook.dart';

class AudiobookCard extends StatelessWidget {
  final Audiobook book;
  final bool isSelected;
  final VoidCallback onTap;

  const AudiobookCard({
    super.key,
    required this.book,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(
              height: 170,

              decoration: BoxDecoration(
                color: const Color(0xFF141428),

                borderRadius: BorderRadius.circular(12),

                border: isSelected
                    ? Border.all(
                        color: Colors.deepPurpleAccent,
                        width: 3,
                      )
                    : null,
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),

                child: Image.asset(
                  book.cover,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              book.title,
              style: const TextStyle(
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              book.author,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}