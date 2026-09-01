import 'package:flutter/material.dart';
import 'package:eltrack_mobile/features/home/service/wasteGuideService.dart';

import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';
import 'package:eltrack_mobile/features/home/pages/Categories/scanner/scannerPage.dart';

class WasteGuidePage extends StatefulWidget {
  final int userId;
  final int points;

  final String category;
  final String typeName;

  const WasteGuidePage({
    super.key,
    required this.userId,
    required this.points,
    required this.category,
    required this.typeName,
  });

  @override
  State<WasteGuidePage> createState() =>
      _WasteGuidePageState();
}

class _WasteGuidePageState extends State<WasteGuidePage> {
  static const Color primaryGreen = Color(0xFFA7C49E);
  static const Color darkGreen = Color(0xFF768973);
  static const Color lightGreen = Color(0xFFD4E3CF);

  bool isLoading = true;
  String? errorMessage;

  Map<String, dynamic>? guide;

  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadGuide();
  }

  Future<void> _loadGuide() async {
    try {
      final result = await WasteGuideService.getWasteGuide(
        category: widget.category,
        typeName: widget.typeName,
      );

      if (!mounted) return;

      setState(() {
        guide = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('WASTE GUIDE ERROR: $e');

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

                    _buildTitle(),

                    const SizedBox(height: 24),

                    _buildTypeHeader(),

                    const SizedBox(height: 20),

                    _buildContent(),
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
                      userId: widget.userId,
                      points: widget.points,
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

  Widget _buildTitle() {
    return const Center(
      child: Text(
        'Waste Guide',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          letterSpacing: .4,
        ),
      ),
    );
  }

  Widget _buildTypeHeader() {
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
            horizontal: 22,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: primaryGreen,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            widget.typeName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: .4,
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

  Widget _buildContent() {
    if (isLoading) {
      return Container(
        width: double.infinity,
        height: 360,
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: darkGreen,
          ),
        ),
      );
    }

    if (errorMessage != null || guide == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: darkGreen,
              size: 35,
            ),

            const SizedBox(height: 10),

            const Text(
              'Failed to load waste guide',
              style: TextStyle(
                color: darkGreen,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });

                _loadGuide();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final sections = [
      {
        'title': 'What is it ?',
        'content': guide!['what_is_it'] ?? '',
        'isList': false,
      },
      {
        'title': 'Common Items',
        'content': guide!['common_items'] ?? '',
        'isList': true,
      },
      {
        'title': 'Why it Matters',
        'content': guide!['why_it_matters'] ?? '',
        'isList': false,
      },
      {
        'title': 'How to Sort',
        'content': guide!['how_to_sort'] ?? '',
        'isList': false,
      },
      {
        'title': 'Best Handling',
        'content': guide!['best_handling'] ?? '',
        'isList': false,
      },
      {
        'title': 'What to Avoid',
        'content': guide!['what_to_avoid'] ?? '',
        'isList': false,
      },
      {
        'title': 'Sustainable Action',
        'content': guide!['sustainable_action'] ?? '',
        'isList': false,
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          sections.length,
          (index) {
            final section = sections[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom:
                    index == sections.length - 1
                        ? 0
                        : 10,
              ),
              child: _buildAccordion(
                index: index,
                title: section['title'] as String,
                content: section['content'] as String,
                isList: section['isList'] as bool,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccordion({
    required int index,
    required String title,
    required String content,
    required bool isList,
  }) {
    final bool isExpanded =
        expandedIndex == index;

    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 250),
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius:
            BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius:
                BorderRadius.circular(14),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedIndex = null;
                } else {
                  expandedIndex = index;
                }
              });
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  AnimatedRotation(
                    turns:
                        isExpanded ? .25 : 0,
                    duration:
                        const Duration(
                          milliseconds: 250,
                        ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            duration:
                const Duration(
                  milliseconds: 250,
                ),
            crossFadeState:
                isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            firstChild:
                const SizedBox(
                  width: double.infinity,
                ),
            secondChild: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16,
              ),
              child:
                  isList
                      ? _buildCommonItems(
                          content,
                        )
                      : Text(
                          content,
                          textAlign:
                              TextAlign.justify,
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.55,
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonItems(
    String content,
  ) {
    final items = content
        .split(';')
        .map(
          (item) => item.trim(),
        )
        .where(
          (item) => item.isNotEmpty,
        )
        .toList();

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children:
          items.map((item) {
        return SizedBox(
          width: 125,
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(top: 5),
                child: Icon(
                  Icons.circle,
                  color: Colors.white,
                  size: 5,
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  item,
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 58,
      decoration:
          const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color:
                Color(0x26000000),
            blurRadius: 6,
            offset:
                Offset(0, -4),
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