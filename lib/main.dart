import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xerox/screens/admin_screen.dart';
import 'package:xerox/screens/auth.dart';
import 'package:xerox/color_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:xerox/screens/student_screen.dart';
import 'package:xerox/screens/xerox_shop_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseAuth.instance.signOut();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // User is logged in
              final user = snapshot.data!;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get(),
                builder: (context, userSnapshot) {
                  // if (userSnapshot.connectionState == ConnectionState.done) {
                  final userType = userSnapshot.data?['userType'];

                  if (userType == 'student') {
                    return StudentScreen();
                  } else if (userType == 'admin') {
                    return AdminScreen();
                  } else {
                    return XeroxShopScreen();
                  }
                  // }
                },
              );
            } else {
              // User is not logged in
              return Auth();
            }
          },
        ),
      );
}
