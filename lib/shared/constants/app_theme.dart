import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFD0D0D0);
  static const Color secondary = Color(0xFF2C3E50);
  static const Color accent = Color(0xFFE74C3C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF7F8C8D);
  static const Color lightGrey = Color(0xFFECF0F1);
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontFamily: 'Jersey25',
    fontSize: 35,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 16,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: AppColors.grey,
  );
}
