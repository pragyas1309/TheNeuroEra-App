import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:lottie/lottie.dart'; // 🔒 Lottie disabled for now

class TherapistDashboard extends StatelessWidget {
  const TherapistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔝 Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Therapist Dashboard",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.account_circle, size: 30, color: Colors.deepPurple),
                      onSelected: (value) {
                        if (value == 'Logout') {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Logout', child: Text('Logout')),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTile(context, label: 'Therapist Profile', color: Colors.pink[100]!, onTap: () { Navigator.pushNamed(context, '/therapistProfile');}),
                    _buildTile(context, label: 'Upcoming Sessions', color: Colors.purple[100]!, onTap: () {}),

                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTile(context, label: 'Chat / Messages', color: Colors.orange[100]!, onTap: () {}),
                    _buildTile(context, label: 'Progress Reports', color: Colors.green[100]!, onTap: () {}),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTile(context, label: 'Add Session Notes', color: Colors.blue[100]!, onTap: () {Navigator.pushNamed(context, '/addSessionNotes');}),
                    _buildTile(
                      context,
                      label: 'Log Out',
                      color: Colors.red[100]!,
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
      BuildContext context, {
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 160,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Lottie placeholder
            Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white54,
              ),
              child: const Icon(Icons.image, size: 30, color: Colors.deepPurple),
              // child: Lottie.asset(lottiePath, fit: BoxFit.contain), // 🔒 Temporarily disabled
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
