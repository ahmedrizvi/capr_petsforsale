import 'package:capr_petsforsale/pet_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'AccountHome.dart';

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
        scaffoldBackgroundColor: Colors.tealAccent,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListingsPage(),
    );
  }
}

class ListingsPage extends StatefulWidget {
  @override
  _ListingsPageState createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  String? _selectedPetType;
  String? _selectedPetBreed;

  final Map<String, List<String>> petBreeds = {
    'Amphibians': ['Frog', 'Salamander', 'Caecilian'],
    'Arachnids': ['Tarantula', 'Scorpion', 'Orb-weaver Spider'],
    'Birds': ['Parrot', 'Canary', 'Finch'],
    'Caged Animals': ['Hamster', 'Rabbit', 'Gerbil'],
    'Cats': ['Persian', 'Siamese', 'Maine Coon'],
    'Dogs': ['Golden Retriever', 'Labrador Retriever', 'Bulldog'],
    'Fish': ['Goldfish', 'Betta', 'Angelfish'],
    'Reptiles': ['Tortoise', 'Gecko', 'Bearded Dragon']
  };

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("Listings For Sale Near You"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AccountHome())),
        ),
      ),
      body: Column(
        children: [
          _Filter(
            petBreeds: petBreeds,
            selectedPetType: _selectedPetType,
            selectedPetBreed: _selectedPetBreed,
            onTypeChanged: (value) {
              setState(() {
                _selectedPetType = value;
                _selectedPetBreed = null;
              });
            },
            onBreedChanged: (value) {
              setState(() {
                _selectedPetBreed = value;
              });
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                final filteredListings = snapshot.data!.docs.where((listing) {
                  final typeMatches = _selectedPetType == null ||
                      listing["petType:"] == _selectedPetType;
                  final breedMatches = _selectedPetBreed == null ||
                      listing["petBreed:"] == _selectedPetBreed;
                  return typeMatches && breedMatches;
                }).toList();
                return ListView.builder(
                  itemCount: filteredListings.length,
                  itemBuilder: (context, index) {
                    final listing = filteredListings[index];
                    final imageUrl = listing["imageUrl:"];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PetDetailsPage(pet: listing),
                            ),
                          );
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
                                      "Listed By: ${listing["listingOwnerEmail:"]}",
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
          ),
        ],
      ),
    );
  }
}

class _Filter extends StatelessWidget {
  final Map<String, List<String>> petBreeds;
  final String? selectedPetType;
  final String? selectedPetBreed;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onBreedChanged;

  const _Filter({
    Key? key,
    required this.petBreeds,
    this.selectedPetType,
    this.selectedPetBreed,
    required this.onTypeChanged,
    required this.onBreedChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              hint: Text('Select Pet Type'),
              value: selectedPetType,
              isExpanded: true,
              onChanged: onTypeChanged,
              items: petBreeds.keys
                  .map((type) => DropdownMenuItem(
                        child: Text(type),
                        value: type,
                      ))
                  .toList(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              hint: Text('Select Pet Breed'),
              value: selectedPetBreed,
              isExpanded: true,
              onChanged: selectedPetType == null ? null : onBreedChanged,
              items: selectedPetType == null
                  ? null
                  : petBreeds[selectedPetType]!
                      .map((breed) => DropdownMenuItem(
                            child: Text(breed),
                            value: breed,
                          ))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
