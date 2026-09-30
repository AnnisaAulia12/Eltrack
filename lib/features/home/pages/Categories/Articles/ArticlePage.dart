import 'package:flutter/material.dart';

import 'package:eltrack_mobile/features/home/service/articleService.dart';
import 'package:eltrack_mobile/features/home/pages/Categories/Articles/ArticleDetailPage.dart';


import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';
import 'package:eltrack_mobile/features/home/pages/Categories/scanner/scannerPage.dart';

class ArticlePage extends StatefulWidget {
  final int userId;
  final int points;

  final String category;
  final String title;

  const ArticlePage({
    super.key,
    required this.userId,
    required this.points,
    required this.category,
    required this.title,
  });

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  static const Color primaryGreen = Color(0xFFA7C49E);
  static const Color darkGreen = Color(0xFF768973);
  static const Color lightGreen = Color(0xFFD4E3CF);

  bool isLoading = true;
  String? errorMessage;

  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      final result =
          await articleService.getArticles(widget.category);

      if (!mounted) return;

      setState(() {
        articles = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('ARTICLES PAGE ERROR: $e');

      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
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
                  28,
                  24,
                  28,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(),

                    const SizedBox(height: 22),

                    _buildPageTitle(),

                    const SizedBox(height: 18),

                    _buildCategoryHeader(),

                    const SizedBox(height: 18),

                    _buildArticlesContent(),
                  ],
                ),
              ),
            ),

            EltrackBottomNav(
              currentIndex: 0,
              userId: widget.userId,
              points: widget.points,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
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

  Widget _buildPageTitle() {
    return const Center(
      child: Text(
        'ARTICLES',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          letterSpacing: .8,
        ),
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: darkGreen,
            thickness: 1,
          ),
        ),

        const SizedBox(width: 12),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: primaryGreen,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Divider(
            color: darkGreen,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildArticlesContent() {
    if (isLoading) {
      return Container(
        width: double.infinity,
        height: 350,
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: darkGreen,
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            const Text(
              'Failed to load articles',
              style: TextStyle(
                color: darkGreen,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });

                _loadArticles();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (articles.isEmpty) {
      return Container(
        width: double.infinity,
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'No articles available',
          style: TextStyle(
            color: darkGreen,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'News & Articles',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: articles.length,
            separatorBuilder: (_, __) {
              return const SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              return _buildArticleCard(
                articles[index],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(dynamic article) {
    final String title =
        article['title'] ?? 'Untitled Article';

    final String description =
        article['description'] ?? '';

    final String? image =
        article['image'];

    final String source =
        article['source']?['name'] ?? '';

    final String publishedAt =
        article['publishedAt'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            ArticleDetailPage(
              userId: widget.userId,
              points: widget.points,
              article: article,
              category: widget.category,
            )
          ),
        );
      },
      child: Container(
        height: 105,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 90,
                height: 88,
                child: image != null &&
                        image.isNotEmpty
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return _imageFallback();
                        },
                      )
                    : _imageFallback(),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 7,
                      color: Colors.grey,
                      height: 1.3,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          source,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            fontSize: 6.5,
                            color: darkGreen,
                          ),
                        ),
                      ),

                      Text(
                        _formatDate(
                          publishedAt,
                        ),
                        style:
                            const TextStyle(
                          fontSize: 6,
                          color: Colors.grey,
                        ),
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

  Widget _imageFallback() {
    return Container(
      color: lightGreen,
      child: const Icon(
        Icons.article_outlined,
        color: darkGreen,
      ),
    );
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

  Widget _buildBottomNavigation() {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.home_rounded,
            color: darkGreen,
            size: 22,
          ),
          Icon(
            Icons.center_focus_weak,
            color: darkGreen,
            size: 22,
          ),
          Icon(
            Icons.storefront_outlined,
            color: darkGreen,
            size: 22,
          ),
          Icon(
            Icons.person,
            color: darkGreen,
            size: 22,
          ),
        ],
      ),
    );
  }
}