import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onSelected;

  const QuestionWidget({super.key,
    required this.question,
    required this.onSelected
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          question['question'],
          style: const TextStyle(fontSize: 18),
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
