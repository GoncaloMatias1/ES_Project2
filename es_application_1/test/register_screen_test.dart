import 'package:es_application_1/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  group('RegisterScreen Tests', () {
    final mockFirebaseAuth = MockFirebaseAuth();

    testWidgets('Email and password fields are present and can be entered', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterScreen()));

      expect(find.byType(TextFormField), findsNWidgets(2)); // Verifica a presença de dois campos de texto.

      //   . entrar com texto nos campos de texto.
      await tester.enterText(find.byType(TextFormField).at(0), 'newuser@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'newpassword');

      expect(find.text('newuser@example.com'), findsOneWidget);
      expect(find.text('newpassword'), findsOneWidget);
    });

    testWidgets('Register button attempts to create a new user', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterScreen()));

      // Entra com algum texto nos campos de e-mail e senha.
      await tester.enterText(find.byType(TextFormField).at(0), 'newuser@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'newpassword');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
    });
  });
}
