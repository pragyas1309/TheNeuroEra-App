import 'package:flutter/material.dart';
import 'dart:async';

class Module1Screen extends StatefulWidget {
  const Module1Screen({super.key});

  @override
  State<Module1Screen> createState() => _Module1ScreenState();
}

class _Module1ScreenState extends State<Module1Screen> {
  int currentIndex = 0;
  int score = 0;
  int timeLeft = 25;
  bool showResult = false;
  Timer? timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question': "Which face shows happiness?",
      'options': ['😢', '😠', '😀', '😐'],
      'answer': '😀',
    },
    {
      'question': "Which face shows anger?",
      'options': ['😃', '😡', '😭', '😴'],
      'answer': '😡',
    },
    {
      'question': "Which face looks confused?",
      'options': ['🤔', '😄', '😣', '😎'],
      'answer': '🤔',
    },
    {
      'question': "Which one is a sad face?",
      'options': ['😢', '😁', '😇', '😅'],
      'answer': '😢',
    },
    {
      'question': "Which face looks surprised?",
      'options': ['😲', '😋', '😏', '😒'],
      'answer': '😲',
    },
    {
      'question': "Identify the relaxed face.",
      'options': ['😌', '😬', '😤', '😡'],
      'answer': '😌',
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel(); // cancel any previous timers
    timeLeft = 25;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        checkAnswer(null); // time up, auto move
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
    if (percent >= 80) return "🌟 Great job recognizing emotions!";
    if (percent >= 50) return "🙂 Good effort! Keep practicing.";
    return "😟 Let’s try again and learn more!";
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
        title: const Text('Module 1 - Emotions & Faces'),
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
                  child: Text(option, style: const TextStyle(fontSize: 16)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
