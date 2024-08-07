import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onSelected;

  const QuestionWidget(
      {super.key, required this.question, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          question['question'],
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40.0),
        ...question['choices'].map<Widget>((choice) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onSelected(choice),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    textStyle: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                    ),
                  ),
                  child: Text(
                    choice,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ));
        }).toList(),
      ],
    );
  }
}
