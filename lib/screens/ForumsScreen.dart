import 'package:flutter/material.dart';

class ForumsScreen extends StatelessWidget {
  const ForumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: const Center(
        child: Text(
          'Forums Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
