import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'NonOrganic.dart'; 

class Organic extends StatelessWidget{
  const Organic({super.key});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      //kalau tap kanan geser ke page sebelah
      behavior : HitTestBehavior.opaque, 

      onTapUp: (details){
        final screenWidth = MediaQuery.of(context).size.width;

        //hanya bagiaan kanan aja , yg kl di tap akan nge geser ges
        if(details.globalPosition.dx > screenWidth / 2){
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => const NonOrganic(),
            ),
          );
        }
      },
      
    child: Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/loadLogo.png', width: 805,),
              // const SizedBox(height: 100,),
                Transform.translate(
                  offset: const Offset(0, -230),
                  child: Column(
                    children:[
                      //ini buat stack judul
                      Stack(
                        alignment : Alignment.center,
                        children:[
                          Transform.translate(
                            offset : const Offset(0, 7),
                            child : Text(
                              'Organic', 
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
                            'Organic',
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
                            'Organic',
                            style: GoogleFonts.limelight(
                            fontSize: 40,
                            color: const Color(0xFF768973),
                            ),
                          ),
                        ],
                      ),

                      //ini buat stack deskripsinya
                     Transform.translate(
                      offset : const Offset(0,12),
                      child : Stack(
                        alignment : Alignment.center,
                        children:[
                          Transform.translate(
                            offset : const Offset(0, 7),
                            child : Text(
                              'Turn food scraps and yard waste into valuable compost.', 
                              style: GoogleFonts.limelight(
                              fontSize: 10, 
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
                              'Turn food scraps and yard waste into valuable compost.',
                              style : GoogleFonts.limelight(
                                fontSize : 10,
                                foreground : Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 10
                                ..strokeJoin = StrokeJoin.round
                                ..color = const Color(0xFFFDF6ED)
                              ),
                            ),

                      //ini warna tulisanya 
                            Text(
                              'Turn food scraps and yard waste into valuable compost.',
                              style: GoogleFonts.limelight(
                              fontSize: 10,
                              color: const Color(0xFF768973),
                              ),
                            ),
                        ],
                      ),
                     ),
                    ],
                  ),

                  // sekarang ini buat yang deskripsinya 

                ),
              ],
            )
          )
        )
      ),
    );
  }
}