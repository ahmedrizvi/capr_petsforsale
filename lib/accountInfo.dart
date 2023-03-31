import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AccountHome.dart';

void main() {
  runApp(AccountInfo());
}

class AccountInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: AccountInfoPage(),
    );
  }
}
class AccountInfoPage extends StatefulWidget {
  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}
class _AccountInfoPageState extends State<AccountInfoPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _email;
  String? _displayName;
  String? _userId;
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;
  String? _address;
  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }
  void _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email;
      });

      // Query the users collection to get the user document ID based on the email
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email:', isEqualTo: _email)
          .get();
      if (snapshot.docs.isNotEmpty) {
        // Get the first document in the query result, which should be the user's document
        DocumentSnapshot userDoc = snapshot.docs[0];
        setState(() {
          _userId = userDoc.id;
          _displayName = userDoc['user name:'];
          _firstName = userDoc['first name:'];
          _lastName = userDoc['last name:'];
          _phoneNumber = userDoc['phone number:'];
          _address = userDoc['address:'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              'Email',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              _email ?? '',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            Text(
              'Display Name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              _displayName ?? '',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            Text(
              'First Name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              _firstName ?? '',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            Text(
              'Last Name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              _lastName ?? '',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            Text(
              'Phone Number',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              _phoneNumber ?? '',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            Text(
              'Address',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              _address ?? '',
              style: TextStyle(fontSize: 16.0),
            ),
            ElevatedButton(
              child: Text('Go Back'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AccountHome()));
              },
            ),
          ],

        ),
      ),
    );
  }
}
