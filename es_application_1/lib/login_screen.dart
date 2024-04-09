import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 80.0),
              Text(
                'Welcome back to EcoMobilize!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.green),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.green),
                  suffixIcon: const Icon(Icons.visibility_off, color: Colors.green),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                },
                child: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 20.0),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                },
                child: const Text('Forgot Password?'),
                style: TextButton.styleFrom(
                  primary: Colors.green[800],
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
