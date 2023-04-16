import 'package:flutter/material.dart';
import 'package:mealsmission/pages/loginscreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NgoHome extends StatefulWidget {
  NgoHome({Key? key}) : super(key: key);

  @override
  State<NgoHome> createState() => _NgoHomeState();
}

class _NgoHomeState extends State<NgoHome> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    Availablefood(),
    const History(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(236, 246, 128, 56),
        actions: [
          IconButton(
              alignment: Alignment.centerLeft,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(
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
                        const Text('Solve Hunger'),
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
                        const Text('Even a Small Step is a Step'),
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
                        const Text('Donate and Save'),
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
            title: const Text('Available Food'),
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

class Availablefood extends StatefulWidget {
  const Availablefood({super.key});

  @override
  State<Availablefood> createState() => _AvailablefoodState();
}

class _AvailablefoodState extends State<Availablefood> {
  Set<String> _acceptedFoodIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(236, 246, 128, 56),
        title: const Text('Available Food'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('foodPosts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final availableFoodDocs = snapshot.data!.docs
              .where((doc) => !_acceptedFoodIds.contains(doc.id))
              .toList();
          return ListView(
            children: availableFoodDocs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              Timestamp timestamp = data['timeCooked'];
              DateTime dateTime = timestamp.toDate();
              String formattedTime =
                  DateFormat('dd MMMM yyyy, hh:mm a').format(dateTime);
              return Card(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Column(
                            children: [
                              Text('${data['foodDetails']}'),
                              Text('${data['No of Servings']} servings'),
                              Text(formattedTime),
                              Text('${data['Phone_Number']}'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
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
                                    },
                                    child: Text('Accept'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    title: Text('${data['foodDetails']}'),
                    subtitle: Text('${data['No of Servings']} servings'),
                    trailing: Text(formattedTime),
                  ),
                ),
              );
            }).toList(),
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
        backgroundColor: Color.fromARGB(236, 246, 128, 56),
        title: const Text('History'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('foodPosts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Widget> acceptedFoodPosts =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            if (data['acceptedBy'] == FirebaseAuth.instance.currentUser!.uid) {
              Timestamp timestamp = data['timeCooked'];
              DateTime dateTime = timestamp.toDate();
              String formattedTime =
                  DateFormat('dd MMMM yyyy, hh:mm a').format(dateTime);
              return Card(
                color: Colors.green[100],
                child: ListTile(
                  title: Text('${data['foodDetails']}'),
                  subtitle: Text('${data['No of Servings']} servings'),
                  trailing: Text(formattedTime),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }).toList();
          return acceptedFoodPosts.isEmpty
              ? Center(
                  child: Text(
                    'You have not accepted any food yet!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                )
              : ListView(
                  children: acceptedFoodPosts,
                );
        },
      ),
    );
  }
}
