import 'package:flutter/material.dart';
import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

class RecyclingDetailPage extends StatefulWidget {
  final int userId;
  final int points;

  final Map<String, dynamic> idea;

  final Map<String, dynamic> recognition;

  const RecyclingDetailPage({
    super.key,
    required this.userId,
    required this.points,
    required this.idea,
    required this.recognition,
  });

  @override
  State<RecyclingDetailPage> createState() =>
      _RecyclingDetailPageState();
}

class _RecyclingDetailPageState
    extends State<RecyclingDetailPage> {
  static const Color mainGreen =
      Color(0xFFC7D9C2);

  static const Color darkGreen =
      Color(0xFF758B72);

  static const Color lineGreen =
      Color(0xFFA6BF9F);

  late List<String> materials;
  late List<String> tools;
  late List<String> steps;

  late List<bool> materialChecked;
  late List<bool> toolChecked;
  late List<bool> stepChecked;

  @override
  void initState() {
    super.initState();

    materials = _parseCommaList(
      widget.idea['materials']?.toString(),
    );

    tools = _parseCommaList(
      widget.idea['tools']?.toString(),
    );

    steps = _parseSteps(
      widget.idea['steps']?.toString(),
    );

    materialChecked =
        List<bool>.filled(materials.length, false);

    toolChecked =
        List<bool>.filled(tools.length, false);

    stepChecked =
        List<bool>.filled(steps.length, false);
  }

  List<String> _parseCommaList(String? value) {
    if (value == null || value.trim().isEmpty) {
      return [];
    }

    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  List<String> _parseSteps(String? value) {
    if (value == null || value.trim().isEmpty) {
      return [];
    }

    return value
        .split(RegExp(r'\.\s*'))
        .map((step) => step.trim())
        .where((step) => step.isNotEmpty)
        .toList();
  }

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

  String get title =>
      widget.idea['title']?.toString() ??
      'Recycling Idea';

  String get category {
    return _formatText(
      widget.recognition['category']
              ?.toString() ??
          'unknown',
    );
  }

  String? get imageUrl =>
      widget.idea['image_url']?.toString();

  bool get allCompleted {
    final bool materialDone =
        materialChecked.isEmpty ||
            materialChecked.every(
              (value) => value,
            );

    final bool toolDone =
        toolChecked.isEmpty ||
            toolChecked.every(
              (value) => value,
            );

    final bool stepDone =
        stepChecked.isEmpty ||
            stepChecked.every(
              (value) => value,
            );

    return materialDone &&
        toolDone &&
        stepDone;
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
                          decoration:
                              const BoxDecoration(
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

                    const SizedBox(height: 17),

                    // TITLE
                    Text(
                      '" $title "',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // CATEGORY
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
                            horizontal: 15,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: lineGreen,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w700,
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

                    // MAIN CONTAINER
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
                          _buildHeaderImage(),

                          const SizedBox(height: 35),

                          _buildSectionTitle(
                            'Stuff and Tools',
                          ),

                          const SizedBox(height: 18),

                          _buildStuffToolsCard(),

                          const SizedBox(height: 35),

                          _buildSectionTitle(
                            'How to do it ?',
                          ),

                          const SizedBox(height: 18),

                          _buildStepsCard(),

                          const SizedBox(height: 30),

                          _buildCompleteButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            EltrackBottomNav(
              currentIndex: 1,

              onHome: () {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },

              onScanner: () {
                // masih berada di fitur scanner
              },

              onStore: () {
                // nanti arahkan ke Store
              },

              onProfile: () {
                // nanti arahkan ke Profile
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        height: 180,
        color: const Color(0xFFE7EFE3),
        child: imageUrl != null &&
                imageUrl!.isNotEmpty &&
                imageUrl != 'null'
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Icon(
                    Icons.recycling,
                    color: darkGreen,
                    size: 85,
                  );
                },
              )
            : const Icon(
                Icons.recycling,
                color: darkGreen,
                size: 85,
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(width: 10),

        const Expanded(
          child: Divider(
            color: lineGreen,
            thickness: 4,
          ),
        ),
      ],
    );
  }


  Widget _buildStuffToolsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Material',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          if (materials.isEmpty)
            const Text(
              'No material information',
            )
          else
            ...List.generate(
              materials.length,
              (index) {
                return _buildChecklistItem(
                  text: materials[index],
                  value:
                      materialChecked[index],
                  onChanged: () {
                    setState(() {
                      materialChecked[index] =
                          !materialChecked[index];
                    });
                  },
                );
              },
            ),

          const SizedBox(height: 18),

          const Text(
            'Tools',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          if (tools.isEmpty)
            const Text(
              'No tools required',
            )
          else
            ...List.generate(
              tools.length,
              (index) {
                return _buildChecklistItem(
                  text: tools[index],
                  value: toolChecked[index],
                  onChanged: () {
                    setState(() {
                      toolChecked[index] =
                          !toolChecked[index];
                    });
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStepsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: steps.isEmpty
          ? const Text(
              'No instructions available.',
            )
          : Column(
              children: List.generate(
                steps.length,
                (index) {
                  return _buildChecklistItem(
                    text: steps[index],
                    value: stepChecked[index],
                    onChanged: () {
                      setState(() {
                        stepChecked[index] =
                            !stepChecked[index];
                      });
                    },
                  );
                },
              ),
            ),
    );
  }

  Widget _buildChecklistItem({
    required String text,
    required bool value,
    required VoidCallback onChanged,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration:
                  const Duration(milliseconds: 150),
              width: 18,
              height: 18,
              margin:
                  const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: value
                    ? darkGreen
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: darkGreen,
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: value
                      ? Colors.grey
                      : Colors.black87,
                  fontSize: 11,
                  height: 1.45,
                  decoration: value
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed:
            allCompleted ? _completeRecycling : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              Colors.grey.shade400,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          allCompleted
              ? 'Complete Recycling'
              : 'Complete All Steps First',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.7,
          ),
        ),
      ),
    );
  }

  void _completeRecycling() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: const Text(
            'Recycling Completed!',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Great! You have completed all materials, tools, and recycling steps.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment:
              MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}