import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'AccountHome.dart';
import 'EditListingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(myListings());
}

class myListings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Marketplace',
      theme: ThemeData(
        primaryColor: Color(0xFF63B4B8),
        scaffoldBackgroundColor: Color(0xFFF8EDEB),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
      home: ListingsPage(),
    );
  }
}

class ListingsPage extends StatelessWidget {
  const ListingsPage({Key? key}) : super(key: key);

  Future<void> deleteListing(String listingId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('listings').doc(listingId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final appbarcl = const Color(0xFFF8EDEB);
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: appbarcl,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appbarcl,
        title: const Text(
          'Your Listings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountHome())),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("listings")
            .where("listingOwnerEmail:", isEqualTo: user?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final listing = snapshot.data!.docs[index];
              final imageUrl = listing["imageUrl:"];
              return Card(

                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: InkWell(
                  onTap: () {
                    // Do something when the card is tapped
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(listing["petName:"], style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25,
                                fontFamily: 'Montserrat')),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Breed: ${listing["petBreed:"]}",
                                    style: const TextStyle(color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Age: ${listing["petAge:"]} year",
                                    style: const TextStyle(color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Price: ${listing["petPrice:"]}",
                                    style: const TextStyle(color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Description: ${listing["petDescription:"]}",
                                    style: const TextStyle(color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditListingPage(listing: listing),
                                  ),
                                );
                              },
                              child: Text('Edit Listing'),
                            ),
                            SizedBox(width: 10),
                            // Add some space between the buttons
                            TextButton(
                              onPressed: () {
                                deleteListing(listing.id);
                              },
                              child: Text('Delete Listing'),
                              style: TextButton.styleFrom(
                                primary: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
