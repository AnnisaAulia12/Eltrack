import 'package:flutter/material.dart';

import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

class PersonalInformation extends StatefulWidget {
  final int userId;
  final int points;

  const PersonalInformation({
    super.key,
    required this.userId,
    required this.points,
  });

  @override
  State<PersonalInformation> createState() =>
      _PersonalInformationState();
}

class _PersonalInformationState
    extends State<PersonalInformation> {
  static const Color primaryGreen = Color(0xFFA7C49E);
  static const Color darkGreen = Color(0xFF768973);
  static const Color lightGreen = Color(0xFFDCE8D8);

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
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
                  22,
                  24,
                  22,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(),

                    const SizedBox(height: 24),

                    _buildPersonalInformationCard(),

                    const SizedBox(height: 24),

                    _buildActionButtons(),
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

  Widget _buildPersonalInformationCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER ATAS
          Container(
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
                width: 230,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              22,
              18,
              28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Personal Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                _buildInformationField(
                  title: 'Your Name',
                  controller: nameController,
                  hintText: 'Your name',
                ),

                const SizedBox(height: 18),

                _buildInformationField(
                  title: 'Gmail',
                  controller: emailController,
                  hintText: 'yourmail@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 18),

                _buildInformationField(
                  title: 'Phone Number',
                  controller: phoneController,
                  hintText: '08xxxxxxxxxx',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 18),

                _buildPasswordField(),

                const SizedBox(height: 18),

                _buildInformationField(
                  title: 'Address',
                  controller: addressController,
                  hintText: 'Add your saved address',
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHandle() {
    return Center(
      child: Container(
        width: 230,
        height: 3,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 45,
          ),
          SizedBox(height: 10),
          Text(
            'Personal Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: .6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationField({
    required String title,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title :',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 7),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            suffixIcon: const Icon(
              Icons.edit,
              color: Colors.black,
              size: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: darkGreen,
                width: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password :',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 7),

        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  '••••••••',
                  style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 2,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.edit,
                color: Colors.black,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // nanti logout
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: darkGreen,
              side: const BorderSide(
                color: darkGreen,
                width: 1.5,
              ),
              minimumSize: const Size(
                double.infinity,
                46,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'EXIT',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: .8,
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // nanti delete account
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(
                double.infinity,
                46,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'DELETE',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: .8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

