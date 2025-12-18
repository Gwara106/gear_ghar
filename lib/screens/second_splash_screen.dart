import 'package:flutter/material.dart';
import 'package:gear_ghar/common/my_button.dart';
import 'package:gear_ghar/screens/login_screen.dart';

class SecondSplashScreen extends StatelessWidget {
  const SecondSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0D0D0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // ✅ prevents overflow on tablets
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // smaller padding

                Text(
                  'Where Bikes Are Made',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Jersey25',
                    fontSize: 36, // slightly responsive
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  'And Dreams Come True',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Jersey25',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Image.asset(
                  'assets/images/logo.png',
                  width:
                      MediaQuery.of(context).size.width * 0.4, // ✅ responsive
                ),



                MyButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  text: 'Get Started',
                  fontSize: 28,
                  height: 65,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
