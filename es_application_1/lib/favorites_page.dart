import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'create_post/create_post.dart';
import 'main_page.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text('Still empty'),
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
                MaterialPageRoute(builder: (context) => MainPage()),
              );
            },
          ),
          _buildTabItem(
            icon: Icons.add,
            context: context,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostScreen()),
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
          decoration: BoxDecoration(
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
