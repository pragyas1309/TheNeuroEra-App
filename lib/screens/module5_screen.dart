import 'package:flutter/material.dart';
import 'dart:async';

class Module5Screen extends StatefulWidget {
  const Module5Screen({super.key});

  @override
  State<Module5Screen> createState() => _Module5ScreenState();
}

class _Module5ScreenState extends State<Module5Screen> {
  int currentQuestion = 0;
  int score = 0;
  bool showResult = false;
  int timeLeft = 25;
  Timer? timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Your friend is crying in the classroom 😢. What do you do?',
      'options': ['Ignore them 🙄', 'Ask what happened 🤔', 'Laugh 😂', 'Walk away 🚶‍♂️'],
      'answer': 'Ask what happened 🤔'
    },
    {
      'question': 'You lost your favorite toy 🧸. What should you do?',
      'options': ['Cry loudly 😭', 'Tell someone 🧑‍🏫', 'Break things 😡', 'Hide 😶'],
      'answer': 'Tell someone 🧑‍🏫'
    },
    {
      'question': 'Someone pushes you in the line 🧍. You should...',
      'options': ['Push back 😠', 'Tell a teacher 👩‍🏫', 'Shout 🤬', 'Run away 🏃‍♂️'],
      'answer': 'Tell a teacher 👩‍🏫'
    },
    {
      'question': 'Your friend shares their lunch 🍱 with you. What do you say?',
      'options': ['Nothing 😐', 'Yuck 🤢', 'Thank you 😊', 'I want more 😤'],
      'answer': 'Thank you 😊'
    },
    {
      'question': 'You feel sad 😔 but no one is around. What helps?',
      'options': ['Talk to yourself 🗣️', 'Scribble ✏️', 'Punch something 😠', 'Stay sad 🙁'],
      'answer': 'Scribble ✏️'
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        checkAnswer(null); // move to next if time is over
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  void checkAnswer(String? selected) {
    timer?.cancel(); // stop the timer

    if (selected == questions[currentQuestion]['answer']) {
      score++;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        timeLeft = 25;
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
    if (percent >= 80) return "🎉 Great job! You handle situations well!";
    if (percent >= 50) return "🙂 Nice effort. You’re learning empathy!";
    return "😟 It’s okay. Let's practice more and try again!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text("Situational Reaction"),
        backgroundColor: Colors.brown,
      ),
      body: showResult
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Score: $score / ${questions.length}", style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 12),
            Text(getFeedback(), style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentQuestion = 0;
                  score = 0;
                  showResult = false;
                  timeLeft = 25;
                });
                startTimer();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              child: const Text("Retry"),
            )
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Time Left: $timeLeft s", style: const TextStyle(fontSize: 16, color: Colors.red)),
            const SizedBox(height: 12),
            Text("Q${currentQuestion + 1}: ${questions[currentQuestion]['question']}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            ...questions[currentQuestion]['options'].map<Widget>((option) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[200],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
