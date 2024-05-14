import 'package:es_application_1/firebase_options.dart';
import 'package:es_application_1/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  final mockFirestore = MockFirestoreInstance();
  final mockFirebaseAuth = MockFirebaseAuth();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  setUp(() async {
    await mockFirebaseAuth.signInWithEmailAndPassword(email: 'test@test.com', password: 'password');
    await mockFirestore.collection('users').doc(mockFirebaseAuth.currentUser!.uid).set({
      'username': 'TestUser',
      'profilePictureURL': 'http://example.com/image.png',
      'receiveEmailNotifications': true,
      'systemNotifications': true,
      'onlyNear': true,
      'lastTimeOn': true,
      'profilePhoto': true,
      'favourites': true,
    });
  });

  testWidgets('ProfileScreen has a title and shows profile information', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('TestUser'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Email Notifications: On'), findsOneWidget);
    expect(find.text('System Notifications : On'), findsOneWidget);
    expect(find.text('Only Near Activities : On'), findsOneWidget);
    expect(find.text('Activity: On'), findsOneWidget);
    expect(find.text('Profile Picture : On'), findsOneWidget);
    expect(find.text('My favourites : On'), findsOneWidget);
    expect(find.text('Send feedback'), findsOneWidget);
    expect(find.text('Delete account'), findsOneWidget);
  });
}
