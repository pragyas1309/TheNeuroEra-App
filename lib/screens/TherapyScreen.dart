import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key});

  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _concernController = TextEditingController();

  List<String> symptoms = [];
  final List<String> symptomOptions = [
    "Anxiety", "Low mood", "Inattention", "Sleep issues", "Overthinking"
  ];

  // ✅ SUBMIT and SAVE to Firestore
  void submitTherapyRequest() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('therapy_requests').add({
          'diagnosis': _diagnosisController.text.trim(),
          'symptoms': symptoms,
          'concern': _concernController.text.trim(),
          'userId': FirebaseAuth.instance.currentUser?.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.pushNamed(context, '/therapistList');
      } catch (e) {
        print("Error submitting therapy request: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to submit. Try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text("Therapy Consultation"),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Select Your Symptoms:", style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 8,
                children: symptomOptions.map((symptom) {
                  final isSelected = symptoms.contains(symptom);
                  return FilterChip(
                    label: Text(symptom),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        isSelected
                            ? symptoms.remove(symptom)
                            : symptoms.add(symptom);
                      });
                    },
                    selectedColor: Colors.brown[300],
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _diagnosisController,
                decoration: const InputDecoration(
                  labelText: "What is your diagnosis (if known)?",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                val!.isEmpty ? "Please enter a diagnosis or N/A" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _concernController,
                decoration: const InputDecoration(
                  labelText: "What would you like to talk about?",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (val) =>
                val!.isEmpty ? "Please describe your concern" : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: submitTherapyRequest,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text("Continue to Therapists"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
