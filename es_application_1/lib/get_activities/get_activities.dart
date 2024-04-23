import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class ActivityManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  
  // Initialize variables with default values
  List<String> interests = [];
  double distance = 0;
  GeoPoint userLocation = GeoPoint(0, 0);

  ActivityManager() {
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(_currentUser.uid).get();
        interests = List<String>.from(userDoc.get('interests'));
        distance = userDoc.get('distance') * 1000 ?? 0;
        userLocation = userDoc.get('location') ?? GeoPoint(0, 0);
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<List<DocumentSnapshot>> getActivities() async {
    try {
      List<DocumentSnapshot> activities = [];
      QuerySnapshot postSnapshot = await _firestore.collection('posts').get();

      for (DocumentSnapshot postDoc in postSnapshot.docs) {
        List<String> postCategories = List<String>.from(postDoc.get('categories'));
        String creator = postDoc.get('user');
        if (_categoriesMatchInterests(postCategories, interests)) {
          double activityDistance = _calculateDistance(
            userLocation.latitude,
            userLocation.longitude,
            postDoc['location'].latitude,
            postDoc['location'].longitude,
          );

          if (activityDistance <= distance * 1000) { // Check distance
            if (_currentUser?.uid == creator){
              activities.add(postDoc);
            }
          }
        }
      }

      return activities;
    } catch (e) {
      print('Error fetching activities: $e');
      return [];
    }
  }


  bool _categoriesMatchInterests(List<String> activityCategories, List<String> userInterests) {
    for (String category in activityCategories) {
      if (userInterests.contains(category)) {
        return true;
      }
    }
    return false;
  }

  double _calculateDistance(double userLat, double userLon, double activityLat, double activityLon) {
    // Calculate distance between two points using Haversine formula
    const int earthRadius = 6371;
    double latDiff = _degreesToRadians(activityLat - userLat);
    double lonDiff = _degreesToRadians(activityLon - userLon);
    double a = 
        (sin(latDiff / 2) * sin(latDiff / 2)) +
        (cos(_degreesToRadians(userLat)) * cos(_degreesToRadians(activityLat)) *
        sin(lonDiff / 2) * sin(lonDiff / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
