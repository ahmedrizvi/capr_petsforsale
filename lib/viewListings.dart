import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(viewListings());
}

class viewListings extends StatelessWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Listings"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("listings").snapshots(),
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
              return ListTile(
                title: Text(listing["petName:"]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type: ${listing["petType:"]}"),
                    Text("Breed: ${listing["petBreed:"]}"),
                    Text("Age: ${listing["petAge:"]}"),
                    Text("Price: ${listing["petPrice:"]}"),
                    Text("Description: ${listing["petDescription:"]}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

