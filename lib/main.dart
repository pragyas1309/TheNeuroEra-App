import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';


import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/edit_screen.dart';
import 'screens/convert_screen.dart';
import 'screens/user_dashboard.dart';
import 'screens/therapist_dashboard.dart';
import 'screens/EmailOTPScreen.dart';
import 'screens/RoleSelectionScreen.dart';
import 'screens/ForumsScreen.dart';
import 'screens/LearnPracticeScreen.dart'; // ✅ You are keeping this name
import 'screens/AskAiScreen.dart';
import 'screens/TherapyScreen.dart';
import 'screens/add_session_notes_screen.dart';
import 'screens/module1_screen.dart';
import 'screens/module2_screen.dart';
import 'screens/module3_screen.dart';
import 'screens/module4_screen.dart';
import 'screens/module5_screen.dart';
//import 'screens/therapy_screen.dart';
import 'screens/TherapistListScreen.dart';
import 'screens/AddTherapistProfileScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'neuroera',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'ComicSans', // Optional custom font
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/selectRole': (context) => const RoleSelectionScreen(),
        '/signup': (context) {
          final role = ModalRoute.of(context)!.settings.arguments as String;
          return SignUpScreen(role: role);
        },
        '/emailOtp': (context) => const EmailOTPScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/userDashboard': (context) => const UserDashboard(),
        '/therapistDashboard': (context) => const TherapistDashboard(),
        '/askai': (context) => const AskAiScreen(),
        '/learn': (context) => const LearnPracticeScreen(), // keep for quizzes
        '/modules': (context) => const LearnPracticeScreen(), // ✅ used for module selection screen
        '/therapy': (context) => const TherapyScreen(),
        '/forums': (context) => const ForumsScreen(),
        '/addSessionNotes': (context) => const AddSessionNotesScreen(),
        '/module1': (context) => const Module1Screen(),
        '/module2': (context) => const Module2Screen(),
        '/module3': (context) => const Module3Screen(),
        '/module4': (context) => const Module4Screen(),
        '/module5': (context) => const Module5Screen(),
        '/therapistList': (context) => const TherapistListScreen(),
        '/therapistProfile': (context) => const AddTherapistProfileScreen(),
      },
    );
  }
}
