import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'viewMessages.dart';

class ContactsScreen extends StatefulWidget {
  final String ownerId;

  ContactsScreen({required this.ownerId});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _emailController = TextEditingController();
  User? userId = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.ownerId.isNotEmpty) {
      _addContact(widget.ownerId);
    }
  }

  // Add a new contact to Firestore
  void _addContact(String ownerId) async {
    if (ownerId.isEmpty) {
      return;
    }

    final DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('users')
        .doc(ownerId)
        .get();

    final String name = user['user name:'];
    final String email = user['email:'];
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
            child: StreamBuilder<List<QuerySnapshot>>(
              stream: Rx.combineLatest2(
                FirebaseFirestore.instance
                    .collection('contacts')
                    .where('userId', isEqualTo: userId?.uid)
                    .snapshots(),
                FirebaseFirestore.instance
                    .collection('contacts')
                    .where('email', isEqualTo: userId?.email)
                    .snapshots(),
                    (QuerySnapshot query1, QuerySnapshot query2) {
                  return [query1, query2];
                },
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    List<QueryDocumentSnapshot> documents = [];
                    snapshot.data?.forEach((querySnapshot) {
                      documents.addAll(querySnapshot.docs);
                    });
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final contact = documents[index];
                        final String name = contact['name'];
                        final String email = contact['email'];
                        final String chatId = contact['id'];

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
                  onPressed: () => _addContact(_emailController.text),
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

