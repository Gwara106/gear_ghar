import 'package:flutter/material.dart';

class VaScreen extends StatelessWidget {
  const VaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [
        Container(
          width: 144,
          height: 153,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://picsum.photos/144/153"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          width: 312,
          height: 303,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFF474747),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 14,
                top: 25,
                child: SizedBox(
                  width: 275,
                  height: 154,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 3,
                        top: 24,
                        child: Container(
                          width: 272,
                          height: 48,
                          decoration: ShapeDecoration(
                            color: Colors.white.withOpacity(0.07999999821186066),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Colors.black.withOpacity(0.4000000059604645),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 13,
                        top: 37,
                        child: SizedBox(
                          width: 257,
                          height: 20,
                          child: Text(
                            'example@gmail.com',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.699999988079071),
                              fontSize: 16,
                              fontFamily: 'Jersey 25',
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 47,
                          height: 18,
                          child: Text(
                            'Email',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Jersey 25',
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 3,
                        top: 110,
                        child: Container(
                          width: 272,
                          height: 44,
                          decoration: ShapeDecoration(
                            color: Colors.white.withOpacity(0.07999999821186066),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Colors.black.withOpacity(0.4000000059604645),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 246,
                        top: 122,
                        child: Container(
                          width: 18,
                          height: 21,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(children: []),
                        ),
                      ),
                      Positioned(
                        left: 13,
                        top: 122,
                        child: SizedBox(
                          width: 257,
                          height: 18,
                          child: Text(
                            '**************',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.699999988079071),
                              fontSize: 16,
                              fontFamily: 'Jersey 25',
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 87,
                        child: SizedBox(
                          width: 58,
                          height: 17,
                          child: Text(
                            'Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Jersey 25',
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 11.22,
                top: 188,
                child: SizedBox(
                  width: 277.78,
                  height: 31.69,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 22.78,
                        top: 14,
                        child: SizedBox(
                          width: 96,
                          height: 15,
                          child: Text(
                            'Remember Me',
                            style: TextStyle(
                              color: Color(0xFF000C14),
                              fontSize: 15,
                              fontFamily: 'Jersey 25',
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 10.69,
                        child: Container(
                          width: 18,
                          height: 21,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFFCDD1E0)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 178.78,
                        top: 0,
                        child: SizedBox(
                          width: 99,
                          height: 16,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Jersey 25',
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 14,
                top: 234.49,
                child: SizedBox(
                  width: 284,
                  height: 42.49,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 284,
                          height: 42.49,
                          decoration: ShapeDecoration(
                            color: Color(0xFF272727),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 130.51,
                        top: 13.36,
                        child: SizedBox(
                          width: 29.24,
                          height: 18.22,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8999999761581421),
                              fontSize: 13,
                              fontFamily: 'Jersey 25',
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 318,
          height: 20,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 10,
                child: Container(
                  width: 116,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 202,
                top: 10,
                child: Container(
                  width: 116,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 126,
                top: 0,
                child: Text(
                  'Or With',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.800000011920929),
                    fontSize: 20,
                    fontFamily: 'Jersey 25',
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 312,
          height: 48,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 312,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Color(0xFF3E3E3E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 77,
                top: 11,
                child: Text(
                  'Login with Facebook',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8999999761581421),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 9,
                top: 10,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://picsum.photos/26/26"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 312,
          height: 48,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 312,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Color(0xFF3E3E3E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 86,
                top: 11,
                child: Text(
                  'Login with Google',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 11,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://picsum.photos/26/26"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          'Welcome to GearGhar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontFamily: 'Jersey 25',
            height: 0,
          ),
        ),
        SizedBox(
          width: 250.03,
          height: 23.46,
          child: Stack(
            children: [
              Positioned(
                left: -0,
                top: -0,
                child: SizedBox(
                  width: 184.71,
                  height: 23.46,
                  child: Text(
                    'Don’t have an account ? ',
                    style: TextStyle(
                      color: Color(0xFF0D0D0D),
                      fontSize: 20,
                      fontFamily: 'Jersey 25',
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 189.82,
                top: -0,
                child: SizedBox(
                  width: 60.21,
                  height: 23.46,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF160062),
                      fontSize: 20,
                      fontFamily: 'Jersey 25',
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}