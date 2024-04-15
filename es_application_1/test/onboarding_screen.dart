import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/onboarding_screen.dart';
import '../lib/welcome_screen.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  testWidgets('Widget displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: OnboardingScreen(),
    ));

    expect(find.text('Love Your Planet'), findsOneWidget);
    expect(find.text('Recycle & Reuse'), findsOneWidget);
    expect(find.text('Green Commuting'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Get Started'), findsNothing);
  });

  testWidgets('Next button navigates to next page', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: OnboardingScreen(),
    ));

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Love Your Planet'), findsNothing);
    expect(find.text('Recycle & Reuse'), findsOneWidget);
    expect(find.text('Green Commuting'), findsNothing);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Get Started button completes onboarding and navigates to WelcomeScreen', (WidgetTester tester) async {
    final mockSharedPreferences = MockSharedPreferences();

    when(mockSharedPreferences.setBool('seenOnboarding', true)).thenAnswer((_) => Future.value(true));

    await tester.pumpWidget(MaterialApp(
      home: OnboardingScreen(),
    ));

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    verify(mockSharedPreferences.setBool('seenOnboarding', true)).called(1);
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
