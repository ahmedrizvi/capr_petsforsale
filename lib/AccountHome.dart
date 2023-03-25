import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'createListing.dart';
import 'viewListings.dart';

void main() {
  runApp(AccountHome());
}

class AccountHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Listings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Account Home'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<User?>(
                future: Future.value(FirebaseAuth.instance.currentUser),
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    User? user = snapshot.data;
                    String userName = user?.displayName ?? user?.email ?? 'Unknown';
                    return Text(
                      'Welcome, $userName',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle account info button press
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person),
                          SizedBox(height: 8.0),
                          Text('Account Info'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle create listing button press
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CreateListing()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(height: 8.0),
                          Text('Create Listing'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle my pet listings button press
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pets),
                          SizedBox(height: 8.0),
                          Text('My Pet Listings'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle view other pet listings button press
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => viewListings()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search),
                          SizedBox(height: 8.0),
                          Text('View Other Pet Listings'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


