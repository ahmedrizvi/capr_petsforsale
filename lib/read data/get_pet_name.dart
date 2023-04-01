import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetPetName extends StatelessWidget {
  final String documentId;

  GetPetName({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference listings = FirebaseFirestore.instance.collection('listings');

    return FutureBuilder<DocumentSnapshot>(
        future: listings.doc(documentId).get(),
        builder: ((context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
        snapshot.data!.data() as Map<String, dynamic>;
        return Text('Pet Name: ${data['petName:']}');
      }
      return Text('Loading...');
    }
    ));
 }
}