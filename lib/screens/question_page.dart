import 'package:flutter/material.dart';
import '../widgets/progress_bar.dart';
import '../widgets/question_widget.dart';

class QuestionPage extends StatefulWidget {
  final Map<String, dynamic> questions;
  final List<String> questionIds;
  final Function(String, String) onAnswerSelected;
  final Function onCompleted;

  QuestionPage({
    required this.questions,
    required this.questionIds,
    required this.onAnswerSelected,
    required this.onCompleted,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int _currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final questionId = widget.questionIds[_currentQuestionIndex];
    final question = widget.questions[questionId];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Category: ${question['category']}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ProgressBar(
            progress: (_currentQuestionIndex + 1) / widget.questionIds.length,
          ),
          const SizedBox(height: 16.0),
          QuestionWidget(
            question: question,
            onSelected: (choice) {
              widget.onAnswerSelected(question['id'], choice);
              if (_currentQuestionIndex < widget.questionIds.length - 1) {
                setState(() {
                  _currentQuestionIndex++;
                });
              } else {
                widget.onCompleted();
              }
            },
          ),
          const SizedBox(height: 20.0),
          
        ],
      ),
    );
  }
}
