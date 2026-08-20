import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'K3.dart'; 
import 'Organic.dart';

class NonOrganic extends StatelessWidget{
  const NonOrganic({super.key});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      // ini kalau klick kanan akan geser ke k3 , jadi ada if else
      behavior : HitTestBehavior.opaque,
      onTapUp : (details){
        final screenWidth = MediaQuery.of(context).size.width;

        // ini kanan 
        if(details.globalPosition.dx > screenWidth /2){
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => const K3(),
            ),
          );
        }

        //ini yang kiri ke organic atau back lagi ges
        else{
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => const Organic(),
            ),
          );
        }

      },

      //tap kanan
      
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
                      //ini buat namanya "Organic"

                      //stack1
                      Stack( 
                        alignment : Alignment.center,
                        children:[
                          Transform.translate(
                            offset : const Offset(0, 7),
                              child : Text(
                              'Non-Organic', 
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
                        'Non-Organic',
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
                        'Non-Organic',
                        style: GoogleFonts.limelight(
                        fontSize: 40,
                        color: const Color(0xFF768973),
                        ),
                      ),
                        ],
                      ),

                      //ini stack 2 isinya deskripsi

                      
                      Transform.translate(
                        offset : const Offset(0, 12),
                        child : Stack(
                                                  alignment : Alignment.center,
                        children:[
                          Transform.translate(
                            offset : const Offset(0, 7),
                              child : Text(
                              'Recycle plastic, glass, metal, and paper to reduce pollution', 
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
                            'Recycle plastic, glass, metal, and paper to reduce pollution',
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
                            'Recycle plastic, glass, metal, and paper to reduce pollution',
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
                ),
            ],
          )
        )
      )
    ),
    );
  }
}