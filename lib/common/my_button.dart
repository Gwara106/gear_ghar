
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    this.text, // Make optional
    this.child, // ✅ Add this
    this.color,
    this.fontSize,
    this.fontFamily,
    this.borderRadius,
    this.style,
    this.height,
  });

  final VoidCallback onPressed;
  final String? text;
  final Widget? child; // ✅ New property
  final Color? color;
  final double? fontSize;
  final String? fontFamily;
  final double? borderRadius;
  final ButtonStyle? style;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: height ?? 50,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ElevatedButton(
          style: style ??
              ElevatedButton.styleFrom(
                backgroundColor: color ?? const Color(0xFF3D3D3D),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
                ),
              ),
          onPressed: onPressed,
          child: child ??
              Text(
                text ?? '',
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
