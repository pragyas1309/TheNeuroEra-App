import 'package:flutter/material.dart';

class LearnPracticeScreen extends StatelessWidget {
  const LearnPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> modules = [
      {"title": "Module 1", "subtitle": "Emotions & Faces", "score": 10, "time": "30s", "color": Colors.lightBlue},
      {"title": "Module 2", "subtitle": "Kindness & Empathy", "score": 12, "time": "30s", "color": Colors.orangeAccent},
      {"title": "Module 3", "subtitle": "Color Recognition", "score": 15, "time": "20s", "color": Colors.purpleAccent},
      {"title": "Module 4", "subtitle": "Body Language", "score": 12, "time": "30s", "color": Colors.orange},
      {"title": "Module 5", "subtitle": "Situational Reaction", "score": 15, "time": "25s", "color": Colors.tealAccent},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text('Learning Modules'),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/module${index + 1}');
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: module['color'] as Color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text("${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(module['subtitle'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Text("Score: ${module['score']}"),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Icon(Icons.timer, color: Colors.white),
                      Text(module['time'] as String, style: const TextStyle(color: Colors.white)),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
