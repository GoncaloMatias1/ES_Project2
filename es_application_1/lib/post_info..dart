import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityDetailPage extends StatelessWidget {
  final String activityId;

  const ActivityDetailPage({Key? key, required this.activityId}) : super(key: key);

  Future<Map<String, dynamic>> _loadData(String activityId) async {
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

    // Parse date string to DateTime
    final DateTime date = timestamp.toDate();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formattedDate = formatter.format(date);

    final String userName = '${userData['firstName']} ${userData['lastName']}';
    final String userProfilePhoto = userData['profilePictureURL'] ?? '';

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
    };
  }

  String _formatCoordinate(double coordinate) {
    final formattedCoordinate = coordinate.abs().toStringAsFixed(7);
    return formattedCoordinate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _loadData(activityId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Error: Activity not found'));
            }

            final data = snapshot.data!;
            final LatLng activityLocation = LatLng(data['location'].latitude, data['location'].longitude);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen[100], // Light green background color
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // User photo and name
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: data['userProfilePhoto'] == '' ? Colors.green[700] : null,
                      backgroundImage: data['userProfilePhoto'] != ''
                          ? NetworkImage(data['userProfilePhoto'])
                          : null,
                      child: data['userProfilePhoto'] == ''
                          ? Icon(Icons.person, color: Colors.white) // Placeholder icon if photoURL is null
                          : null,
                    ),
                    SizedBox(height: 12),
                    Text(
                      data['userName'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    // Activity name
                    Text(
                      data['activityName'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.green[900]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    // Other activity details
                    Text(
                      'Description: ${data['description']}',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[200], // Lighter green background color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location:',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
                          ),
                          SizedBox(height: 4),
                          Container(
                            height: 150,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: activityLocation,
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId('activity_location'),
                                  position: activityLocation,
                                ),
                              },
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Coordinates: [${_formatCoordinate(data['location'].latitude)}° ${data['location'].latitude >= 0 ? 'N' : 'S'}, ${_formatCoordinate(data['location'].longitude)}° ${data['location'].longitude >= 0 ? 'E' : 'W'}]',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start Time: ${data['startTime']}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'End Time: ${data['endTime']}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Date: ${data['date']}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Categories: ${data['categories'].join(', ')}',
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {
                            // Handle like button press
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () {
                            // Handle add to favorites button press
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle subscribe button press
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Subscribe',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
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