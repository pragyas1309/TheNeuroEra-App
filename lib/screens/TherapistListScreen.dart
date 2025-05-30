// TherapistListScreen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';

class TherapistListScreen extends StatelessWidget {
  const TherapistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text("Available Therapists"),
        backgroundColor: Colors.brown,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('therapists').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final therapistId = docs[index].id;
              final name = data['name'] ?? 'Therapist';
              final specialization = data['specialization'] ?? '';
              final experience = data['experience'] ?? '';
              final bio = data['bio'] ?? '';

              return ListTile(
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Specialization: $specialization\nExperience: $experience years\n$bio"),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          therapistId: therapistId,
                          therapistName: name,
                        ),
                      ),
                    );
                  },
                  child: const Text("Chat"),
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
