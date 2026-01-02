import 'package:flutter/material.dart';

class MyTextformfield extends StatelessWidget {
  const MyTextformfield({
    super.key,
    required this.labelText,
    required this.controller,
    this.width,
    this.color,
    this.labelStyle,
    this.obscureText = false,
    this.suffixIcon,
    this.enabled = true,
    required this.validator,
  });

  final String labelText;
  final TextEditingController controller;
  final double? width;
  final Color? color;
  final TextStyle? labelStyle;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool enabled;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 350,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF535353),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          labelText: labelText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: color ?? Colors.black, width: 1),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: labelStyle ??
              const TextStyle(
                fontFamily: 'Jersey25',
                color: Color(0xFFBDBDBD),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }
}
