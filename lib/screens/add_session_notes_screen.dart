import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSessionNotesScreen extends StatefulWidget {
  const AddSessionNotesScreen({super.key});

  @override
  State<AddSessionNotesScreen> createState() => _AddSessionNotesScreenState();
}

class _AddSessionNotesScreenState extends State<AddSessionNotesScreen> {
  final TextEditingController _notesController = TextEditingController();
  bool _saving = false;

  Future<void> saveNote() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final text = _notesController.text.trim();

    if (uid == null || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note cannot be empty.")),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      await FirebaseFirestore.instance
          .collection('therapists')
          .doc(uid)
          .collection('notes')
          .add({
        'note': text,
        'timestamp': Timestamp.now(),
      });

      _notesController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note saved successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving note: $e")),
      );
    }

    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text("Add Session Notes"),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Write your session note below:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "Type your note...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Note"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
