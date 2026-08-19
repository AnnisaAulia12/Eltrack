import 'package:flutter/material.dart';

class loadingPage extends StatelessWidget {
  const loadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFDF6ED),

      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}