import 'dart:io';
import 'package:capr_petsforsale/AccountHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'image_picker_handler.dart';

void main() {
  runApp(CreateListing());
}

class CreateListing extends StatelessWidget {
  const CreateListing({Key? key}) : super(key: key);

  static const String _title = 'Pets Store';
  final appbarcl = const Color(0xFFF8EDEB);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        backgroundColor: appbarcl,
        appBar: AppBar(
            backgroundColor: appbarcl,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Create Listing",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountHome(),
                ),
              ),
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
  bool _isButtonDisabled = false;
  bool _pNameError = false,
      _pTypeError = false,
      _pBreedError = false,
      _pAgeError = false,
      _pPriceError = false,
      _pDescriptionError = false;
  late String url = '';
  Uint8List? image;
  String? fileName;

  final RegExp numbercheck = RegExp('[0-9]');

  onAgeChange(String age) {
    _pAgeError = false;

    setState(() {
      if (numbercheck.hasMatch(age)) {
        _pAgeError = true;
      }
    });
  }

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
    'Amphibians': [
      'Frog',
      'Salamander',
      'Caecilian',
      'Newt',
      'Axolotl',
      'Pacman Frog',
      'Fire-Bellied Toad',
      'Mudskipper',
      'Tree Frog',
      'Tiger Salamander'
    ],
    'Arachnids': [
      'Tarantula',
      'Scorpion',
      'Orb-weaver Spider',
      'Jumping Spider',
      'Huntsman Spider',
      'Trapdoor Spider',
      'Daddy Longlegs',
      'Black Widow',
      'Camel Spider',
      'Harvestman'
    ],
    'Birds': [
      'Parrot',
      'Canary',
      'Finch',
      'Cockatiel',
      'Lovebird',
      'Budgerigar',
      'African Grey',
      'Macaw',
      'Conure',
      'Caique',
      'Pigeon',
      'Dove',
      'Quaker Parrot',
      'Cockatoo',
      'Toucan'
    ],
    'Caged Animals': [
      'Hamster',
      'Rabbit',
      'Gerbil',
      'Guinea Pig',
      'Chinchilla',
      'Degu',
      'Mouse',
      'Rat',
      'Ferret',
      'Sugar Glider',
      'Hedgehog',
      'Prairie Dog',
      'Chipmunk',
      'Skunk',
      'Marmoset'
    ],
    'Cats': [
      'Persian',
      'Siamese',
      'Maine Coon',
      'Sphynx',
      'Bengal',
      'Ragdoll',
      'Abyssinian',
      'Birman',
      'Tonkinese',
      'Oriental Shorthair',
      'Devon Rex',
      'Cornish Rex',
      'Norwegian Forest Cat',
      'Russian Blue',
      'Siberian'
    ],
    'Dogs': [
      'Golden Retriever',
      'Labrador Retriever',
      'Bulldog',
      'German Shepherd',
      'Poodle',
      'Beagle',
      'Yorkshire Terrier',
      'Boxer',
      'Dachshund',
      'Great Dane',
      'Chihuahua',
      'Schnauzer',
      'Cocker Spaniel',
      'Rottweiler',
      'Pug',
      'Shih Tzu',
      'Border Collie',
      'Husky',
      'Doberman',
      'Maltese'
    ],
    'Fish': [
      'Goldfish',
      'Betta',
      'Angelfish',
      'Guppy',
      'Tetra',
      'Discus',
      'Molly',
      'Platy',
      'Swordtail',
      'Corydoras',
      'Rainbowfish',
      'Cichlid',
      'Gourami',
      'Koi',
      'Arowana'
    ],
    'Reptiles': [
      'Tortoise',
      'Gecko',
      'Bearded Dragon',
      'Snake',
      'Chameleon',
      'Monitor Lizard',
      'Iguana',
      'Corn Snake',
      'Boa Constrictor',
      'Python',
      'Skink',
      'Uromastyx',
      'Tegu',
      'Anole',
      'Ball Python',
      'Crested Gecko',
      'Leopard Tortoise',
      'Russian Tortoise',
      'Sulcata Tortoise',
      'King Snake'
    ]
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

  Future openDialog(BuildContext context) => showDialog(
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              alignment: Alignment.center,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      _pNameError = false;
                    });
                  },
                  controller: _petNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Pet Name',
                    labelStyle: const TextStyle(color: Colors.black),
                    errorText:
                        _pNameError ? 'Please Enter Your Pet Name' : null,
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Pet Type',
                    labelStyle: const TextStyle(color: Colors.black),
                    errorText:
                        _pTypeError ? 'Please Select Your Pet Type' : null,
                  ),
                  value: _selectedPetType,
                  items: petTypes.map((String petType) {
                    return DropdownMenuItem<String>(
                      value: petType,
                      child: Text(petType,
                          style: const TextStyle(color: Colors.black)),
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
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Pet Breed',
                    labelStyle: const TextStyle(color: Colors.black),
                    errorText:
                        _pBreedError ? 'Please Select Your Pet Breed' : null,
                  ),
                  value: _selectedPetBreed,
                  items: _petBreeds.map((String petBreed) {
                    return DropdownMenuItem<String>(
                      value: petBreed,
                      child: Text(petBreed,
                          style: const TextStyle(color: Colors.black)),
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
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: TextField(
                onChanged: (value) {
                  onAgeChange(value);
                  setState(() {
                    _pAgeError = false;
                  });
                },
                style: const TextStyle(color: Colors.black),
                controller: _petAgeController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Pet Age',
                  labelStyle: const TextStyle(color: Colors.black),
                  errorText: _pAgeError ? 'Please Select Your Pets Age' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: TextField(
                onTap: () {
                  _pPriceError = false;
                },
                style: const TextStyle(color: Colors.black),
                controller: _petPriceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Price',
                  labelStyle: const TextStyle(color: Colors.black),
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
                  image == null ? Icon(Icons.image) : Image.memory(image!),
                  ElevatedButton(
                      onPressed: () async {
                        final pickerHandler = getImagePickerHandler();
                        final pickedFile = await pickerHandler.pickImage(
                            source: ImageSource.gallery);
                        if (pickedFile != null) {
                          image = await pickedFile.readAsBytes();
                          fileName = pickedFile.name;
                        }

                        if (image != null) {
                          var storage = FirebaseStorage.instance
                              .ref()
                              .child("photos/$fileName");

                          var uploadtask = storage.putData(image!);

                          await uploadtask.whenComplete(() async {
                            url = await storage.getDownloadURL();
                            setState(() {});
                          });
                        }
                      },
                      child: Text("Select Image")),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: TextField(
                onTap: () {
                  _pDescriptionError = false;
                },
                style: const TextStyle(color: Colors.black),
                controller: _petDescriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Pet Description',
                  labelStyle: const TextStyle(color: Colors.black),
                  errorText: _pDescriptionError
                      ? 'Please Enter Your Pet Description'
                      : null,
                ),
              ),
            ),
            Container(
                height: 120,
                padding: const EdgeInsets.fromLTRB(40, 30, 40, 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Create',
                      style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
                  onPressed: (_isButtonDisabled)
                      ? null
                      : () async {
                          if (_petNameController.text.isNotEmpty &&
                              _selectedPetType != null &&
                              _selectedPetBreed != null &&
                              _petAgeController.text.isNotEmpty &&
                              _petPriceController.text.isNotEmpty &&
                              _petDescriptionController.text.isNotEmpty &&
                              image != null) {
                            setState(() {
                              _isButtonDisabled = true;
                            });
                            var storage = FirebaseStorage.instance
                                .ref()
                                .child("photos/$fileName");

                            var uploadtask = storage.putData(image!);

                            await uploadtask.whenComplete(() async {
                              String fileUrl = await storage.getDownloadURL();
                              setState(() {
                                url = fileUrl;
                              });

                              String? userName =
                                  FirebaseAuth.instance.currentUser?.email;
                              await addPetListing(
                                _petNameController.text.trim(),
                                _selectedPetType!,
                                _selectedPetBreed!,
                                int.parse(_petAgeController.text.trim()),
                                double.parse(_petPriceController.text.trim()),
                                _petDescriptionController.text.trim(),
                                userName,
                                url,
                              );
                              openDialog(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountHome()),
                              );
                            });
                          } else {
                            setState(() {
                              _petNameController.text.isEmpty
                                  ? _pNameError = true
                                  : _pNameError = false;
                              _selectedPetType == null
                                  ? _pTypeError = true
                                  : _pTypeError = false;
                              _selectedPetBreed == null
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
                          }
                        },
                )),
          ],
        ));
  }
}
