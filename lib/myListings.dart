import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'AccountHome.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListingsPage(),
    );
  }
}

class ListingsPage extends StatelessWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Pet Listings"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AccountHome())),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listing["petName:"],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Type: ${listing["petType:"]}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Breed: ${listing["petBreed:"]}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Age: ${listing["petAge:"]}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Price: ${listing["petPrice:"]}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Description: ${listing["petDescription:"]}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
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
