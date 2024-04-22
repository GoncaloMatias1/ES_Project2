import 'package:es_application_1/profile_page.dart';
import 'package:flutter/material.dart';
import 'favorites_page.dart';
import 'main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _usernameController = TextEditingController();
  bool _receiveEmailNotifications = true;
  bool _systemNotifications = true;
  bool _onlyNear = true;
  bool _lastTimeOn = true;
  bool _profilePicture = true;
  bool _favourites = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _receiveEmailNotifications = prefs.getBool('receiveEmailNotifications') ?? true;
      _systemNotifications = prefs.getBool('systemNotifications') ?? true;
      _onlyNear = prefs.getBool('onlyNear') ?? true;
      _lastTimeOn = prefs.getBool('lastTimeOn') ?? true;
      _profilePicture = prefs.getBool('profilePhoto') ?? true;
      _favourites = prefs.getBool('favourites') ?? true;
      _usernameController.text = prefs.getString('username') ?? '';
    });
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('receiveEmailNotifications', _receiveEmailNotifications);
    prefs.setBool('systemNotifications', _systemNotifications);
    prefs.setBool('onlyNear', _onlyNear);
    prefs.setBool('lastTimeOn', _lastTimeOn);
    prefs.setBool('profilePhoto', _profilePicture);
    prefs.setBool('favourites', _favourites);
    prefs.setString('username', _usernameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const Center(
                child: CircleAvatar(
                  radius: 60,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Notification Settings',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text('Receive Email Notifications'),
                value: _receiveEmailNotifications,
                onChanged: (value) {
                  setState(() {
                    _receiveEmailNotifications = value;
                    saveSettings();
                  });
                },
                activeColor: Colors.green,
              ),
              SwitchListTile(
                title: const Text('System Notifications'),
                value: _systemNotifications,
                onChanged: (value) {
                  setState(() {
                    _systemNotifications = value;
                    saveSettings();
                  });
                },
                activeColor: Colors.green,
              ),
              SwitchListTile(
                title: const Text('Only Near Activities'),
                value: _onlyNear,
                onChanged: (value) {
                  setState(() {
                    _onlyNear = value;
                    saveSettings();
                  });
                },
                activeColor: Colors.green,
              ),
              SwitchListTile(
                title: const Text('Last Time On'),
                value: _lastTimeOn,
                onChanged: (value) {
                  setState(() {
                    _lastTimeOn = value;
                    saveSettings();
                  });
                },
                activeColor: Colors.green,
              ),
              const SizedBox(height: 15),
              const Text(
                'Privacy Settings',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text('Profile Picture'),
                value: _profilePicture,
                onChanged: (value) {
                  setState(() {
                    _profilePicture = value;
                    saveSettings();
                  });
                },
                activeColor: Colors.green,
              ),
              SwitchListTile(
                title: const Text('My Favourites'),
                value: _favourites,
                onChanged: (value) {
                  setState(() {
                    _favourites = value;
                    saveSettings();
                  });
                },
                activeColor: Colors.green,
              ),
              const SizedBox(height: 15),
              Center( // Centering the button
                child: ElevatedButton(
                  onPressed: () {
                    saveSettings();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], foregroundColor: Colors.white),
                ),
              ),
            ],
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
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
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
