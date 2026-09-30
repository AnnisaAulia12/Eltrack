import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

class AboutUs extends StatelessWidget {
  final int userId;
  final int points;

  const AboutUs({
    super.key,
    required this.userId,
    required this.points,
  });

  static const Color primaryGreen = Color(0xFFA9C4A1);
  static const Color darkGreen = Color(0xFF768973);
  static const Color softGreen = Color(0xFF90A58B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildHeader(context),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        40,
                        20,
                        0,
                      ),
                      child: Column(
                        children: [
                          _buildAboutSection(),

                          const SizedBox(height: 42),

                          _buildMissionSection(),

                          const SizedBox(height: 48),

                          _buildFeatureSection(),

                          const SizedBox(height: 55),

                          _buildContactSection(),

                          const SizedBox(height: 55),
                        ],
                      ),
                    ),

                    _buildFooter(),
                  ],
                ),
              ),
            ),

            EltrackBottomNav(
              currentIndex: 3,
              userId: userId,
              points: points,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 138,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // IMAGE HEADER
          Image.asset(
            'assets/images/LoginHeader.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),

          // OVERLAY PUTIH / HIJAU TRANSPARAN
          Container(
            color: const Color(0xFFDCE7D8).withOpacity(.45),
          ),

          // BACK BUTTON
          Positioned(
            left: 22,
            top: 38,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),

          // LOGO ELTRACK
          Center(
            child: Text(
              'eltrack',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
                shadows: const [
                  Shadow(
                    color: Color(0x55768973),
                    offset: Offset(2, 2),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ABOUT US
  // ============================================================

  Widget _buildAboutSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPill(
          text: 'About Us',
          fontSize: 15,
          horizontal: 8,
          vertical: 2,
        ),

        const SizedBox(width: 34),

        Expanded(
          child: Text(
            'Eco-Apps is a smart waste management platform designed to transform how communities handle domestic waste. By integrating technology with sustainability, we bridge the gap between households and recycling centers to create a cleaner environment.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 8.4,
              height: 1.45,
              fontWeight: FontWeight.w600,
              letterSpacing: .25,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // OUR MISSION
  // ============================================================

  Widget _buildMissionSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildMissionItem(
                number: '1',
                text:
                    'Helping you sort household waste easily\nthrough smart technology.',
              ),

              const SizedBox(height: 12),

              _buildMissionItem(
                number: '2',
                text:
                    'Connecting your home directly to local\nrecycling centers',
              ),

              const SizedBox(height: 12),

              _buildMissionItem(
                number: '3',
                text:
                    'Turning your daily recycling efforts into\nexciting eco-rewards.',
              ),
            ],
          ),
        ),

        const SizedBox(width: 22),

        Column(
          children: [
            _buildPill(
              text: 'Our',
              fontSize: 16,
              horizontal: 11,
              vertical: 1,
            ),

            const SizedBox(height: 3),

            _buildPill(
              text: 'Mission',
              fontSize: 16,
              horizontal: 9,
              vertical: 1,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMissionItem({
    required String number,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 27,
          height: 27,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: darkGreen,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 8,
              height: 1.35,
              fontWeight: FontWeight.w600,
              letterSpacing: .1,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MAIN FEATURE
  // ============================================================

  Widget _buildFeatureSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            _buildPill(
              text: 'Main',
              fontSize: 16,
              horizontal: 10,
              vertical: 1,
            ),

            const SizedBox(height: 3),

            _buildPill(
              text: 'Feature',
              fontSize: 16,
              horizontal: 8,
              vertical: 1,
            ),
          ],
        ),

        const SizedBox(width: 55),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeatureText(
                'Smart Sorting – Identify and categorize\nwaste instantly.',
              ),

              const SizedBox(height: 11),

              _buildFeatureText(
                'Eco Pick-Up – Schedule effortless waste\ncollection from home.',
              ),

              const SizedBox(height: 11),

              _buildFeatureText(
                'Point Rewards – Earn and redeem points\nfor exciting vouchers',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.black87,
        fontSize: 8,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: .1,
      ),
    );
  }

  // ============================================================
  // CONTACT
  // ============================================================

  Widget _buildContactSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            'Contact Us',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: .7,
            ),
          ),
        ),

        Expanded(
          flex: 5,
          child: Column(
            children: [
              _buildContactItem(
                icon: Icons.email_outlined,
                text: 'EltrackRecycling@gmail.com',
              ),

              const SizedBox(height: 15),

              _buildContactItem(
                icon: Icons.phone,
                text: '+6288973076807',
              ),

              const SizedBox(height: 15),

              _buildContactItem(
                icon: Icons.camera_alt_outlined,
                text: '@EltractRecycle',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: 16,
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 7.4,
              fontWeight: FontWeight.w600,
              letterSpacing: .15,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PILL
  // ============================================================

  Widget _buildPill({
    required String text,
    double fontSize = 14,
    double horizontal = 10,
    double vertical = 2,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      decoration: BoxDecoration(
        color: darkGreen.withOpacity(.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.1,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: darkGreen,
        border: Border(
          top: BorderSide(
            color: Color(0xFF536651),
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Version 1.0.0',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            '© 2026 Eco-Apps Project',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}