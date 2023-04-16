import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
            padding: const EdgeInsets.only(right: 120),
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
                        const Text('Prevent Hunger'),
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
                        const Text('Donate Food'),
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
                        const Text('Everyone can be a hero'),
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
                        const Text('Avoid Food Waste'),
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
  final _number = TextEditingController();
  DateTime _timeCooked = DateTime.now();
  final _people = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();

  void addFoodPost() async {
    try {
      await FirebaseFirestore.instance.collection('foodPosts').add({
        'foodDetails': _foodDetails.text,
        'timeCooked': _timeCooked,
        'No of Servings': int.tryParse(_people.text),
        'Phone_Number': int.tryParse(_number.text),
        'user': FirebaseAuth.instance.currentUser!.uid,
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
                  TextFormField(
                    controller: _number,
                    decoration: InputDecoration(
                      hintText: 'Phonenumber',
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

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final Stream<QuerySnapshot> _queryStream;

  @override
  void initState() {
    super.initState();
    _queryStream = FirebaseFirestore.instance
        .collection('foodPosts')
        .where('user', isEqualTo: '${FirebaseAuth.instance.currentUser!.uid}')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _queryStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Text('No Orders found:');
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot document = snapshot.data!.docs[index];
              final Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              final bool accepted = data['status'] == 'Accepted';
              final Color cardColor = accepted ? Colors.green : Colors.yellow;
              final Timestamp timestamp = data['timeCooked'];
              final DateTime dateTime = timestamp.toDate();
              final String formattedTime =
                  DateFormat('dd MMMM yyyy, hh:mm a').format(dateTime);
              return Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data['foodDetails']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('${data['No of Servings']} servings'),
                        ],
                      ),
                    ),
                    Text(formattedTime),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
