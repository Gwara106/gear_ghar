import 'package:flutter/material.dart';
import 'package:gear_ghar/common/my_button.dart';
import 'package:gear_ghar/common/my_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController Emailcontroller = TextEditingController();
  final TextEditingController Passwordcontroller = TextEditingController();
  bool rememberMe = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD0D0D0),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Image.asset('assets/images/logo.png', width: 150),

              const Text(
                'Welcome to GearGhar',
                style: TextStyle(
                  fontFamily: 'Jersey25',
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
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
                      labelText: 'example@gmail.com',
                      controller: Emailcontroller,
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
                      labelText: '*********',
                      controller: Passwordcontroller,
                      obscureText: !_isPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 23),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'Jersey25',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                              fillColor: WidgetStateProperty.all(Colors.white),
                            ),
                            const SizedBox(width: 0),
                            const Text(
                              'Remember Me',
                              style: TextStyle(
                                fontFamily: 'Jersey25',
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    MyButton(
                      onPressed: () {},
                      text: 'Login',
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF272727),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: const Color.fromARGB(255, 99, 99, 99),
                      thickness: 1,
                      indent: 20,
                      endIndent: 10,
                    ),
                  ),
                  const Text(
                    'Or With',
                    style: TextStyle(
                      fontFamily: 'Jersey25',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: const Color.fromARGB(255, 99, 99, 99),
                      thickness: 1,
                      indent: 10,
                      endIndent: 20,
                    ),
                  ),
                ],
              ),

              MyButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF474747),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ), // ✅ Left padding
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/icons/facebook.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '       Login with Facebook',
                      style: TextStyle(
                        fontFamily: 'Jersey25',
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              MyButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF474747),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/icons/google.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '       Login with Google',
                      style: TextStyle(
                        fontFamily: 'Jersey25',
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(
                        fontFamily: 'Jersey25',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Normal text color
                      ),
                    ),
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(
                        fontFamily: 'Jersey25',
                        fontSize: 20,
                        color: Color.fromARGB(
                          255,
                          29,
                          0,
                          133,
                        ), // ✅ Different color for Sign Up
                        fontWeight: FontWeight.bold,
                      ),
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
