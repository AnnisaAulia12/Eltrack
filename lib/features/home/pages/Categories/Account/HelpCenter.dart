import 'package:flutter/material.dart';

import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

class HelpCenter extends StatelessWidget {
  final int userId;
  final int points;

  const HelpCenter({
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

                    _buildHelpCard(),
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

  Widget _buildHelpCard() {
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
              30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Help Center',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                _helpSection(
                  'How to Recycle',
                  'To start recycling, sort your waste according to the categories listed in the app. Schedule a pick-up through the dashboard, and our logistics partner will collect it from your doorstep.',
                ),

                const SizedBox(height: 22),

                _helpSection(
                  'Earning Points.',
                  'You will earn Eco-Points after our partner successfully weighs and verifies your collected recycling materials. The points will be credited to your account balance automatically.',
                ),

                const SizedBox(height: 22),

                _helpSection(
                  'Redeem Rewards.',
                  'Go to the Rewards menu to view available vouchers. Choose the voucher you want, and make sure you have enough Eco-Points to complete the exchange.',
                ),

                const SizedBox(height: 22),

                _helpSection(
                  'Account Issues.',
                  'If you experience login errors, missing points, or trouble updating your profile, please reach out to our support team through the Contact Us section or email us directly.',
                ),

                const SizedBox(height: 22),

                _helpSection(
                  'App Crashes.',
                  'If the app freezes or closes unexpectedly, please ensure you are using the latest version. Try clearing the app cache or reinstalling if the problem persists.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _helpSection(
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