import 'package:es_application_1/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  group('LoginScreen Tests', () {
    final mockFirebaseAuth = MockFirebaseAuth();

    testWidgets('Email and password fields exist', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      expect(find.byType(TextFormField), findsNWidgets(2)); // Deve encontrar dois TextFormFields.
    });

    testWidgets('Login button starts login process', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
    });
  });
}

//flutter test test/login_screen_test.dart para rodar este teste