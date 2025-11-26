import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.fontSize,
    this.fontFamily,
    this.borderRadius = 8.0,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: MouseRegion(
        cursor: SystemMouseCursors.click, // This changes the cursor
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color(0xFF3D3D3D),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
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
      ),
    );
  }
}
