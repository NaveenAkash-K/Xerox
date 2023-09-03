import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminScreen extends StatelessWidget {
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xerox'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          TextButton.icon(
            onPressed: () {
              firebaseAuth.signOut();
            },
            icon: Icon(Icons.logout),
            label: Text('Logout'),
          )
        ],
      ),
      body: Text('Admin'),
    );
  }
}
