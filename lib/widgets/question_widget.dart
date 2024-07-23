import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onSelected;

  QuestionWidget({required this.question, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: TextStyle(fontSize: 18),
        ),
        ...question['choices'].map<Widget>((choice) {
          return ElevatedButton(
            onPressed: () => onSelected(choice),
            child: Text(choice),
          );
        }).toList(),
      ],
    );
  }
}
