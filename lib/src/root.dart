import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clone_instagram/src/app.dart';
import 'package:flutter_clone_instagram/src/pages/login.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext _, AsyncSnapshot<User?> user) {
        if (user.hasData) {
          return const App();
        } else {
          return const Login();
        }
    });
  }
}
