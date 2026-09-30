import 'package:flutter/material.dart';

import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

class PrivacyPolice extends StatelessWidget {
  final int userId;
  final int points;

  const PrivacyPolice({
    super.key,
    required this.userId,
    required this.points,
  });

  static const Color primaryGreen = Color(0xFFA7C49E);
  static const Color darkGreen = Color(0xFF768973);

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
                  22,
                  24,
                  22,
                  35,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(context),

                    const SizedBox(height: 24),

                    _buildPrivacyCard(),
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

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: darkGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildPrivacyCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTopHeader(),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              26,
              16,
              28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Privacy Police',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                _privacySection(
                  'Introduction.',
                  'At EltrackRecycle, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your personal information when you use our mobile application.',
                ),

                const SizedBox(height: 22),

                _privacySection(
                  'Data We Collect.',
                  'We may collect personal information that you provide to us, including but not limited to your name, email address, phone number, and location data to facilitate waste pick-up services.',
                ),

                const SizedBox(height: 22),

                _privacySection(
                  'How We Use Data',
                  'We use your information to provide and improve our services, process your recycling rewards, coordinate with logistics partners, and send important app updates or notifications.',
                ),

                const SizedBox(height: 22),

                _privacySection(
                  'Data Security',
                  'We implement standard security measures to protect your personal data from unauthorized access, alteration, or disclosure. However, no electronic transmission over the internet can be guaranteed 100% secure.',
                ),

                const SizedBox(height: 22),

                _privacySection(
                  'Third-Party Services',
                  'Our app may use third-party services such as maps or payment gateways that collect information used to identify you. We encourage you to read their respective privacy policies.',
                ),

                const SizedBox(height: 22),

                _privacySection(
                  'Contact Us If',
                  'You have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at EltrackRecycling@gmail.com.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _privacySection(
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: darkGreen,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          description,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      height: 28,
      decoration: const BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),
      ),
      child: Center(
        child: Container(
          width: 220,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}