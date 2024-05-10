import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventConfirmationPage extends StatelessWidget {
  final String postId;

  EventConfirmationPage({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Participation'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').doc(postId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Post not found'));
          }

          var postData = snapshot.data!.data() as Map<String, dynamic>;
          Timestamp eventDate = postData['date'];
          String startTime = postData['startTime'];
          String endTime = postData['endTime'];
          List<String> subscribedUsers = List<String>.from(postData['subscribed'] ?? []);
          List<String> participatedUsers = List<String>.from(postData['participated'] ?? []);

          // Get current date and time
          DateTime now = DateTime.now();

          // Parse start time and end time strings
          DateTime activityStartTime = DateTime.parse('${eventDate.toDate().toString().substring(0, 10)} $startTime:00');
          DateTime activityEndTime = DateTime.parse('${eventDate.toDate().toString().substring(0, 10)} $endTime:00');

          // Check if current time is within activity start and end time
          bool isActivityOngoing = now.isAfter(activityStartTime) && now.isBefore(activityEndTime);

          if (isActivityOngoing) {
            return ListView.builder(
              itemCount: subscribedUsers.length,
              itemBuilder: (context, index) {
                String userId = subscribedUsers[index];
                bool isParticipated = participatedUsers.contains(userId);
                return ListTile(
                  leading: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar();
                      }
                      if (!snapshot.hasData) {
                        return CircleAvatar();
                      }
                      var userData = snapshot.data!.data() as Map<String, dynamic>;
                      String profilePictureURL = userData['profilePictureURL'] ?? '';
                      return CircleAvatar(
                        backgroundImage: NetworkImage(profilePictureURL),
                      );
                    },
                  ),
                  title: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      }
                      if (!snapshot.hasData) {
                        return Text('User not found');
                      }
                      var userData = snapshot.data!.data() as Map<String, dynamic>;
                      String firstName = userData['firstName'] ?? '';
                      String lastName = userData['lastName'] ?? '';
                      return Text('$firstName $lastName');
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isParticipated && postData['onTime'],
                        onChanged: (value) {
                          if (value != null) {
                            // Update participated users list in the database
                            FirebaseFirestore.instance.collection('posts').doc(postId).update({
                              'participated': FieldValue.arrayUnion([userId]),
                              'onTime': value,
                            });
                          }
                        },
                      ),
                      Text('On time'),
                      SizedBox(width: 10),
                      Checkbox(
                        value: isParticipated && !postData['onTime'],
                        onChanged: (value) {
                          if (value != null) {
                            // Update participated users list in the database
                            FirebaseFirestore.instance.collection('posts').doc(postId).update({
                              'participated': FieldValue.arrayUnion([userId]),
                              'onTime': !value,
                            });
                          }
                        },
                      ),
                      Text('Late'),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('The activity hasn\'t started yet'));
          }
        },
      ),
    );
  }
}
