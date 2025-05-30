import 'package:flutter/material.dart';
import 'dart:async';

class Module3Screen extends StatefulWidget {
  const Module3Screen({super.key});

  @override
  State<Module3Screen> createState() => _Module3ScreenState();
}

class _Module3ScreenState extends State<Module3Screen> {
  int currentIndex = 0;
  int score = 0;
  int timeLeft = 25;
  bool showResult = false;
  Timer? timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question': "🍌 What is the color of a banana?",
      'options': ['Yellow', 'Red', 'Green', 'Purple'],
      'answer': 'Yellow',
    },
    {
      'question': "🍎 Apples are usually...",
      'options': ['Blue', 'Red', 'Brown', 'Black'],
      'answer': 'Red',
    },
    {
      'question': "🟩 Which one is green?",
      'options': ['Sky', 'Grass', 'Fire', 'Sand'],
      'answer': 'Grass',
    },
    {
      'question': "🟦 Which of these things is usually blue?",
      'options': ['Tomato', 'Sunflower', 'Sky', 'Chocolate'],
      'answer': 'Sky',
    },
    {
      'question': "🚗 What color is a classic stop sign?",
      'options': ['Yellow', 'Red', 'White', 'Pink'],
      'answer': 'Red',
    },
    {
      'question': "🎃 What color is a pumpkin?",
      'options': ['Orange', 'Blue', 'Green', 'Purple'],
      'answer': 'Orange',
    },
    {
      'question': "🦋 Butterflies can be many colors. What color is shown here?",
      'options': ['Purple', 'Orange', 'Blue', 'Black'],
      'answer': 'Blue',
    },
    {
      'question': "What color is the 🌞 sun?",
      'options': ['Red', 'Blue', 'Yellow', 'Green'],
      'answer': 'Yellow',
    },
    {
      'question': "🧊 Ice is usually...",
      'options': ['Black', 'White', 'Blue', 'Grey'],
      'answer': 'White',
    },
    {
      'question': "🧱 What color is a brick?",
      'options': ['Red', 'Green', 'Yellow', 'Blue'],
      'answer': 'Red',
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 25;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        checkAnswer(null);
      }
    });
  }

  void checkAnswer(String? selected) {
    timer?.cancel();
    if (selected != null && selected == questions[currentIndex]['answer']) {
      score++;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
      startTimer();
    } else {
      setState(() {
        showResult = true;
      });
    }
  }

  String getFeedback() {
    double percent = (score / questions.length) * 100;
    if (percent >= 80) return "🎨 You know your colors very well!";
    if (percent >= 50) return "🙂 Great! But let’s try again for perfection.";
    return "😟 Let’s practice more with colors.";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('Module 3 - Color Recognition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: showResult
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Score: $score / ${questions.length}",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                getFeedback(),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                    score = 0;
                    showResult = false;
                    timeLeft = 25;
                  });
                  startTimer();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown),
                child: const Text("Retry"),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time Left: $timeLeft s",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
            const SizedBox(height: 12),
            Text(
              "Q${currentIndex + 1}: ${questions[currentIndex]['question']}",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ...questions[currentIndex]['options'].map<Widget>((option) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[300],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child:
                  Text(option, style: const TextStyle(fontSize: 16)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
