import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:es_application_1/ranking_page.dart';
import 'package:flutter/material.dart';
import 'create_post/create_post.dart';
import 'favorites_page.dart';
import 'main_page.dart';
import 'edit_profile.dart';
import 'send_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';
import 'post_info.dart';

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
  String _profilePictureURL = "";

  @override
  void initState() {
    super.initState();
    loadSettings();
    loadProfilePicture();
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

  Future<void> loadProfilePicture() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String? profilePictureURL = userSnapshot.data()?['profilePictureURL'];

      setState(() {
        // Check if the user has a profile picture URL, if not, use the default image
        if (profilePictureURL != null) {
          _profilePictureURL = profilePictureURL;
        }
      });
    } catch (e) {
      // If an error occurs
    }
  }

  Future<void> deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      await FirebaseAuth.instance.signOut();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Account Successfully Deleted'),
            content: const Text('Your account has been successfully deleted.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                        (route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch(e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2.0),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundColor: _profilePictureURL.isNotEmpty ? null : Colors.green[200],
                    backgroundImage: _profilePictureURL.isNotEmpty ? NetworkImage(_profilePictureURL) : null,
                    radius: 60,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _username,
                  style: const TextStyle(fontSize: 18, color: Colors.green),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(initialImageUrl: _profilePictureURL.isNotEmpty ? _profilePictureURL : null),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Your Posts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('posts').where('user', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot post = snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the post page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ActivityDetailPage(activityId: post.id,)),
                                );
                              },
                              child: Container(
                                width: 200,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.all(8),
                                color: Colors.green[100],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        post['activityName'],
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      post['description'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.thumb_up),
                                            const SizedBox(width: 4),
                                            Text(
                                              (() {
                                                try {
                                                  return (post['liked'] as List<dynamic>).length.toString();
                                                } catch (e) {
                                                  return '0';
                                                }
                                              })(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email Notifications: ${receiveEmailNotifications ? 'On' : 'Off'}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'System Notifications : ${systemNotifications ? 'On' : 'Off'}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Only Near Activities : ${onlyNear ? 'On' : 'Off'}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Text(
                  'Activity: ${lastTimeOn ? 'On' : 'Off'}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Profile Picture : ${profilePicture ? 'On' : 'Off'}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'My favourites : ${favourites ? 'On' : 'Off'}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                    );
                  },
                  child: const Text(
                    'Send feedback',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                ElevatedButton(
                  onPressed: _logout,
                  child: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Account"),
                          content: const Text("Are you sure you want to delete your account?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteAccount();
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
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
                    Navigator.pushReplacement(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.add,
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const RankingPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.leaderboard,
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
