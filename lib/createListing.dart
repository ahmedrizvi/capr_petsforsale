import 'package:capr_petsforsale/AccountHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CreateListing());
}

class CreateListing extends StatelessWidget {
  TextEditingController _petNameController = TextEditingController();
  TextEditingController _petTypeController = TextEditingController();
  TextEditingController _petBreedController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _petPriceController = TextEditingController();
  TextEditingController _petDescriptionController = TextEditingController();

  Future addPetListing(String petName, String petType, String petBreed, int age, double price, String petDescription) async {
    await FirebaseFirestore.instance.collection('listings').add({
      'pet name:': petName,
      'pet type:': petType,
      'pet breed:': petBreed,
      'pet age:': age,
      'pet price:': price,
      'pet description:': petDescription,
    } as Map<String, dynamic>);
  }

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
          title: Text('Create a Pet Listing'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pet Details',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _petNameController,
                decoration: InputDecoration(
                  labelText: 'Pet Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _petTypeController,
                decoration: InputDecoration(
                  labelText: 'Pet Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _petBreedController,
                decoration: InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _petPriceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Pet Description',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _petDescriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter a description of your pet',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle submit button press
                  addPetListing(
                      _petNameController.text.trim(),
                      _petTypeController.text.trim(),
                      _petBreedController.text.trim(),
                      int.parse(_ageController.text.trim()),
                      double.parse(_petPriceController.text.trim()),
                      _petDescriptionController.text.trim()
                  );
                },
                child: Text('Create Listing'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle back button press
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AccountHome()));
                },
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
