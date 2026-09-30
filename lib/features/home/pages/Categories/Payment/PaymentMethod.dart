import 'package:flutter/material.dart';
import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

class PaymentMethodPage extends StatefulWidget {
  final int userId;
  final int points;

  const PaymentMethodPage({
    super.key,
    required this.userId,
    required this.points,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  static const Color primaryGreen = Color(0xFFA8BE9B);
  static const Color darkGreen = Color(0xFF788C72);
  static const Color lightBg = Color(0xFFF4F4F4);

  late List<Map<String, dynamic>> availableMethods;
  late List<Map<String, dynamic>> additionalMethods;

  String selectedMethod = 'Recycle Points';

  @override
  void initState() {
    super.initState();

    availableMethods = [
      {
        'title': 'Recycle Points',
        'type': 'main',
        'icon': Icons.monetization_on_outlined,
      },
      {
        'title': 'QR Code',
        'type': 'main',
        'icon': Icons.qr_code_2_outlined,
      },
    ];

    additionalMethods = [
      {
        'title': 'OVO',
        'type': 'extra',
        'color': const Color(0xFF5B3FA3),
      },
      {
        'title': 'GoPay',
        'type': 'extra',
        'color': const Color(0xFF00AEEF),
      },
      {
        'title': 'Bank',
        'type': 'extra',
        'color': const Color(0xFF4F6D4F),
      },
      {
        'title': 'DANA',
        'type': 'extra',
        'color': const Color(0xFF1E88E5),
      },
    ];
  }

  void _selectMethod(String title) {
    setState(() {
      selectedMethod = title;
    });
  }

  void _addPaymentMethod(Map<String, dynamic> method) {
    setState(() {
      availableMethods.add({
        'title': method['title'],
        'type': 'extra',
        'color': method['color'],
      });

      additionalMethods.removeWhere(
        (item) => item['title'] == method['title'],
      );
    });
  }

  void _removeAddedMethod(Map<String, dynamic> method) {
    if (method['type'] != 'extra') return;

    setState(() {
      availableMethods.removeWhere(
        (item) => item['title'] == method['title'],
      );

      additionalMethods.add({
        'title': method['title'],
        'type': 'extra',
        'color': method['color'],
      });

      if (selectedMethod == method['title']) {
        selectedMethod = 'Recycle Points';
      }
    });
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
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(context),
                    const SizedBox(height: 18),
                    _buildMainCard(),
                  ],
                ),
              ),
            ),
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

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 30,
        height: 30,
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

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCardTopBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 26, 16, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                const Text(
                  'Jenis Pembayaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                ...availableMethods.map(
                  (method) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildAvailableMethodTile(method),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Tambah Pembayaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                if (additionalMethods.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Semua metode pembayaran sudah ditambahkan.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  ...additionalMethods.map(
                    (method) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildAdditionalMethodTile(method),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTopBar() {
    return Container(
      width: double.infinity,
      height: 28,
      decoration: const BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Center(
        child: Container(
          width: 240,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableMethodTile(Map<String, dynamic> method) {
    final String title = method['title'];
    final bool isSelected = selectedMethod == title;
    final String type = method['type'];

    return GestureDetector(
      onTap: () {
        _selectMethod(title);
      },
      onLongPress: () {
        if (type == 'extra') {
          _removeAddedMethod(method);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            if (type == 'main')
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: darkGreen,
                    width: 2,
                  ),
                ),
                child: Icon(
                  method['icon'],
                  color: darkGreen,
                  size: 20,
                ),
              )
            else
              _buildBrandCircle(
                title: title,
                color: method['color'],
              ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: .5,
                ),
              ),
            ),

            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: darkGreen,
                  width: 3,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: darkGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalMethodTile(Map<String, dynamic> method) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildBrandCircle(
            title: method['title'],
            color: method['color'],
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Text(
              method['title'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                letterSpacing: .5,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              _addPaymentMethod(method);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: darkGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Tambahkan',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: .3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCircle({
    required String title,
    required Color color,
  }) {
    String label = '';

    if (title == 'OVO') {
      label = 'O';
    } else if (title == 'GoPay') {
      label = 'G';
    } else if (title == 'Bank') {
      label = 'B';
    } else if (title == 'DANA') {
      label = 'D';
    } else {
      label = title.substring(0, 1).toUpperCase();
    }

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.12),
        border: Border.all(
          color: color,
          width: 3,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}