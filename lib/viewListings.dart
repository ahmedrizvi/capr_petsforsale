import 'package:capr_petsforsale/pet_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        primaryColor: Color(0xFF63B4B8),
        scaffoldBackgroundColor: Color(0xFFF8EDEB),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
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
  final appbarcl = const Color(0xFFF8EDEB);

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

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarcl,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Listings For Sale Near You',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
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
                  final ownerEmailMatches =
                      listing["listingOwnerEmail:"] != currentUserEmail;
                  return typeMatches && breedMatches && ownerEmailMatches;
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
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(listing["petName:"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Type: ${listing["petType:"]}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Breed: ${listing["petBreed:"]}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Age: ${listing["petAge:"]} year",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Price: \$${listing["petPrice:"]}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Listed By: ${listing["listingOwnerEmail:"]}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Description: ${listing["petDescription:"]}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
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
