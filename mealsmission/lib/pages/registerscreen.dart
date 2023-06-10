import 'package:flutter/material.dart';
import 'package:mealsmission/components/regbutton.dart';
import 'package:mealsmission/components/textfield.dart';
import 'package:mealsmission/pages/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userRole;
  String? _errorMessage;

  // register user method
  void registerUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    if (!EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (password != confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password Do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_userRole != null) {
        final userId = userCredential.user!.uid;
        await _firestore.collection('users').doc(userId).set({
          'email': email,
          'role': _userRole,
        });
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          _errorMessage = 'The password provided is too weak.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _errorMessage = 'The account already exists for that email.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account Already Exists for that email.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create account. Please try again later.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
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
              const SizedBox(height: 50),

              // logo
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('lib/images/mealsmission.png')),

              const SizedBox(height: 30),

              // registration form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    // welcome message
                    const Text(
                      'Join our mission to create a better world!',
                      style: TextStyle(
                        color: Color.fromARGB(255, 81, 77, 77),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // username textfield
                    MyTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // email textfield
                    MyTextField(
                      controller: emailController,
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

                    // confirm password textfield
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 25),
                    const Text('Select your role:'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _userRole = 'NGO';
                            });
                          },
                          child: Card(
                            color: _userRole == 'NGO'
                                ? Colors.green
                                : Colors.white,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('NGO'),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _userRole = 'Volunteer';
                            });
                          },
                          child: Card(
                            color: _userRole == 'Volunteer'
                                ? Colors.green
                                : Colors.white,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Volunteer'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // register button
                    regbutton(
                      onTap: registerUser,
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),

              // already a member? sign in now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already a member?',
                    style: TextStyle(color: Color.fromARGB(255, 35, 34, 34)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Row(
                      children: [
                        SizedBox(width: 4),
                        Text('Sign in',
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
