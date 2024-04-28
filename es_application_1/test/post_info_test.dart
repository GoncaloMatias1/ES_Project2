import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import '.../activity_detail_page.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('ActivityDetailPage Tests', () {
    test('Load data successfully', () async {
      final mockFirestore = MockFirebaseFirestore();
      final mockFirebaseAuth = MockFirebaseAuth();

      when(mockFirebaseAuth.currentUser).thenReturn(MockUser(uid: '123'));
      when(mockFirestore.collection('posts').doc(any)).thenAnswer(
            (_) async => MockDocumentSnapshot(
          data: {
            'activityName': 'Test Activity',
            'description': 'This is a test',
          },
        ),
      );
      when(mockFirestore.collection('users').doc(any)).thenAnswer(
            (_) async => MockDocumentSnapshot(
          data: {
            'firstName': 'Test',
            'lastName': 'User',
          },
        ),
      );

      final activityDetailPageState = _ActivityDetailPageState();
      final data = await activityDetailPageState.loadData('activityId');

      expect(data['activityName'], 'Test Activity');
      expect(data['description'], 'This is a test');
    });

  });
}
