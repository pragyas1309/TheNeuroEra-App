import 'package:flutter/material.dart';
import 'dart:async';

class Module4Screen extends StatefulWidget {
  const Module4Screen({super.key});

  @override
  State<Module4Screen> createState() => _Module4ScreenState();
}

class _Module4ScreenState extends State<Module4Screen> {
  int currentIndex = 0;
  int score = 0;
  int timeLeft = 25;
  bool showResult = false;
  Timer? timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question': "What does it mean when someone crosses their arms 😠?",
      'options': ['They are happy', 'They are nervous', 'They are angry', 'They are shy'],
      'answer': 'They are angry',
    },
    {
      'question': "Looking down while talking might mean?",
      'options': ['Confidence', 'Shyness', 'Excitement', 'Anger'],
      'answer': 'Shyness',
    },
    {
      'question': "Smiling with eye contact means?",
      'options': ['Confusion', 'Fear', 'Friendliness', 'Sadness'],
      'answer': 'Friendliness',
    },
    {
      'question': "Hands shaking could mean?",
      'options': ['Sleepy', 'Happy', 'Nervous', 'Excited'],
      'answer': 'Nervous',
    },
    {
      'question': "What does fidgeting often show?",
      'options': ['Boredom', 'Focus', 'Anger', 'Confidence'],
      'answer': 'Boredom',
    },
    {
      'question': "Someone avoiding eye contact could be?",
      'options': ['Trusting', 'Confident', 'Shy', 'Joyful'],
      'answer': 'Shy',
    },
    {
      'question': "What does a big smile 😊 usually mean?",
      'options': ['Pain', 'Sadness', 'Happiness', 'Fear'],
      'answer': 'Happiness',
    },
    {
      'question': "What does it mean if someone is clenching their fists ✊?",
      'options': ['Angry', 'Bored', 'Excited', 'Relaxed'],
      'answer': 'Angry',
    },
    {
      'question': "Arms wide open show?",
      'options': ['Rejection', 'Welcoming', 'Fear', 'Tiredness'],
      'answer': 'Welcoming',
    },
    {
      'question': "Biting nails often indicates?",
      'options': ['Joy', 'Nervousness', 'Confidence', 'Hunger'],
      'answer': 'Nervousness',
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
    if (percent >= 80) return "👏 You're great at reading body language!";
    if (percent >= 50) return "🙂 Nice! With practice, you'll get even better.";
    return "😕 Let’s work more on understanding body signals.";
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
        title: const Text('Module 4 - Body Language'),
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
