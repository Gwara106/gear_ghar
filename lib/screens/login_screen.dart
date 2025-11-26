import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', width: 100),
              Text(
                'Welcome to GearGhar',
                style: TextStyle(fontFamily: 'Jersey25', fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
