import 'package:flutter/material.dart';

class ButtonModel {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  
  ButtonModel({
    required this.text,
    required this.onPressed,
    required this.color,
  });
}
