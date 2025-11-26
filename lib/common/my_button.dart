import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.fontSize,
    this.fontFamily,
  });
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Color(0xFF3D3D3D),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? 20,
            fontFamily: fontFamily ?? 'Jersey25',
          ),
        ),
      ),
    );
  }
}
