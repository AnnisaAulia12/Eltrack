
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'NonOrganic.dart';
import 'package:eltrack_mobile/features/auth/page/Login.dart';

class K3 extends StatelessWidget {
  const K3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      body: SafeArea(
        child: Stack(
          children: [

            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,

                onTapUp: (details) {
                  final screenWidth =
                      MediaQuery.of(context).size.width;

                  // Kalau tap sisi kiri layar
                  // kembali ke halaman NonOrganic
                  if (details.globalPosition.dx <
                      screenWidth / 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const NonOrganic(),
                      ),
                    );
                  }
                },

                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Image.asset(
                        'assets/images/loadLogo.png',
                        width: 805,
                      ),

                      Transform.translate(
                        offset: const Offset(0, -230),

                        child: Column(
                          children: [

                            Stack(
                              alignment:
                                  Alignment.center,

                              children: [

                                // SHADOW
                                Transform.translate(
                                  offset:
                                      const Offset(0, 7),

                                  child: Text(
                                    'K3',

                                    style:
                                        GoogleFonts.limelight(
                                      fontSize: 40,

                                      foreground: Paint()
                                        ..style =
                                            PaintingStyle
                                                .stroke
                                        ..strokeWidth = 10
                                        ..strokeJoin =
                                            StrokeJoin.round
                                        ..color = Colors
                                            .black
                                            .withOpacity(
                                                0.10),
                                    ),
                                  ),
                                ),

                                // OUTLINE CREME
                                Text(
                                  'K3',

                                  style:
                                      GoogleFonts.limelight(
                                    fontSize: 40,

                                    foreground: Paint()
                                      ..style =
                                          PaintingStyle
                                              .stroke
                                      ..strokeWidth = 10
                                      ..strokeJoin =
                                          StrokeJoin.round
                                      ..color =
                                          const Color(
                                              0xFFFDF6ED),
                                  ),
                                ),

                                // WARNA TEKS
                                Text(
                                  'K3',

                                  style:
                                      GoogleFonts.limelight(
                                    fontSize: 40,
                                    color: const Color(
                                        0xFF768973),
                                  ),
                                ),
                              ],
                            ),

                            Transform.translate(
                              offset:
                                  const Offset(0, 12),

                              child: SizedBox(
                                width: 330,

                                child: Stack(
                                  alignment:
                                      Alignment.center,

                                  children: [

                                    // SHADOW DESKRIPSI
                                    Transform.translate(
                                      offset:
                                          const Offset(
                                              0, 7),

                                      child: Text(
                                        'Recycle hazardous waste properly to protect people and the environment',

                                        textAlign:
                                            TextAlign.center,

                                        style: GoogleFonts
                                            .limelight(
                                          fontSize: 10,

                                          foreground:
                                              Paint()
                                                ..style =
                                                    PaintingStyle
                                                        .stroke
                                                ..strokeWidth =
                                                    10
                                                ..strokeJoin =
                                                    StrokeJoin
                                                        .round
                                                ..color = Colors
                                                    .black
                                                    .withOpacity(
                                                        0.10),
                                        ),
                                      ),
                                    ),

                                    // OUTLINE CREME
                                    Text(
                                      'Recycle hazardous waste properly to protect people and the environment',

                                      textAlign:
                                          TextAlign.center,

                                      style:
                                          GoogleFonts.limelight(
                                        fontSize: 10,

                                        foreground: Paint()
                                          ..style =
                                              PaintingStyle
                                                  .stroke
                                          ..strokeWidth =
                                              10
                                          ..strokeJoin =
                                              StrokeJoin
                                                  .round
                                          ..color =
                                              const Color(
                                                  0xFFFDF6ED),
                                      ),
                                    ),

                                    // WARNA TEKS
                                    Text(
                                      'Recycle hazardous waste properly to protect people and the environment',

                                      textAlign:
                                          TextAlign.center,

                                      style:
                                          GoogleFonts.limelight(
                                        fontSize: 10,
                                        color: const Color(
                                            0xFF768973),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,

              child: Transform.translate(
                // Atur angka Y ini kalau mau
                // tombol lebih naik / turun
                offset: const Offset(0, 200),

                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,

                  onTap: () {
                    debugPrint('START DIPENCET');

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Login(),
                      ),
                    );
                  },

                  child: Container(
                    width: 150,
                    height: 50,

                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                      color: const Color(0xFF778873)
                          .withOpacity(0.4),

                      borderRadius:
                          BorderRadius.circular(10),

                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2),

                          offset:
                              const Offset(0, 4),

                          blurRadius: 4,
                        ),
                      ],
                    ),

                    child: const Text(
                      'Start',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
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