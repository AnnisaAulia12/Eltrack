import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';
import 'package:eltrack_mobile/features/home/pages/Categories/Account/PersonalInformation.dart';

import 'package:eltrack_mobile/features/home/pages/Categories/Account/AboutUs.dart';
import 'package:eltrack_mobile/features/home/pages/Categories/Account/PrivacyPolice.dart';
import 'package:eltrack_mobile/features/home/pages/Categories/Account/HelpCenter.dart';

import 'package:eltrack_mobile/features/home/pages/Categories/Payment/PaymentMethod.dart';

class AccountPage extends StatefulWidget {
  final int userId;
  final int points;

  const AccountPage({
    super.key,
    required this.userId,
    required this.points,
  });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  static const Color primaryGreen = Color(0xFFA7C49E);
  static const Color darkGreen = Color(0xFF768973);
  static const Color lightGreen = Color(0xFFDCE8D8);


  int organicTotal = 0;
  int nonOrganicTotal = 0;
  int k3Total = 0;

  bool loadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadAccountStats();
  }

  // =========================
  // LOAD ACCOUNT STATS
  // =========================

  Future<void> _loadAccountStats() async {
    try {
      final response = await http.post(
        Uri.parse(
          'http://10.0.2.2/eltrack_recycling/recycling_history_API/account_stats.php',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': widget.userId,
        }),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        setState(() {
          organicTotal = data['stats']['organic'] ?? 0;
          nonOrganicTotal =
              data['stats']['non_organic'] ?? 0;
          k3Total = data['stats']['k3'] ?? 0;

          loadingStats = false;
        });
      } else {
        setState(() {
          loadingStats = false;
        });
      }
    } catch (e) {
      debugPrint('ACCOUNT STATS ERROR: $e');

      if (!mounted) return;

      setState(() {
        loadingStats = false;
      });
    }
  }

  // =========================
  // PERSONAL INFORMATION
  // =========================

  void _openPersonalInformation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonalInformation(
          userId: widget.userId,
          points: widget.points,
        ),
      ),
    );
  }


  int get totalRecycled {
    return organicTotal +
        nonOrganicTotal +
        k3Total;
  }

  double _getProgress(int value) {
    if (totalRecycled == 0) {
      return 0;
    }

    return value / totalRecycled;
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadAccountStats,

                child: SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),

                  padding: 
                    const EdgeInsets.fromLTRB(
                      18,
                      18,
                      18,
                      35,
                    ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      // PROFILE
                      _buildProfileSection(),

                      const SizedBox(height: 42),

                      // MOST RECYCLED
                      _buildRecyclingStatistics(),

                      const SizedBox(height: 32),

                      // TRANSACTION
                      _buildTransactionSection(),

                      const SizedBox(height: 32),

                      // SUPPORT
                      _buildSupportSection(),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),

            // BOTTOM NAV
            EltrackBottomNav(
              currentIndex: 3,
              userId: widget.userId,
              points: widget.points,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return SizedBox(
      height: 120,

      child: Stack(
        clipBehavior: Clip.none,

        children: [
          // GREEN CARD
          Positioned(
            left: 0,
            right: 0,
            top: 40,

            child: Container(
              height: 76,

              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(18),
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

              padding:
                  const EdgeInsets.fromLTRB(
                95,
                17,
                18,
                14,
              ),

              child: Row(
                children: [
                  Expanded(
                    child: _buildProfileValue(
                      title:
                          'Recycling Category',
                      value:
                          'Silver - 10%',
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: _buildProfileValue(
                      title:
                          'Recycling Point',
                      value:
                          '${widget.points} Pts',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // AVATAR
          Positioned(
            left: 18,
            top: 4,

            child: GestureDetector(
              onTap:
                  _openPersonalInformation,

              child: Container(
                width: 72,
                height: 72,

                decoration:
                    BoxDecoration(
                  color: darkGreen,

                  shape:
                      BoxShape.circle,

                  border:
                      Border.all(
                    color:
                        Colors.white,
                    width: 6,
                  ),

                  boxShadow:
                      const [
                    BoxShadow(
                      color:
                          Color(
                        0x33000000,
                      ),
                      blurRadius: 4,
                      offset:
                          Offset(
                        0,
                        3,
                      ),
                    ),
                  ],
                ),

                child:
                    const Icon(
                  Icons.person,
                  color:
                      Colors.white,
                  size: 43,
                ),
              ),
            ),
          ),

          // SETTINGS
          Positioned(
            right: 2,
            top: 0,

            child:
                GestureDetector(
              onTap:
                  _openPersonalInformation,

              child:
                  const Icon(
                Icons.settings,
                color: darkGreen,
                size: 27,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileValue({
    required String title,
    required String value,
  }) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [
        Text(
          title,

          textAlign:
              TextAlign.center,

          style:
              const TextStyle(
            color:
                Colors.white,

            fontSize: 7,

            fontWeight:
                FontWeight.w500,
          ),
        ),

        const SizedBox(
          height: 5,
        ),

        Container(
          width:
              double.infinity,

          height: 23,

          alignment:
              Alignment.center,

          decoration:
              BoxDecoration(
            color: darkGreen,

            borderRadius:
                BorderRadius.circular(
              15,
            ),

            border:
                Border.all(
              color:
                  Colors.white,
              width: 1,
            ),
          ),

          child: Text(
            value,

            textAlign:
                TextAlign.center,

            style:
                const TextStyle(
              color:
                  Colors.white,

              fontSize: 12,

              fontWeight:
                  FontWeight.w700,

              letterSpacing:
                  .3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecyclingStatistics() {
    return Container(
      width:
          double.infinity,

      decoration:
          _panelDecoration(),

      child: Column(
        children: [
          // HEADER
          _buildSectionHeader(
            'Most Recycled Items',
          ),

          if (loadingStats)
            const SizedBox(
              height: 120,

              child: Center(
                child:
                    CircularProgressIndicator(
                  color:
                      darkGreen,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                28,
                16,
                28,
                20,
              ),
              child: Column(
                children: [
                  _buildProgressRow(
                    title: 'Organic',
                    value: organicTotal,
                    progress: _getProgress(organicTotal),
                  ),

                  const SizedBox(height: 16),

                  _buildProgressRow(
                    title: 'Non Organic',
                    value: nonOrganicTotal,
                    progress: _getProgress(nonOrganicTotal),
                  ),

                  const SizedBox(height: 16),

                  _buildProgressRow(
                    title: 'K3',
                    value: k3Total,
                    progress: _getProgress(k3Total),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressRow({
    required String title,
    required int value,
    required double progress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Text(
              '$value item',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation<Color>(
              darkGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionSection() {
    return _buildSectionPanel(
      title: 'Transaction',
      children: [
        _buildMenuPill(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Payment method',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentMethodPage(
                  userId: widget.userId,
                  points: widget.points,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        _buildMenuPill(
          icon: Icons.receipt_long_outlined,
          title: 'Transaction History',
          onTap: () {
            // nanti Transaction History
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSectionPanel(
      title: 'Support',
      children: [
        _buildMenuPill(
          icon: Icons.info_outline,
          title: 'About Us',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AboutUs(
                  userId: widget.userId,
                  points: widget.points,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        _buildMenuPill(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PrivacyPolice(
                  userId: widget.userId,
                  points: widget.points,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        _buildMenuPill(
          icon: Icons.help_outline,
          title: 'Help Center',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HelpCenter(
                  userId: widget.userId,
                  points: widget.points,
                ),
              ),
            );
          },
        ),
      ],
    );
  }


  Widget _buildSectionPanel({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width:
          double.infinity,

      decoration:
          _panelDecoration(),

      child: Column(
        children: [
          _buildSectionHeader(
            title,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              22,
              18,
              22,
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      height: 30,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: .6,
        ),
      ),
    );
  }

    Widget _buildMenuPill({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return Material(
        color: darkGreen,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: double.infinity,
            height: 42,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Row(
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.3,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 15,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 19,
                ),
              ],
            ),
          ),
        ),
      );
    }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: primaryGreen,
      borderRadius: BorderRadius.circular(20),
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
    );
  }
}
