import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PetDetailsPage extends StatefulWidget {
  final DocumentSnapshot pet;

  PetDetailsPage({required this.pet});

  @override
  _PetDetailsPageState createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet["petName:"]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: widget.pet["imageUrl:"],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Type: ${widget.pet["petType:"]}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Breed: ${widget.pet["petBreed:"]}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Age: ${widget.pet["petAge:"]}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Price: ${widget.pet["petPrice:"]}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Description: ${widget.pet["petDescription:"]}",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
