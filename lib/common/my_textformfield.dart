import 'package:flutter/material.dart';

class MyTextformfield extends StatelessWidget {
  const MyTextformfield({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.width,
    this.color,
  });

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 350, // applies width if provided
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: labelText,
          hintText: hintText,
          fillColor: color ?? const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
