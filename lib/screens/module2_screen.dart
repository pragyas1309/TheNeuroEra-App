import 'package:flutter/material.dart';
import 'dart:async';

class Module2Screen extends StatefulWidget {
  const Module2Screen({super.key});

  @override
  State<Module2Screen> createState() => _Module2ScreenState();
}

class _Module2ScreenState extends State<Module2Screen> {
  int currentIndex = 0;
  int score = 0;
  int timeLeft = 25;
  bool showResult = false;
  Timer? timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question': "Your classmate forgets their lunch. What should you do?",
      'options': ['Ignore 🙄', 'Share your lunch 🍱', 'Laugh 😂', 'Tease 😜'],
      'answer': 'Share your lunch 🍱',
    },
    {
      'question': "A new student joins your class. What’s a kind way to help?",
      'options': ['Avoid them 🙈', 'Say hi and smile 😊', 'Mock them 🤭', 'Walk away 🚶‍♀️'],
      'answer': 'Say hi and smile 😊',
    },
    {
      'question': "What does empathy mean?",
      'options': ['Understanding how others feel 💭', 'Shouting to get attention 📢', 'Feeling nothing 😶', 'Always being right 😎'],
      'answer': 'Understanding how others feel 💭',
    },
    {
      'question': "Someone is crying in the hallway. What do you say?",
      'options': ['“Stop crying” 😒', '“Are you okay?” 🤗', '“Don’t bother me” 🙄', '“Be quiet” 🤐'],
      'answer': '“Are you okay?” 🤗',
    },
    {
      'question': "You helped a friend. What could they say?",
      'options': ['“Thanks!” 😊', '“Why did you help?” 🤔', '“Go away” 😤', 'Nothing 😶'],
      'answer': '“Thanks!” 😊',
    },
    {
      'question': "How do you show kindness?",
      'options': ['By caring 💕', 'By shouting 😡', 'By ignoring 🫥', 'By pushing 😠'],
      'answer': 'By caring 💕',
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
    if (percent >= 80) return "💖 You're truly kind and thoughtful!";
    if (percent >= 50) return "🙂 Nice! You're learning to be kinder.";
    return "😟 Let's practice kindness again. You got this!";
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
        title: const Text('Module 2 - Kindness & Empathy'),
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
