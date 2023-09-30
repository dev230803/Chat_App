import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/screens.dart/home.dart';
import 'package:my_chat/screens.dart/signin.dart';

import 'package:my_chat/screens.dart/signup.dart';
import 'package:my_chat/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: FutureBuilder(
            future: AuthMethods().getcurrentUser(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return const HomeScreen();
              } else {
                return const SignIn();
              }
            })),
  );
}
