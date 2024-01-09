import 'package:flutter/material.dart';
import 'package:tutor_app/components/user_tile.dart';
import 'package:tutor_app/services/auth/auth_service.dart';
import 'package:tutor_app/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // chat & auth services

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Home'),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Text('H O M E'),
        ));
  }
}
