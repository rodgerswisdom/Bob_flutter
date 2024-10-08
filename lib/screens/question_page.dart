import 'package:flutter/material.dart';
import '../widgets/progress_bar.dart';
import '../widgets/question_widget.dart';

class QuestionPage extends StatefulWidget {
  final Map<String, dynamic> questions;
  final List<String> questionIds;
  final Function(String, String) onAnswerSelected;
  final Function onCompleted;

  const QuestionPage({
    super.key,
    required this.questions,
    required this.questionIds,
    required this.onAnswerSelected,
    required this.onCompleted,
  });

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int _currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final questionId = widget.questionIds[_currentQuestionIndex];
    final question = widget.questions[questionId];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${question['category']}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
              height: 2.4,
            ),
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
