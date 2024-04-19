import 'package:es_application_1/deleteaccount.dart';
import 'package:flutter/material.dart';
import 'favorites_page.dart';
import 'main_page.dart';
import 'edit_profile.dart';
import 'send_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _usernameController = TextEditingController();
  bool receiveEmailNotifications = true;
  bool systemNotifications = true;
  bool onlyNear = true;
  bool lastTimeOn = true;
  bool profilePicture = true;
  bool favourites = true;
  String _username = "YourUsername";

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      receiveEmailNotifications = prefs.getBool('receiveEmailNotifications') ?? true;
      systemNotifications = prefs.getBool('systemNotifications') ?? true;
      onlyNear = prefs.getBool('onlyNear') ?? true;
      lastTimeOn = prefs.getBool('lastTimeOn') ?? true;
      profilePicture = prefs.getBool('profilePhoto') ?? true;
      favourites = prefs.getBool('favourites') ?? true;
      _username = prefs.getString('username') ?? "YourUsername";
      _usernameController.text = _username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  _username,
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    );
                  },
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Email Notifications: ${receiveEmailNotifications ? 'On' : 'Off'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'System Notifications : ${systemNotifications ? 'On' : 'Off'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Only Near Activities : ${onlyNear ? 'On' : 'Off'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                Text(
                  'Activity: ${lastTimeOn ? 'On' : 'Off'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Profile Picture : ${profilePicture ? 'On' : 'Off'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'My favourites : ${favourites ? 'On' : 'Off'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackScreen()),
                    );
                  },
                  child: Text(
                    'Send feedback',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => DeleteAccountScreen()),
                    );
                  },
                  child: Text(
                    'Delete account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.home,
                    color: Colors.green,
                    size: 30.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.green,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
