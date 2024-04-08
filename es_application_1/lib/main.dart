import 'package:flutter/material.dart';
import 'register_screen.dart'; // Asegure-se de que este arquivo exista com o código atualizado que fornecerei.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoMobilize',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const RegisterScreen(), // Direciona diretamente para a tela de registro
    );
  }
}
