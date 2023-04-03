import 'dart:io';
import 'package:capr_petsforsale/AccountHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(CreateListing());
}

class CreateListing extends StatelessWidget {
  const CreateListing({Key? key}) : super(key: key);

  static const String _title = 'Canis Orbis';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Canis",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Palatino'),
            )),
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final textbg = const Color(0xFF3D3D3D);

  bool _pNameError = false,
      _pTypeError = false,
      _pBreedError = false,
      _pAgeError = false,
      _pPriceError = false,
      _pDescriptionError = false;
  late String url;
  XFile? image;

  // Pet types and breeds
  List<String> petTypes = [
    'Amphibians',
    'Arachnids',
    'Birds',
    'Caged Animals',
    'Cats',
    'Dogs',
    'Fish',
    'Reptiles'
  ];

  Map<String, List<String>> petBreeds = {
    'Amphibians': ['Frog', 'Salamander', 'Caecilian'],
    'Arachnids': ['Tarantula', 'Scorpion', 'Orb-weaver Spider'],
    'Birds': ['Parrot', 'Canary', 'Finch'],
    'Caged Animals': ['Hamster', 'Rabbit', 'Gerbil'],
    'Cats': ['Persian', 'Siamese', 'Maine Coon'],
    'Dogs': ['Golden Retriever', 'Labrador Retriever', 'Bulldog'],
    'Fish': ['Goldfish', 'Betta', 'Angelfish'],
    'Reptiles': ['Tortoise', 'Gecko', 'Bearded Dragon']
  };

  String? _selectedPetType;
  String? _selectedPetBreed;
  List<String> _petBreeds = [];

  TextEditingController _petNameController = TextEditingController();
  TextEditingController _petTypeController = TextEditingController();
  TextEditingController _petBreedController = TextEditingController();
  TextEditingController _petAgeController = TextEditingController();
  TextEditingController _petPriceController = TextEditingController();
  TextEditingController _petDescriptionController = TextEditingController();

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Successfully created pet listing!"),
        ),
      );

  Future addPetListing(
      String petName,
      String petType,
      String petBreed,
      int age,
      double price,
      String petDescription,
      String? listingOwnerEmail,
      String url) async {
    await FirebaseFirestore.instance.collection('listings').add({
      'petName:': petName,
      'petType:': petType,
      'petBreed:': petBreed,
      'petAge:': age,
      'petPrice:': price,
      'petDescription:': petDescription,
      'listingOwnerEmail:': listingOwnerEmail,
      'imageUrl:': url,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                alignment: Alignment.center,
                child: const Text('Create Your Pet Listing!',
                    style: TextStyle(color: Colors.grey, fontSize: 18))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _petNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: textbg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelText: 'Pet Name',
                    labelStyle: const TextStyle(color: Colors.white70),
                    errorText: _pNameError ? 'Please Enter Your Pet Name' : null,
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  dropdownColor: textbg,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: textbg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelText: 'Pet Type',
                    labelStyle: const TextStyle(color: Colors.white70),
                    errorText: _pTypeError ? 'Please Select Your Pet Type' : null,
                  ),
                  value: _selectedPetType,
                  items: petTypes.map((String petType) {
                    return DropdownMenuItem<String>(
                      value: petType,
                      child: Text(petType, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPetType = newValue;
                      _selectedPetBreed = null;
                      _pTypeError = false;
                      _petBreeds = petBreeds[newValue!]!;
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  dropdownColor: textbg,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: textbg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelText: 'Pet Breed',
                    labelStyle: const TextStyle(color: Colors.white70),
                    errorText: _pBreedError ? 'Please Select Your Pet Breed' : null,
                  ),
                  value: _selectedPetBreed,
                  items: _petBreeds.map((String petBreed) {
                    return DropdownMenuItem<String>(
                      value: petBreed,
                      child: Text(petBreed, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPetBreed = newValue;
                      _pBreedError = false;
                    });
                  },
                  isExpanded: true,
                ),
                SizedBox(height: 10),
              ],
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                onTap: () {
                  _pAgeError = false;
                },
                style: const TextStyle(color: Colors.white),
                controller: _petAgeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Pet Age',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText:
                      _pAgeError ? 'Please Enter Your Email Address' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                onTap: () {
                  _pPriceError = false;
                },
                style: const TextStyle(color: Colors.white),
                controller: _petPriceController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Price',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText:
                      _pPriceError ? 'Please Enter Your Pet Price' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  image == null
                      ? Icon(Icons.image)
                      : Image.file(File(image!.path)),
                  ElevatedButton(
                      onPressed: () async {
                        image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        setState(() {});
                      },
                      child: Text("Select Image")),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                onTap: () {
                  _pDescriptionError = false;
                },
                style: const TextStyle(color: Colors.white),
                controller: _petDescriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Pet Description',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText: _pDescriptionError
                      ? 'Please Enter Your Pet Description'
                      : null,
                ),
              ),
            ),
            Container(
                height: 150,
                padding: const EdgeInsets.fromLTRB(40, 30, 40, 40),
                child: ElevatedButton(
                  child: const Text('Create',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () async {
                    var storage = FirebaseStorage.instance
                        .ref()
                        .child("photos/${image!.name}");
                    var uploadtask = storage.putFile(File(image!.path));
                    await uploadtask.whenComplete(() {
                      storage.getDownloadURL().then((fileUrl) {
                        setState(() {
                          url = fileUrl.toString();
                        });
                      });
                    });
                    setState(() {
                      _petNameController.text.isEmpty
                          ? _pNameError = true
                          : _pNameError = false;
                      _petTypeController.text.isEmpty
                          ? _pTypeError = true
                          : _pTypeError = false;
                      _petBreedController.text.isEmpty
                          ? _pBreedError = true
                          : _pBreedError = false;
                      _petAgeController.text.isEmpty
                          ? _pAgeError = true
                          : _pAgeError = false;
                      _petPriceController.text.isEmpty
                          ? _pPriceError = true
                          : _pPriceError = false;
                      _petDescriptionController.text.isEmpty
                          ? _pDescriptionError = true
                          : _pDescriptionError = false;
                    });
                    if (_petNameController.text.isNotEmpty &&
                        _selectedPetType != null &&
                        _selectedPetBreed != null &&
                        _petAgeController.text.isNotEmpty &&
                        _petPriceController.text.isNotEmpty &&
                        _petDescriptionController.text.isNotEmpty) {
                      String? userName = FirebaseAuth.instance.currentUser?.email;
                      addPetListing(
                        _petNameController.text.trim(),
                        _selectedPetType!,
                        _selectedPetBreed!,
                        int.parse(_petAgeController.text.trim()),
                        double.parse(_petPriceController.text.trim()),
                        _petDescriptionController.text.trim(),
                        userName,
                        url,
                      );
                      openDialog();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AccountHome()));
                    }
                  },
                )),
          ],
        ));
  }
}
