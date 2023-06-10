import 'package:flutter/material.dart';
import 'package:mealsmission/pages/loginscreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NgoHome extends StatefulWidget {
  const NgoHome({Key? key}) : super(key: key);

  @override
  State<NgoHome> createState() => _NgoHomeState();
}

class _NgoHomeState extends State<NgoHome> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Availablefood(),
    const History(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(236, 246, 128, 56),
        actions: [
          IconButton(
              alignment: Alignment.centerLeft,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              icon: const Icon(
                Icons.logout,
              )),
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
              children: const [
                SizedBox(
                  width: 200,
                  child: Card(
                    color: Color.fromARGB(228, 244, 199, 115),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fastfood,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text('Solve Hunger'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Card(
                    color: Color.fromARGB(228, 244, 199, 115),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text('Even a Small Step is a Step'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Card(
                    color: Color.fromARGB(228, 244, 199, 115),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text('Avoid Food Waste'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Card(
                    color: Color.fromARGB(228, 244, 199, 115),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text('Donate and Save'),
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
        backgroundColor: const Color.fromARGB(240, 238, 134, 60),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.add_box_outlined),
            title: const Text('Available Food'),
            selectedColor: Color.fromARGB(255, 22, 124, 29),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.history),
            title: const Text('History'),
            selectedColor: Color.fromARGB(255, 38, 138, 65),
          ),
        ],
      ),
    );
  }
}

class Availablefood extends StatefulWidget {
  const Availablefood({super.key});

  @override
  State<Availablefood> createState() => _AvailablefoodState();
}

class _AvailablefoodState extends State<Availablefood> {
  final Set<String> _acceptedFoodIds = {};
  Set<String> _acceptedFoodPosts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(236, 246, 128, 56),
        title: Text('Available Food'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color.fromARGB(255, 254, 189, 139),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('foodPosts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final availableFoodDocs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return !_acceptedFoodIds.contains(doc.id) &&
                !data.containsKey('status');
          }).toList();
          return ListView.builder(
            itemCount: availableFoodDocs.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot document = availableFoodDocs[index];
              final Color cardcolor = Color.fromARGB(255, 233, 154, 7);
              final Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              final Timestamp timestamp = data['timeCooked'];
              final DateTime dateTime = timestamp.toDate();
              final String formattedTime =
                  DateFormat('dd MMMM yyyy, hh:mm a').format(dateTime);
              return Card(
                color: cardcolor,
                shadowColor: Color.fromARGB(255, 239, 175, 78),
                elevation: 10,
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${data['foodDetails']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '${data['No of Servings']} servings',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  formattedTime,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${data['Phone_Number']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.green.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 10,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _acceptedFoodIds.add(document.id);
                                          });
                                          await FirebaseFirestore.instance
                                              .collection('foodPosts')
                                              .doc(document.id)
                                              .update({
                                            'status': 'Accepted',
                                            'acceptedBy': FirebaseAuth
                                                .instance.currentUser!.uid,
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Food Accepted successfully!'),
                                            backgroundColor: Colors.green,
                                          ));
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                          onPrimary: Colors.white,
                                        ),
                                        child: const Text(
                                          'Accept',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data['foodDetails']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${data['No of Servings']} servings',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formattedTime,
                          style: TextStyle(fontSize: 14),
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
    );
  }
}

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(236, 246, 128, 56),
        title: const Text('History'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color.fromARGB(255, 254, 189, 139),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('foodPosts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final acceptedFoodPosts = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data.containsKey('status') &&
                data['acceptedBy'] == FirebaseAuth.instance.currentUser!.uid;
          }).toList();

          if (acceptedFoodPosts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_dissatisfied,
                    size: 80,
                    color: Colors.black,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You have not accepted any food yet!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: acceptedFoodPosts.length,
            itemBuilder: (BuildContext context, int index) {
              final document = acceptedFoodPosts[index];
              final Color cardcolor = Color.fromRGBO(43, 191, 20, 1);
              final data = document.data() as Map<String, dynamic>;
              final timestamp = data['timeCooked'] as Timestamp;
              final dateTime = timestamp.toDate();
              final formattedTime =
                  DateFormat('dd MMMM yyyy, hh:mm a').format(dateTime);
              return Card(
                color: cardcolor,
                shadowColor: Color.fromARGB(255, 13, 244, 20).withOpacity(0.5),
                elevation: 20,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    data['foodDetails'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '${data['No of Servings']} servings',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 28, 27, 27),
                      fontSize: 14,
                    ),
                  ),
                  trailing: Text(
                    formattedTime,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 23, 22, 22),
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
