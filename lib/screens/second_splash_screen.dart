import 'package:flutter/material.dart';

class SecondSplashScreen extends StatelessWidget {
  const SecondSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 200),

              Text(
                'Where Bikes Are Made',
                style: TextStyle(fontFamily: 'Jersey25', fontSize: 25),
              ),
              Text(
                'And Dreams Come True',
                style: TextStyle(fontFamily: 'Jersey25', fontSize: 25),
              ),
              Image.asset('assets/images/logo.png', width: 270),
            ],
          ),
        ),
      ),
    );
  }
}
