import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool receiveEmailNotifications = true;
  bool systemNotifications = true;
  bool onlyNear = true;
  bool lastTimeOn = true;
  bool profilePhoto = true;
  bool favourites = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2.0),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile_photo.jpg'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'YourUsername',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Edit Profile',
                style: TextStyle(color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Text(
                  'Email Notifications: ${receiveEmailNotifications ? 'On' : 'Off'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'System Notifications : ${ systemNotifications ? 'On': 'Off'}',
                  style : TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Only Near Activities : ${ onlyNear ? 'On': 'Off'}',
                  style : TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              children: [
                Text(
                  'Activity: ${lastTimeOn ? 'On' : 'Off'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Profile Photo : ${ profilePhoto ? 'On': 'Off'}',
                  style : TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'My favourites : ${ favourites ? 'On': 'Off'}',
                  style : TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Send feedback',
                style: TextStyle(color: Colors.green),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Delete account',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green, // Set the background color of the bottom app bar to green
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.home, color: Colors.white), onPressed: () {  }, // Icon for returning home
          ),
        ),
      ),
    );
  }
}