import 'package:flutter/material.dart';
import 'features/home/pages/home_page.dart';


class EltrackApp extends StatelessWidget{
  const EltrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}