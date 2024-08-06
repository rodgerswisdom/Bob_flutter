import 'package:flutter/material.dart';
import '../models/button_model.dart';

class CustomButton extends StatelessWidget {
  final ButtonModel buttonModel;

  const CustomButton({
    super.key,
    required this.buttonModel,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonModel.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonModel.color, // Background color
        minimumSize: const Size(double.infinity, 50), // Full width and height of 50
      ),
      child: Text(
        buttonModel.text,
        style: const TextStyle(color: Colors.white), // Text color
      ),
    );
  }
}
