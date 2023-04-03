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

  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

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
      _displayNameController.text = _displayName ?? '';
      _firstNameController.text = _firstName ?? '';
      _lastNameController.text = _lastName ?? '';
      _phoneNumberController.text = _phoneNumber ?? '';
      _addressController.text = _address ?? '';
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
          'Account Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              TextField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Display Name',
                ),
              ),
              SizedBox(height: 24.0),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'First Name',
                ),
              ),
              SizedBox(height: 24.0),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Last Name',
                ),
              ),
              SizedBox(height: 24.0),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(height: 24.0),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Address',
                ),
              ),
              SizedBox(height: 24.0),
              FloatingActionButton.extended(
                onPressed: () async {
                  // Update the user document in the Firestore collection
                  await _firestore.collection('users').doc(_userId).update({
                    'user name:': _displayNameController.text,
                    'first name:': _firstNameController.text,
                    'last name:': _lastNameController.text,
                    'phone number:': _phoneNumberController.text,
                    'address:': _addressController.text,
                  });
                  label:
                  Text('My Button');
                  // Reload the user information from Firestore
                  _getUserInfo();

                  // Show a snackbar to indicate that the changes were saved
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Changes saved.'),
                    ),
                  );
                },
                label: Text('Save Changes'),
                icon: Icon(Icons.add),
              ),
              SizedBox(height: 24.0),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AccountHome()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
