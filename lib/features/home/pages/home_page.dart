import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loadingPage.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const loadingPage(),
          ),
        );
      },
    child: Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 260,),
              const SizedBox(height: 20,),
              Stack(
                alignment: Alignment.center,
                children:[
                  Text(
                    'eltrack', 
                    style: GoogleFonts.limelight(
                    fontSize: 35, 
                    foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = const Color(0xFFFDF6ED),
                    ),
                  ),

                  Text(
                    'eltrack',
                    style: GoogleFonts.limelight(
                    fontSize: 35,
                    color: const Color(0xFF768973),
                    shadows: const[
                      Shadow(
                      offset: Offset(4,4),
                      blurRadius: 0,
                      color:Colors.black,
                      )
                    ]
                    ),
                  ),
                ],
              ),
            ]
          )
        )
      )
    ),
    );
  }
}