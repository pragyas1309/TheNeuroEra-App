import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String userName = "User";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userName = userDoc.data()?['name'] ?? "User";
      });
    }
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'Profile':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile coming soon...')),
        );
        break;
      case 'Support':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Support screen coming soon...')),
        );
        break;
      case 'Logout':
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }

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
              children: [
                // 🔝 Top row with greeting + profile dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Hi $userName,\nHow can I help you today?",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.account_circle, size: 30, color: Colors.brown),
                      onSelected: _handleMenuSelection,
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Profile', child: Text('Profile')),
                        const PopupMenuItem(value: 'Support', child: Text('Support?')),
                        const PopupMenuItem(value: 'Logout', child: Text('Logout')),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // First Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDashboardTile(
                      title: "Learn & Practice",
                      color: Colors.amber[100]!,
                      lottiePath: 'assets/animations/learn.json',
                      onTap: () => Navigator.pushNamed(context, '/learn'),
                    ),
                    _buildDashboardTile(
                      title: "Ask AI",
                      color: Colors.orange[200]!,
                      lottiePath: 'assets/animations/askai.json',
                      onTap: () => Navigator.pushNamed(context, '/askai'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Second Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDashboardTile(
                      title: "Therapy",
                      color: Colors.green[200]!,
                      lottiePath: 'assets/animations/therapy.json',
                      onTap: () => Navigator.pushNamed(context, '/therapy'),
                    ),
                    _buildDashboardTile(
                      title: "Forums",
                      color: Colors.brown[200]!,
                      lottiePath: 'assets/animations/forum.json',
                      onTap: () => Navigator.pushNamed(context, '/forums'),
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

  Widget _buildDashboardTile({
    required String title,
    required Color color,
    required VoidCallback onTap,
    required String lottiePath,
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
            SizedBox(
              height: 60,
              width: 60,
              child: Lottie.asset(
                lottiePath,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
