import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NgoHome extends StatefulWidget {
  NgoHome({Key? key}) : super(key: key);

  @override
  State<NgoHome> createState() => _NgoHomeState();
}

class _NgoHomeState extends State<NgoHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(child: Text('NGO')),
    );
  }
}
