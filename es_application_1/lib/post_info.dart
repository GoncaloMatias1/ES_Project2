import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Tests Done

class ActivityDetailPage extends StatefulWidget {
  final String activityId;

  const ActivityDetailPage({Key? key, required this.activityId}) : super(key: key);

  @override
  ActivityDetailPageState createState() => ActivityDetailPageState();

  ActivityDetailPageState getState() {
    return ActivityDetailPageState();
  }
}

class ActivityDetailPageState extends State<ActivityDetailPage>{
  Future<Map<String, dynamic>> loadData(String activityId) async {
    final user = FirebaseAuth.instance.currentUser;
    final activitySnapshot = await FirebaseFirestore.instance.collection('posts').doc(activityId).get();
    final userDataSnapshot = await FirebaseFirestore.instance.collection('users').doc(activitySnapshot['user']).get();

    if (!activitySnapshot.exists || !userDataSnapshot.exists) {
      throw Exception('Error: Activity or user data not found');
    }

    final activityData = activitySnapshot.data()!;
    final userData = userDataSnapshot.data()!;

    final String activityName = activityData['activityName'];
    final String description = activityData['description'];
    final GeoPoint location = activityData['location'] as GeoPoint;
    final List<dynamic> categories = activityData['categories'];
    final String startTime = activityData['startTime'] as String;
    final String endTime = activityData['endTime'] as String;
    final Timestamp timestamp = activityData['date'] as Timestamp;

    final DateTime date = timestamp.toDate();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formattedDate = formatter.format(date);

    final String userName = '${userData['firstName']} ${userData['lastName']}';
    final String userProfilePhoto = userData['profilePictureURL'] ?? '';

    // Check if the user has already liked the post
    bool isLiked = false;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userData.exists) {
        final likedActivities = userData.data()?['liked'] as List<dynamic>? ?? [];
        isLiked = likedActivities.contains(activityId);
      }
    }

    bool isFavorite = false;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userData.exists) {
        final favoriteActivities = userData.data()?['favorites'] as List<dynamic>? ?? [];
        isFavorite = favoriteActivities.contains(activityId);
      }
    }

    bool isSubscribed = false;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userData.exists) {
        final likedActivities = userData.data()?['liked'] as List<dynamic>? ?? [];
        isLiked = likedActivities.contains(activityId);
        final subscribedActivities = userData.data()?['subscribed'] as List<dynamic>? ?? [];
        isSubscribed = subscribedActivities.contains(activityId);
      }
    }

    return {
      'activityName': activityName,
      'description': description,
      'location': location,
      'categories': categories,
      'startTime': startTime,
      'endTime': endTime,
      'date': formattedDate,
      'userName': userName,
      'userProfilePhoto': userProfilePhoto,
      'isLiked': isLiked,
      'isFavorite': isFavorite,
      'isSubscribed': isSubscribed,
    };
  }

  Future<void> handleLikeButtonPress(String postId, bool isLiked) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = await userRef.get();
      if (userData.exists) {
        List<dynamic> likedActivities = userData.data()?['liked'] as List<dynamic>? ?? [];

        if (isLiked) {
          likedActivities.remove(postId);
        } else {
          likedActivities.add(postId);
        }
        await userRef.update({'liked': likedActivities});

        // Update liked field in 'posts' collection
        final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
        final postData = await postRef.get();
        if (postData.exists) {
          List<dynamic> postLikedBy = postData.data()?['liked'] as List<dynamic>? ?? [];
          
          if (isLiked) {
            postLikedBy.remove(user.uid);
          } else {
            postLikedBy.add(user.uid);
          }

          await postRef.update({'liked': postLikedBy});
        }
      }
    }
    setState(() {
      isLiked = !isLiked;
    });
  }

  Future<void> handleFavoriteButtonPress(String postId, bool isFavorite) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = await userRef.get();
      if (userData.exists) {
        var currentFavorites = userData.data()?['favorites'] as List<dynamic>? ?? [];
        if (isFavorite) {
          currentFavorites.remove(postId);
        } else {
          if (!currentFavorites.contains(postId)) {
            currentFavorites.add(postId);
          }
        }
        await userRef.update({'favorites': currentFavorites});
      }
      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }

  Future<void> handleSubscribeButtonPress(String postId, bool isSubscribed) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = await userRef.get();
      if (userData.exists) {
        List<dynamic> subscribedActivities = userData.data()?['subscribed'] as List<dynamic>? ?? [];

        if (isSubscribed) {
          subscribedActivities.remove(postId);
        } else {
          subscribedActivities.add(postId);
        }
        await userRef.update({'subscribed': subscribedActivities});

        // Update the 'posts' collection
        final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
        final postData = await postRef.get();
        if (postData.exists) {
          List<dynamic> postSubscribedBy = postData.data()?['subscribed'] as List<dynamic>? ?? [];
          
          if (isSubscribed) {
            postSubscribedBy.remove(user.uid);
          } else {
            postSubscribedBy.add(user.uid);
          }
          await postRef.update({'subscribed': postSubscribedBy});
        }
      }
    }
    setState(() {
      isSubscribed = !isSubscribed;
    });
  }



  String formatCoordinate(double coordinate) {
    final formattedCoordinate = coordinate.abs().toStringAsFixed(7);
    return formattedCoordinate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Details'),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: FutureBuilder<Map<String, dynamic>>(
          future: loadData(widget.activityId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Error: Activity not found'));
            }

            final data = snapshot.data!;
            final LatLng activityLocation = LatLng(data['location'].latitude, data['location'].longitude);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: data['userProfilePhoto'] == '' ? Colors.green[700] : null,
                      backgroundImage: data['userProfilePhoto'] != ''
                          ? NetworkImage(data['userProfilePhoto'])
                          : null,
                      child: data['userProfilePhoto'] == ''
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data['userName'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data['activityName'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.green[900]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Description: ${data['description']}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location:',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 150,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: activityLocation,
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId('activity_location'),
                                  position: activityLocation,
                                ),
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Coordinates: [${formatCoordinate(data['location'].latitude)}° ${data['location'].latitude >= 0 ? 'N' : 'S'}, ${formatCoordinate(data['location'].longitude)}° ${data['location'].longitude >= 0 ? 'E' : 'W'}]',
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start Time: ${data['startTime']}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            'End Time: ${data['endTime']}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Date: ${data['date']}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Categories: ${data['categories'].join(', ')}',
                        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up, color: data['isLiked'] ? Colors.blue : null),
                          onPressed: () {
                            handleLikeButtonPress(widget.activityId, data['isLiked']);
                          },
                        ),
                        IconButton(
                          icon: Icon(data['isFavorite'] ? Icons.favorite : Icons.favorite_border, color: data['isFavorite'] ? Colors.red : null),
                          onPressed: () {
                            handleFavoriteButtonPress(widget.activityId, data['isFavorite']);
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            handleSubscribeButtonPress(widget.activityId, data['isSubscribed']);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              data['isSubscribed'] ? 'Unsubscribe' : 'Subscribe',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
