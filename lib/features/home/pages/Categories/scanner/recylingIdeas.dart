import 'package:flutter/material.dart';
import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

import 'recyclingDetail.dart';

class recylingIdeas extends StatelessWidget {
  final int userId;
  final int points;

  final Map<String, dynamic> recognition;

  final String? matchedItem;

  final List<dynamic> ideas;

  const recylingIdeas({
    super.key,
    required this.userId,
    required this.points,
    required this.recognition,
    required this.matchedItem,
    required this.ideas,
  });

  static const Color mainGreen = Color(0xFFC7D9C2);
  static const Color darkGreen = Color(0xFF758B72);
  static const Color lineGreen = Color(0xFFA6BF9F);

  // =========================================================
  // FORMAT TITLE
  // plastic bottle -> Plastic Bottle
  // =========================================================

  String _formatText(String value) {
    String text = value
        .replaceAll('_', ' ')
        .trim();

    if (text.isEmpty) {
      return 'Unknown';
    }

    return text
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  String get objectName {
    final String value =
        recognition['object']?.toString() ??
            matchedItem ??
            'Unknown';

    return _formatText(value);
  }

  String get categoryName {
    final String value =
        recognition['category']?.toString() ??
            'unknown';

    return _formatText(value);
  }

  String _displayMinutes(dynamic value) {
    if (value == null) {
      return '- Minute';
    }

    return '$value Minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  30,
                  22,
                  30,
                  30,
                ),
                child: Column(
                  children: [
                    // BACK BUTTON
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: darkGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // OBJECT NAME
                    Text(
                      '" $objectName "',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 7),

                    // CATEGORY LINE
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: lineGreen,
                            thickness: 2,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: lineGreen,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            categoryName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Expanded(
                          child: Divider(
                            color: lineGreen,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 45),

                    // RECYCLING IDEAS CONTAINER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        22,
                        25,
                        22,
                        30,
                      ),
                      decoration: BoxDecoration(
                        color: mainGreen,
                        borderRadius:
                            BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: darkGreen,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Recycling Ideas',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          if (ideas.isEmpty)
                            _buildEmptyIdeas()
                          else
                            ...ideas.map(
                              (idea) {
                                final Map<String, dynamic>
                                    item =
                                    Map<String, dynamic>.from(
                                  idea as Map,
                                );

                                return Padding(
                                  padding:
                                      const EdgeInsets.only(
                                    bottom: 15,
                                  ),
                                  child: _buildIdeaCard(
                                    context,
                                    item,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            EltrackBottomNav(
              currentIndex: 1,
              userId: userId,
              points: points,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeaCard(
    BuildContext context,
    Map<String, dynamic> idea,
  ) {
    final String title =
        idea['title']?.toString() ??
            'Recycling Idea';

    final String difficulty =
        _formatText(
      idea['difficulty']?.toString() ?? 'easy',
    );

    final String material =
        _formatText(
      recognition['material']?.toString() ??
          'Waste',
    );

    final String? imageUrl =
        idea['image_url']?.toString();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecyclingDetailPage(
              userId: userId,
              points: points,
              idea: idea,
              recognition: recognition,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 105,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Container(
                width: 85,
                height: 85,
                color: const Color(0xFFE8EFE4),
                child: imageUrl != null &&
                        imageUrl.isNotEmpty &&
                        imageUrl != 'null'
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const Icon(
                            Icons.recycling,
                            color: darkGreen,
                            size: 42,
                          );
                        },
                      )
                    : const Icon(
                        Icons.recycling,
                        color: darkGreen,
                        size: 42,
                      ),
              ),
            ),

            const SizedBox(width: 13),

            // INFORMATION
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: darkGreen,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Text(
                          difficulty,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled,
                        color: darkGreen,
                        size: 12,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        _displayMinutes(
                          idea[
                              'estimated_minutes'],
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: lineGreen,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: Text(
                          material,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                          ),
                        ),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.arrow_circle_right,
                        color: darkGreen,
                        size: 17,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyIdeas() {
    return const SizedBox(
      width: double.infinity,
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: darkGreen,
            size: 45,
          ),
          SizedBox(height: 10),
          Text(
            'Waste detected, but no recycling\nideas are available yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkGreen,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}