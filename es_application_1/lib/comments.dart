import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentScreen extends StatefulWidget {
  @override
  final String postId;
  const CommentScreen({super.key, required this.postId});
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  String _name = "";

  @override
  void initState() {
    super.initState();
    loadProfileName();
  }

  Future<void> loadProfileName() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String fname = userSnapshot.data()?['firstName'] ?? '';
      String lname = userSnapshot.data()?['lastName'] ?? '';
      _name = "$fname $lname";
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> _submitComment(String comment) async {
    try {
      if (comment.isNotEmpty) {
        await FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').add({
          'comment': comment,
          'timestamp': Timestamp.now(),
          'user': _name,
        });
        _showDialog('Comment posted successfully!');
      } else {
        _showDialog('Comment cannot be empty!');
      }
    } catch (e) {
      // Handle errors
    }
  }

  /*
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
*/

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
        title: const Text('Comments'),
      backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                final comments = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final commentData = comments[index].data() as Map<String, dynamic>?;
                    final commentUser = commentData?['user'] as String?;
                    final commentText = commentData?['comment'] as String?;
                    final timestamp = commentData?['timestamp'] as Timestamp?;
                    final formattedTimestamp = timestamp != null ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate()) : 'No timestamp';

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(commentText ?? 'No comment'),
                        subtitle: Row(
                          children: [
                            Text(commentUser ?? 'Unknown user',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const Text(' · ',
                            style: TextStyle(color: Colors.grey),
                            ),
                            Text(formattedTimestamp ?? 'No time',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your comment',
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  String comment = commentController.text;
                    _submitComment(comment);
                    commentController.clear();
                },
                icon: const Icon(Icons.send_sharp, size: 30, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}