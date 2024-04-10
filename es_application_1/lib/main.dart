import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'welcome_screen.dart';
import 'main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if the user's email and password are stored in local storage
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? storedEmail = prefs.getString('email');
  final String? storedPassword = prefs.getString('password');

  if (storedEmail != null && storedPassword != null) {
    try {
      // Attempt to sign in with stored credentials
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: storedEmail,
        password: storedPassword,
      );
    } catch (e) {
      // Handle any errors during auto-login attempt
      print('Auto-login failed: $e');
    }
  }

  runApp(MyApp(storedEmail: storedEmail, storedPassword: storedPassword));
}

class MyApp extends StatelessWidget {
  final String? storedEmail;
  final String? storedPassword;

  const MyApp({Key? key, this.storedEmail, this.storedPassword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = storedEmail != null && storedPassword != null;

    return MaterialApp(
      title: 'EcoMobilize',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // Navigate based on login state
      home: isLoggedIn ? MainPage() : const WelcomeScreen(),
    );
  }
}
