import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void navigateToDashboard(String role) {
    if (role == 'Therapist') {
      Navigator.pushReplacementNamed(context, '/therapistDashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/userDashboard');
    }
  }

  Future<void> loginWithEmail(String role) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!userCredential.user!.emailVerified) {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verify your email before login.')),
        );
        return;
      }

      navigateToDashboard(role);
    } catch (e) {
      print('Login Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Check credentials.')),
      );
    }
  }

  Future<void> signInWithGoogle(String role) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider provider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      navigateToDashboard(role);
    } catch (e) {
      print('Google Sign-In Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // your light brown theme
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome back!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 10),
            Lottie.asset('assets/animations/cat1.json', height: 140),

            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  if (_emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter email to reset password.")),
                    );
                  } else {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: _emailController.text.trim(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password reset link sent.")),
                    );
                  }
                },
                child: const Text('Forgot your password?', style: TextStyle(color: Colors.brown)),
              ),
            ),

            // 🔐 Login Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => loginWithEmail('User'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Login as User'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => loginWithEmail('Therapist'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Login as Therapist', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text("or connect with", style: TextStyle(color: Colors.brown)),

            const SizedBox(height: 14),

            // Google Sign-In Row (Mini Buttons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => signInWithGoogle('User'),
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    side: const BorderSide(color: Colors.brown),
                  ),
                  child: Image.asset('assets/images/google_logo.webp', height: 28),
                ),
                OutlinedButton(
                  onPressed: () => signInWithGoogle('Therapist'),
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    side: const BorderSide(color: Colors.brown),
                  ),
                  child: Image.asset('assets/images/google_logo.webp', height: 28),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?", style: TextStyle(color: Colors.brown)),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/selectRole');
                  },
                  child: const Text('Sign up', style: TextStyle(color: Colors.deepPurple)),
                ),
                Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                child: Text(
                'Developed by Pragya Sharma',
                style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
               ),
                ),
                ),
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}
