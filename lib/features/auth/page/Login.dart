import 'package:eltrack_mobile/features/auth/page/Register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eltrack_mobile/features/auth/controlers/LoginControllers.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final loginController = LoginController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(
          children: [

            // =========================
            // HEADER IMAGE
            // =========================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 310,

              child: Stack(
                fit: StackFit.expand,
                children: [

                  // gambar dipudarkan
                  Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/images/LoginHeader.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  Align(
                    alignment: const Alignment(0, -0.3),

                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        // stroke + shadow
                        Text(
                          'eltrack',
                          style: GoogleFonts.limelight(
                            fontSize: 36,

                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 10
                              ..strokeJoin = StrokeJoin.round
                              ..color = Colors.white,
                              

                            shadows: const [
                              Shadow(
                                offset: Offset(0, 3),
                                blurRadius: 4,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                        ),

                        // isi logo
                        Text(
                          'eltrack',
                          style: GoogleFonts.limelight(
                            fontSize: 36,
                            color: const Color(0xFF768973),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

         
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              bottom: 0,

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.elliptical(220, 150),
                    topRight: Radius.elliptical(220, 150),
                  ),

                  // shadow di bagian lengkungan
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      offset: const Offset(0, -2),
                      blurRadius: 7,
                      spreadRadius: 0,
                    ),
                  ],
                ),

  
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),

                  child: Column(
                    children: [

  
                      const SizedBox(height: 40),

                      Text(
                        'Login here',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        'Welcome back , you been missed!',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 55),

                      
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Gmail',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      
                      Container(
                        height: 42,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:  Colors.white,
                            width: 1.5,
                          ),
                          
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),

                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFA6C49D),

                            contentPadding:
                                const EdgeInsets.symmetric(
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
                      ),

                      const SizedBox(height: 45),

                      Align(
                        alignment: Alignment.centerLeft,

                        child: Text(
                          'Password',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      
                      Container(
                        height: 42,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:  Colors.white,
                            width: 1.5
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
                          controller: passwordController,
                          obscureText: true,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFA6C49D),

                            contentPadding:
                                const EdgeInsets.symmetric(
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
                      ),

                      const SizedBox(height: 8),

                      
                      Align(
                        alignment: Alignment.centerRight,

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Text(
                              "Don't have account ?",
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                              ),
                            ),

                            const SizedBox(width: 10),

                            GestureDetector(
                              onTap: () {
                                // nanti arahkan ke sign up
                                Navigator.push(
                                  context,MaterialPageRoute(builder: (context) => const Register()),
                                );
                              },

                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 75),

                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          debugPrint('=== TOMBOL LOGIN DIPENCET ===');

                          final email = emailController.text.trim();
                          final password = passwordController.text;

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill email and password'),
                              ),
                            );
                            return;
                          }

                          try {
                            debugPrint('Mencoba login...');
                            debugPrint('Email: $email');

                            final result = await loginController.login(
                              email: email,
                              password: password,
                            );

                            debugPrint('Response login: $result');

                            if (!mounted) return;

                            if (result['success'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result['message']?.toString() ?? 'Login successful',
                                  ),
                                ),
                              );

                              debugPrint('=== LOGIN BERHASIL ===');
                              debugPrint('User ID: ${result['user']?['id']}');
                              debugPrint('Username: ${result['user']?['username']}');
                              debugPrint('Role: ${result['user']?['role']}');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result['message']?.toString() ?? 'Login failed',
                                  ),
                                ),
                              );

                              debugPrint('LOGIN GAGAL: ${result['message']}');
                            }
                          } catch (e) {
                            debugPrint('=== ERROR LOGIN ===');
                            debugPrint(e.toString());

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Login error: $e'),
                              ),
                            );
                          }
                        },

                        child: Container(
                          width: 210,
                          height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:  Colors.white,
                              width: 1.5,
                            ),

                            color: const Color(0xFFA6C49D),
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
                            'Log in',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                     
                      Row(
                        children: [

                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Color(0xFFA6C49D),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),

                            child: Text(
                              'Sign in with',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                              ),
                            ),
                          ),

                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Color(0xFFA6C49D),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                     
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,

                        children: [

                          // google sementara
                          Container(
                            width: 30,
                            height: 30,

                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFA6C49D),
                            ),

                            alignment: Alignment.center,

                            child: const Text(
                              'G',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const CircleAvatar(
                            radius: 15,
                            backgroundColor:
                                Color(0xFFA6C49D),
                          ),

                          const CircleAvatar(
                            radius: 15,
                            backgroundColor:
                                Color(0xFFA6C49D),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}