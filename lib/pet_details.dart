import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'viewListings.dart';

class PetDetailsPage extends StatefulWidget {
  final DocumentSnapshot pet;

  PetDetailsPage({required this.pet});

  @override
  _PetDetailsPageState createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  final appbarcl = const Color(0xFFF8EDEB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appbarcl,
        title: Text(widget.pet["petName:"],
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => viewListings())),
        ),
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
              SizedBox(height: 24), 
              Text(
                "Type:",
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontFamily: 'Montserrat'),
              ),
              Text(
                "${widget.pet["petType:"]}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Montserrat'),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Breed:",
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontFamily: 'Montserrat'),
              ),
              Text(
                "${widget.pet["petBreed:"]}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Montserrat'),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Age:",
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontFamily: 'Montserrat'),
              ),
              Text(
                "${widget.pet["petAge:"]} year",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Montserrat'),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Price:",
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontFamily: 'Montserrat'),
              ),
              Text(
                "\$${widget.pet["petPrice:"]}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Montserrat'),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Listed By:",
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontFamily: 'Montserrat'),
              ),
              Text(
                "${widget.pet["listingOwnerEmail:"]}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Montserrat'),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Description:",
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontFamily: 'Montserrat'),
              ),
              Text(
                "${widget.pet["petDescription:"]}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Montserrat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
