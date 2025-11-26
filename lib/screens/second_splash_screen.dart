import 'package:flutter/material.dart';
import 'package:gear_ghar/common/my_button.dart';

class SecondSplashScreen extends StatelessWidget {
  const SecondSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0D0D0),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 200),

              Text(
                'Where Bikes Are Made',
                style: TextStyle(
                  fontFamily: 'Jersey25',
                  fontSize: 39,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'And Dreams Come True',
                style: TextStyle(
                  fontFamily: 'Jersey25',
                  fontSize: 39,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset('assets/images/logo.png', width: 270),
              SizedBox(height: 200),
              MyButton(onPressed: () {}, text: 'Get Started', fontSize: 30),
            ],
          ),
        ),
      ),
    );
  }
}
