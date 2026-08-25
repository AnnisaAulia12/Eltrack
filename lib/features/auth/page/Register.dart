import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eltrack_mobile/features/auth/controlers/registerControllers.dart';
import 'package:eltrack_mobile/features/home/pages/Discover.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final registerController = RegisterController();

  String selectedRole = 'personal';

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.94,
            height: MediaQuery.of(context).size.height * 0.94,
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Create Account',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Welcome back , you been missed!',
                          style: GoogleFonts.poppins(
                            fontSize: 8,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 65),

                  _label('Name \\ Username'),
                  const SizedBox(height: 8),
                  _inputField(
                    controller: nameController,
                  ),

                  const SizedBox(height: 45),

                  _label('Nomor Telfon'),
                  const SizedBox(height: 8),
                  _inputField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 45),

                  _label('Email'),
                  const SizedBox(height: 8),
                  _inputField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 45),

                  _label('Password'),
                  const SizedBox(height: 8),
                  _inputField(
                    controller: passwordController,
                    obscureText: true,
                  ),

                  const SizedBox(height: 45),

                  _label('Role'),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _roleButton(
                        title: 'Pribadi',
                        value: 'personal',
                      ),
                      _roleButton(
                        title: 'Wirausaha',
                        value: 'business',
                      ),
                    ],
                  ),

                  const SizedBox(height: 65),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('NEXT DIPENCET');
                        debugPrint('Role: $selectedRole');
                      },
                      child: Container(
                        width: 180,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(

                          border: Border.all(
                            color:  Colors.white,
                            width: 1.5,
                          ),

                          color: const Color(0xFFA8C7A0),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.20),
                              offset: const Offset(0, 3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 11,
        color: Colors.black,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0XFFA8C7A0),
        borderRadius: BorderRadius.circular(10),

        border: Border.all(
          color:  Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            offset: const Offset(0, 3),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFA8C7A0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _roleButton({
    required String title,
    required String value,
  }) {
    final isSelected = selectedRole == value;

    return GestureDetector(
      onTap: () async {
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (name.isEmpty ||
          phone.isEmpty ||
          email.isEmpty ||
          password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all fields'),
          ),
        );
        return;
      }

      try {
        final result = await registerController.register(
          name: name,
          phone: phone,
          email: email,
          password: password,
        );

        if (!mounted) return;

        if (result['success'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Discover(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'] ?? 'Registration failed',
              ),
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Register error: $e'),
          ),
        );
      }
    },
      child: Container(
        width: 108,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          

          border: Border.all(
            color:  Colors.white,
            width: 1.5,
          ),

          color: isSelected
              ? const Color(0xFF8FAF87)
              : const Color(0xFFA8C7A0),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              offset: const Offset(0, 3),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}