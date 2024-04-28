import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:es_application_1/get_activities/get_activities.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



void main() {
  group('ActivityManager', () {
    test('should return true if any category matches interests', () async {
      // Arrange
      final firestore = FakeFirebaseFirestore();
      final manager = ActivityManager(firestore, null); // Pass null for user since we're not using it in this test
      await firestore.collection('users').add({
        'interests': ['Music', 'Movies'],
      });

      // Act
      bool result = manager.categoriesMatchInterests(['Sports', 'Music'], ['Music', 'Movies']);

      // Assert
      expect(result, true);
    });

    test('should return false if no category matches interests', () async {
      // Arrange
      final firestore = FakeFirebaseFirestore();
      final manager = ActivityManager(firestore, null); // Pass null for user since we're not using it in this test
      await firestore.collection('users').add({
        'interests': ['Music', 'Movies'],
      });

      // Act
      bool result = manager.categoriesMatchInterests(['Sports', 'Outdoors'], ['Music', 'Movies']);

      // Assert
      expect(result, false);
    });

    test('should calculate distance between two points accurately', () {
      // Arrange
      final firestore = FakeFirebaseFirestore();
      final manager = ActivityManager(firestore, null); // Pass null for firestore and user since we're not using them in this test
      double userLat = 52.520008;
      double userLon = 13.404954;
      double activityLat = 48.856613;
      double activityLon = 2.352222;

      // Act
      double distance = manager.calculateDistance(userLat, userLon, activityLat, activityLon);

      // Assert
      expect(distance, closeTo(879.69 , 5)); // Paris to Berlin distance in kilometers
    });

    test('should convert degrees to radians correctly', () {
      // Arrange
      final firestore = FakeFirebaseFirestore();
      final manager = ActivityManager(firestore, null); // Pass null for firestore and user since we're not using them in this test
      double degrees = 90;

      // Act
      double radians = manager.degreesToRadians(degrees);

      // Assert
      expect(radians, closeTo(1.5708, 0.0001)); // Expected value of pi/2
    });

    test('fetches user data and filters activities correctly', () async {
      // Mock user data
      final fakeFirestore = FakeFirebaseFirestore();
      final user = MockUser(
        isAnonymous: false,
        uid: 'user123',
      );
      await fakeFirestore.collection('users').doc(user.uid).set({
        'interests': ['Music', 'Movies'],
        'distance': 10.0, // Convert to double
        'location': GeoPoint(52.520008, 13.404954), // Berlin coordinates
      });

      // Mock activity data
      await fakeFirestore.collection('posts').doc('activity1').set({
        'categories': ['Music', 'Sports'],
        'user': 'anotherUser',
        'location': GeoPoint(52.520008, 13.404954), // Berlin coordinates
      });

      await fakeFirestore.collection('posts').doc('activity2').set({
        'categories': ['Outdoors'],
        'user': 'anotherUser',
        'location': GeoPoint(48.856613, 2.352222), // Paris coordinates
      });

      final manager = ActivityManager(fakeFirestore, user);

      await expectLater(manager.fetchUserData(), completes);

      final activities = await manager.getActivities();

      expect(activities.length, 1);
      expect(activities.first.id, 'activity1');
    });
  });
}
