import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

import 'package:eltrack_mobile/features/home/pages/Categories/scanner/scannerPage.dart';

class ArticleDetailPage extends StatelessWidget {
  final dynamic article;
  final String category;
  final int userId;
  final int points;

  const ArticleDetailPage({
    super.key,
    required this.article,
    required this.category,
    required this.userId,
    required this.points,
  
  });

  static const Color primaryGreen =
      Color(0xFFA7C49E);

  static const Color darkGreen =
      Color(0xFF768973);

  static const Color lightGreen =
      Color(0xFFD4E3CF);

  @override
  Widget build(BuildContext context) {
    final String title =
        article['title'] ?? 'Untitled Article';

    final String description =
        article['description'] ?? '';

    final String content =
        article['content'] ?? '';

    final String? image =
        article['image'];

    final String url =
        article['url'] ?? '';

    final String source =
        article['source']?['name'] ?? '';

    final String publishedAt =
        article['publishedAt'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(
                  28,
                  24,
                  28,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(context),

                    const SizedBox(height: 22),

                    const Center(
                      child: Text(
                        'Article Detail',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (image != null &&
                        image.isNotEmpty)
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                        child: Image.network(
                          image,
                          width:
                              double.infinity,
                          height: 210,
                          fit: BoxFit.cover,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return _imageFallback();
                          },
                        ),
                      )
                    else
                      _imageFallback(),

                    const SizedBox(height: 20),

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight:
                            FontWeight.w700,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            source,
                            style:
                                const TextStyle(
                              color: darkGreen,
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),

                        Text(
                          _formatDate(
                            publishedAt,
                          ),
                          style:
                              const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (description.isNotEmpty) ...[
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        description,
                        textAlign:
                            TextAlign.justify,
                        style:
                            const TextStyle(
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],

                    if (content.isNotEmpty) ...[
                      const Text(
                        'Article Preview',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        content,
                        textAlign:
                            TextAlign.justify,
                        style:
                            const TextStyle(
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            url.isEmpty
                                ? null
                                : () {
                                    _openArticle(
                                      context,
                                      url,
                                    );
                                  },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              darkGreen,
                          foregroundColor:
                              Colors.white,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Read Full Article',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          // nanti panggil
                          // complete_article.php
                        },
                        style:
                            OutlinedButton.styleFrom(
                          foregroundColor:
                              darkGreen,
                          side: const BorderSide(
                            color: darkGreen,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Done Reading',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            EltrackBottomNav(
              currentIndex: 0,

              onHome: () {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },

              onScanner: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => scannerPage(
                      userId: userId,
                      points: points,
                    ),
                  ),
                );
              },

              onStore: () {
                // nanti Store
              },

              onProfile: () {
                // nanti Profile
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () =>
          Navigator.pop(context),
      child: Container(
        width: 26,
        height: 26,
        decoration:
            const BoxDecoration(
          color: darkGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.article_outlined,
        color: darkGreen,
        size: 45,
      ),
    );
  }

  Future<void> _openArticle(
    BuildContext context,
    String url,
  ) async {
    final uri = Uri.tryParse(url);

    if (uri == null) return;

    final opened =
        await launchUrl(
      uri,
      mode:
          LaunchMode.externalApplication,
    );

    if (!opened &&
        context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open article',
          ),
        ),
      );
    }
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '';

    try {
      final parsed =
          DateTime.parse(date);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
    } catch (_) {
      return '';
    }
  }
}