import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/services/auth/login_or_register.dart';
import 'package:tutor_app/pages/home_page.dart';

class AuthCheck extends StatelessWidget {
  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            // it will listen to any authStateChanges() changes and rebuild
            // checking if the user is logged in or not
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return snapshot.data?.uid != null // if user is logged in

                  ? HomePage() // show the home page

                  : LoginOrRegister(); // if not ... show the login page
            }));
  }
}
