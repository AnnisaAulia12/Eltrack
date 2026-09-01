import 'package:flutter/material.dart';

class EltrackBottomNav extends StatelessWidget {
  final int currentIndex;

  final VoidCallback onHome;
  final VoidCallback onScanner;
  final VoidCallback onStore;
  final VoidCallback onProfile;

  const EltrackBottomNav({
    super.key,
    required this.currentIndex,
    required this.onHome,
    required this.onScanner,
    required this.onStore,
    required this.onProfile,
  });

  static const Color darkGreen = Color(0xFF758B72);
  static const Color inactiveGreen = Color(0xFFA9B8A5);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home,
              onTap: onHome,
            ),

            _buildNavItem(
              index: 1,
              icon: Icons.center_focus_strong,
              onTap: onScanner,
            ),

            _buildNavItem(
              index: 2,
              icon: Icons.store,
              onTap: onStore,
            ),

            _buildNavItem(
              index: 3,
              icon: Icons.person,
              onTap: onProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool isActive = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
          height: 60,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isActive
                    ? darkGreen
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 25,
                color: isActive
                    ? Colors.white
                    : darkGreen,
              ),
            ),
          ),
        ),
      ),
    );
  }
}