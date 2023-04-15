import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VolHome extends StatefulWidget {
  const VolHome({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<VolHome> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    CreatePostPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(236, 246, 128, 56),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 135),
            child: Image.asset('lib/images/meals.png'),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 200,
                  child: Card(
                    color: Color.fromARGB(255, 167, 221, 247),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fastfood,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text('Hunger Statistics'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Card(
                    color: Color.fromARGB(255, 167, 221, 247),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text('Food Waste Statistics'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Card(
                    color: Color.fromARGB(255, 167, 221, 247),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text('Food Waste Statistics'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Card(
                    color: Color.fromARGB(255, 167, 221, 247),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text('Food Waste Statistics'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Color.fromARGB(240, 238, 134, 60),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.add_box_outlined),
            title: const Text('Create Food Post'),
            selectedColor: Color.fromARGB(255, 166, 6, 194),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.history),
            title: const Text('History'),
            selectedColor: Color.fromARGB(255, 166, 6, 194),
          ),
        ],
      ),
    );
  }
}

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _foodDetails = TextEditingController();
  DateTime _timeCooked = DateTime.now();
  final _people = TextEditingController();
  LatLng _currentLocation = LatLng(0, 0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print(e);
    }
  }

  void addFoodPost() async {
    try {
      await FirebaseFirestore.instance.collection('foodPosts').add({
        'foodDetails': _foodDetails.text,
        'timeCooked': _timeCooked,
        'No of Servings': int.tryParse(_people.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Post Added successfully!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error creating post: $e'),
        backgroundColor: Color.fromARGB(255, 237, 77, 66),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 194, 164),
      body: FutureBuilder(
        future: _firebaseInit,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Form(
                key: _formKey,
                child: ListView(padding: EdgeInsets.all(16), children: [
                  TextFormField(
                    controller: _foodDetails,
                    decoration: InputDecoration(
                      hintText: 'Food Details',
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Time Cooked'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter the time the food was cooked';
                      }
                      return null;
                    },
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          _timeCooked ?? DateTime.now(),
                        ),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _timeCooked = DateTime(
                            _timeCooked?.year ?? DateTime.now().year,
                            _timeCooked?.month ?? DateTime.now().month,
                            _timeCooked?.day ?? DateTime.now().day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                      }
                    },
                    controller: TextEditingController(
                        text: '${_timeCooked.toString()}'),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _people,
                    decoration: InputDecoration(
                      hintText: 'Number of Servings Available',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Current Location:', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Container(
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation,
                        zoom: 16,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('current-location'),
                          position: _currentLocation,
                        ),
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: addFoodPost,
                    child: Text('Add Post'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 30, 184, 35),
                        elevation: 15,
                        shadowColor: Color.fromARGB(255, 133, 239, 137)),
                  ),
                ]));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('History'),
    );
  }
}
