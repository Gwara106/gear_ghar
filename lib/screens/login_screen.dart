import 'package:flutter/material.dart';
import 'package:gear_ghar/common/my_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController Emailcontroller = TextEditingController();
  final TextEditingController Passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', width: 100),
              const SizedBox(height: 10),

              const Text(
                'Welcome to GearGhar',
                style: TextStyle(fontFamily: 'Jersey25', fontSize: 20),
              ),

              const SizedBox(height: 5),

              Container(
                width: 380,
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xFF474747),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 23),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'Jersey25',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    MyTextformfield(
                      labelText: 'Email',
                      hintText: 'example@gmail.com',
                      controller: Emailcontroller,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 15),

                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 23),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'Jersey25',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    MyTextformfield(
                      labelText: 'Password',
                      hintText: '**********',
                      controller: Passwordcontroller,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
