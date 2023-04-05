import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'viewMessages.dart';
import 'AccountHome.dart';

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
    final appbarcl = const Color(0xFFF8EDEB);

    return Scaffold(
      backgroundColor: appbarcl,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appbarcl,
        title: const Text(
          'Contact',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AccountHome())),
        ),
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
                      padding: const EdgeInsets.all(10),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final contact = documents[index];
                        final String name = contact['name'];
                        final String email = contact['email'];
                        final String chatId = contact['id'];
                        
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tileColor: Colors.white,
                          title: Text(
                            name,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            email,
                            style: TextStyle(color: Colors.black),
                          ),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter email address',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: _addContact,
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
