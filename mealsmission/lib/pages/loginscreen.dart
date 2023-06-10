import 'package:flutter/material.dart';
import 'package:mealsmission/components/button.dart';
import 'package:mealsmission/components/textfield.dart';
import 'package:mealsmission/pages/registerscreen.dart';
import 'package:mealsmission/pages/Volunteer.dart';
import 'package:mealsmission/pages/Ngo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Firebase Authentication instance
  final _auth = FirebaseAuth.instance;

  // error message state
  String? _errorMessage;
  // sign user in method
  void signUserIn() async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: usernameController.text.trim(),
          password: passwordController.text.trim());
      final uid = userCredential.user!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final role = userDoc['role'];
      if (role == 'NGO') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NgoHome()),
        );
      } else if (role == 'Volunteer') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VolHome()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _errorMessage = 'No user found for that email.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'wrong-password') {
        setState(() {
          _errorMessage = 'Wrong password provided for that user.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect Password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 102, 13),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150),

              Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('lib/images/mealsmission.png')),

              const SizedBox(height: 30),

              // welcome back, you've been missed!
              const Text(
                'Welcome, You are on the Right Track!',
                style: TextStyle(
                  color: Color.fromARGB(255, 81, 77, 77),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                onTap: signUserIn,
              ),

              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member?',
                    style: TextStyle(color: Color.fromARGB(255, 35, 34, 34)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Row(
                      children: [
                        SizedBox(width: 4),
                        Text('Register Now',
                            style: TextStyle(
                              color: Color.fromARGB(255, 7, 79, 248),
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
