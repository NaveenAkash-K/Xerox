import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final registerNoController = TextEditingController();

  var isLogin = false;
  var isAuthentication = false;

  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  void signUp() async {
    if (emailController.text.trim().isEmpty ||
        !emailController.text.contains('@') ||
        passwordController.text.trim().length < 6 ||
        userNameController.text.trim().isEmpty ||
        registerNoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Input. Please Check again!'),
        ),
      );
      return;
    }
    setState(() {
      isAuthentication = true;
    });

    try {
      final userCredentials = await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.code),
        ),
      );
    }

    fireStore.collection('users').doc(firebaseAuth.currentUser!.uid).set({
      'uid': firebaseAuth.currentUser!.uid,
      'email': emailController.text,
      'username': userNameController.text,
      'password': passwordController.text,
      'registerNo': registerNoController.text,
      'userType': "student",
    });

    setState(() {
      isAuthentication = false;
    });
  }

  void login() async {
    if (emailController.text.trim().isEmpty ||
        !emailController.text.contains('@') ||
        passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Input. Please Check again!'),
        ),
      );
      return;
    }
    setState(() {
      isAuthentication = true;
    });
    try {
      final userCredentials = await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.code),
        ),
      );
    }

    setState(() {
      isAuthentication = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isLogin ? "Login" : "Signup",
                style: GoogleFonts.openSans()
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (isLogin == false)
                TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(
                    label: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 10),
                        Text("Username")
                      ],
                    ),
                  ),
                ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 10),
                      Text("Email")
                    ],
                  ),
                ),
              ),
              TextField(
                controller: registerNoController,
                decoration: const InputDecoration(
                  label: Row(
                    children: [
                      Icon(Icons.numbers_rounded),
                      SizedBox(width: 10),
                      Text("Register No")
                    ],
                  ),
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Row(
                    children: [
                      Icon(Icons.password),
                      SizedBox(width: 10),
                      Text("Password")
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLogin ? login : signUp,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary),
                child: isAuthentication
                    ? const SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(isLogin ? "Login" : "Sign Up"),
              ),
              TextButton(
                onPressed: isLogin
                    ? () {
                        setState(() {
                          isLogin = false;
                        });
                      }
                    : () {
                        setState(() {
                          isLogin = true;
                        });
                      },
                child: Text(isLogin
                    ? "New User? SignUp"
                    : "Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
