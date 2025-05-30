// AddTherapistProfileScreen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTherapistProfileScreen extends StatefulWidget {
  const AddTherapistProfileScreen({super.key});

  @override
  State<AddTherapistProfileScreen> createState() => _AddTherapistProfileScreenState();
}

class _AddTherapistProfileScreenState extends State<AddTherapistProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();

  void saveTherapistProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final uid = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance.collection('therapists').doc(uid).set({
          'name': FirebaseAuth.instance.currentUser!.displayName ?? '',
          'email': FirebaseAuth.instance.currentUser!.email ?? '',
          'specialization': _specializationController.text.trim(),
          'experience': _experienceController.text.trim(),
          'bio': _bioController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved!')),
        );

        Navigator.pop(context);
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(title: const Text("Add Therapist Info"), backgroundColor: Colors.brown),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: "Specialization"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: "Experience (in years)"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: "Short Bio"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveTherapistProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
                child: const Text("Save Profile"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
