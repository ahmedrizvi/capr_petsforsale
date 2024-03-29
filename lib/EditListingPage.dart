import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'myListings.dart';

class EditListingPage extends StatefulWidget {
  final DocumentSnapshot listing;
  EditListingPage({required this.listing});

  @override
  _EditListingPageState createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petTypeController = TextEditingController();
  final TextEditingController _petBreedController = TextEditingController();
  final TextEditingController _petAgeController = TextEditingController();
  final TextEditingController _petPriceController = TextEditingController();
  final TextEditingController _petDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _petNameController.text = widget.listing['petName:'];
    _petTypeController.text = widget.listing['petType:'];
    _petBreedController.text = widget.listing['petBreed:'];
    _petAgeController.text = widget.listing['petAge:'].toString();
    _petPriceController.text = widget.listing['petPrice:'].toString();
    _petDescriptionController.text = widget.listing['petDescription:'];
  }

  @override
  void dispose() {
    _petNameController.dispose();
    _petTypeController.dispose();
    _petBreedController.dispose();
    _petAgeController.dispose();
    _petPriceController.dispose();
    _petDescriptionController.dispose();
    super.dispose();
  }

  void _updateListing() async {
      await FirebaseFirestore.instance
          .collection('listings')
          .doc(widget.listing.id)
          .update({
        'petName:': _petNameController.text,
        'petType:': _petTypeController.text,
        'petBreed:': _petBreedController.text,
        'petAge:': _petAgeController.text,
        'petPrice:': _petPriceController.text,
        'petDescription:': _petDescriptionController.text,
      });
      Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    final appbarcl = const Color(0xFFF8EDEB); 
    return Scaffold(
      backgroundColor: appbarcl,
        appBar: AppBar(
          backgroundColor: appbarcl,
          elevation: 0,
          centerTitle: true,
          title: const Text(
          'Edit Listing',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => myListings(),),),),),
        body: SingleChildScrollView(
        child: Form(
        key: _formKey,
        child: Padding(
        padding: EdgeInsets.all(16),
    child: Column(
    children: [
    TextFormField(
    controller: _petNameController,
    decoration: InputDecoration(labelText: 'Pet Name',
    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,),
    validator: (value) =>
    value!.isEmpty ? 'Please enter pet name' : null,
    ),
    SizedBox(height: 24.0),
    TextFormField(
    controller: _petTypeController,
    decoration: InputDecoration(labelText: 'Pet Type',
    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,),
    validator: (value) =>
    value!.isEmpty ? 'Please enter pet type' : null,
    ),
    SizedBox(height: 24.0),
    TextFormField(
    controller: _petBreedController,
    decoration: InputDecoration(labelText: 'Pet Breed',
    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,),
    validator: (value) =>
    value!.isEmpty ? 'Please enter pet breed' : null,
    ),
    SizedBox(height: 24.0),
    TextFormField(
    controller: _petAgeController,
    decoration: InputDecoration(labelText: 'Pet Age',
    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,),
    validator: (value) =>
    value!.isEmpty ? 'Please enter pet age' : null,
    ),
    SizedBox(height: 24.0),
    TextFormField(
    controller: _petPriceController,
    decoration: InputDecoration(labelText: 'Pet Price',
    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,),
    validator: (value) => value!.isEmpty ? 'Please enter pet price' : null,
    ),
    SizedBox(height: 24.0),
      TextFormField(
        controller: _petDescriptionController,
        decoration: InputDecoration(labelText: 'Pet Description',border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,),
        validator: (value) =>
        value!.isEmpty ? 'Please enter pet description' : null,
      ),
      SizedBox(height: 30),
      SizedBox(
        height: 50,
        width: 200,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),),
          child: const Text('Save Changes',style: TextStyle(fontSize: 20, color: Colors.blueAccent),),
          onPressed: _updateListing,
      ),
      ),
    ],
    ),
        ),
        ),
        ),
    );
  }
}