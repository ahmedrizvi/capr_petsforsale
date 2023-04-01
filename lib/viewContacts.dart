import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'viewMessages.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _emailController = TextEditingController();
  User? userId = FirebaseAuth.instance.currentUser;
  // Add a new contact to Firestore
  void _addContact() async {
    final String email = _emailController.text;
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email:', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final DocumentSnapshot user = snapshot.docs.first;
      final String name = user['user name:'];
      final String id = user.id;
      final String chatId = _getChatId(id);

      await FirebaseFirestore.instance.collection('contacts').doc(chatId).set({
        'id': chatId,
        'name': name,
        'email': email,
        'userId': FirebaseAuth.instance.currentUser?.uid,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(chatId: chatId, title: name),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('User not found'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Generate a chat ID for the current user and the new contact
  String _getChatId(String userId) {
    final String currentUserId = '123'; // Replace with the current user's ID
    if (currentUserId.compareTo(userId) < 0) {
      return '$currentUserId-$userId';
    } else {
      return '$userId-$currentUserId';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('contacts')
                  .where('userId', isEqualTo: userId?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        final contact = snapshot.data?.docs[index];
                        final String name = contact?['name'];
                        final String email = contact?['email'];
                        final String chatId = contact?['id'];

                        return ListTile(
                          title: Text(name),
                          subtitle: Text(email),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(chatId: chatId, title: name),
                              ),
                            );
                          },
                        );
                      },
                    );
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email address',
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: _addContact,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
