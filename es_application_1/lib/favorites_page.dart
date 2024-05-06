import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import 'create_post/create_post.dart';
import 'main_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<DocumentSnapshot> favoritePosts = [];

  @override
  void initState() {
    super.initState();
    fetchFavoritePosts();
  }

  fetchFavoritePosts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      List<dynamic> favoriteIds = userData.data()?['favorites'] as List<dynamic>? ?? [];
      List<Future<DocumentSnapshot>> postFutures = [];

      for (String id in favoriteIds) {
        postFutures.add(FirebaseFirestore.instance.collection('posts').doc(id).get());
      }

      favoritePosts = await Future.wait(postFutures);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.green,
      ),
      body: favoritePosts.isEmpty
          ? const Center(child: Text('No favorites added yet.'))
          : ListView.builder(
        itemCount: favoritePosts.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> postData = favoritePosts[index].data() as Map<String, dynamic>;
          return ListTile(
            title: Text(postData['activityName'] ?? 'No title available'),
            subtitle: Text(postData['description'] ?? 'No description available'),
          );
        },
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildTabItem(
            icon: Icons.home,
            context: context,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            },
          ),
          _buildTabItem(
            icon: Icons.add,
            context: context,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePostScreen()),
              );
            },
          ),
          _buildTabItem(
            icon: Icons.person,
            context: context,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            icon,
            color: Colors.green,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}
