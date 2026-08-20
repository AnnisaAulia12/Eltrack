import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Organic.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Organic(),
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
              Image.asset('assets/images/logo.png', width: 805,),
              // const SizedBox(height: 100,),
                Transform.translate(
                  offset: const Offset(0, -230),
                  child: Stack(
                    alignment: Alignment.center,
                    children:[
                      //ini buat shadow nya
                      Transform.translate(
                        offset : const Offset(0, 7),
                          child : Text(
                          'eltrack', 
                          style: GoogleFonts.limelight(
                          fontSize: 40, 
                          foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 10
                          ..strokeJoin = StrokeJoin.round
                          ..color = Colors.black.withOpacity(0.10)
                          ),
                        ),
                      ),


                      //Outline Creme
                      Text(
                        'eltrack',
                        style : GoogleFonts.limelight(
                          fontSize : 40,
                          foreground : Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 10
                          ..strokeJoin = StrokeJoin.round
                          ..color = const Color(0xFFFDF6ED)
                        ),
                      ),

                      //ini warna tulisanya 
                      Text(
                        'eltrack',
                        style: GoogleFonts.limelight(
                        fontSize: 40,
                        color: const Color(0xFF768973),
                        ),
                      ),
],
                  ),
                ),
            ],
          )
        )
      )
    ),
    );
  }
}