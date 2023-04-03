import 'package:capr_petsforsale/viewContacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'createListing.dart';
import 'login.dart';
import 'viewListings.dart';
import 'accountInfo.dart';
import 'myListings.dart';
import 'viewContacts.dart';

void main() {
  runApp(AccountHome());
}

class AccountHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Listings',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  /*
                  Positioned(
                    top: 50,
                    child: Image.network(
                      'https://hips.hearstapps.com/goodhousekeeping/assets/17/40/1507316792-havenese.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  */
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FutureBuilder<User?>(
                          future:
                              Future.value(FirebaseAuth.instance.currentUser),
                          builder: (BuildContext context,
                              AsyncSnapshot<User?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              User? user = snapshot.data;
                              String userName =
                                  user?.displayName ?? user?.email ?? 'Unknown';
                              return Text(
                                'Welcome, $userName',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        Text(
                          'Find Your New Pet Companion',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'Browse Listings',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(20),),
                    tileColor: Colors.blueAccent,
                    leading: Icon(Icons.person, color: Colors.white,),
                    title: Text('Account Info', style: TextStyle(fontSize:20, color: Colors.white),),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountInfo()));
                    },
                  ),
                  SizedBox(height: 16.0),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(20),),
                    tileColor: Colors.blueAccent,
                    leading: Icon(Icons.add, color: Colors.white,),
                    title: Text('Create Listing', style: TextStyle(fontSize:20, color: Colors.white),),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateListing()));
                    },
                  ),
                  SizedBox(height: 16.0),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(20),),
                    tileColor: Colors.blueAccent,
                    leading: Icon(Icons.pets, color: Colors.white,),
                    title: Text('My Pet Listings', style: TextStyle(fontSize:20, color: Colors.white),),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => myListings()));
                    },
                  ),
                  SizedBox(height: 16.0),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(20),),
                    tileColor: Colors.blueAccent,
                    leading: Icon(Icons.search, color: Colors.white,),
                    title: Text('View Other Pet Listings', style: TextStyle(fontSize:20, color: Colors.white),),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => viewListings()));
                    },
                  ),
                  SizedBox(height: 16.0),
                  ListTile(
                    tileColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(20),),
                    leading: Icon(Icons.message, color: Colors.white,),
                    title: Text('View Messages', style: TextStyle(fontSize:20, color: Colors.white),),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactsScreen()));
                    },
                  ),
                  SizedBox(height: 16.0),
                  ListTile(
                    tileColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(20),),
                    leading: Icon(Icons.logout),
                    title: Text('Logout', style: TextStyle(fontSize:20, color: Colors.black),),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Logout'),
                              content: Text('Are you sure you want to logout?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'No'),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login())),
                                    child: Text('Yes')),
                              ],
                            );
                          });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
