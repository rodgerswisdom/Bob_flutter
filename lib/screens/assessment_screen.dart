import 'package:flutter/material.dart';
import 'question_page.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  Map<String, dynamic> _questions = {};
  final List<Map<String, String>> _userResponses = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final questions = await ApiService.fetchQuestions();
      setState(() {
        _questions = questions;
      });
    } catch (e) {
      // Handle error (e.g., show an error message)
      print('Error fetching questions: $e');
    }
  }

  void _saveResponse(String questionId, String answer) {
    setState(() {
      _userResponses.removeWhere((response) => response['questionId'] == questionId);
      _userResponses.add({'questionId': questionId, 'answer': answer});
    });
    print('questionId: $questionId, answer: $answer');
  }

  void _submitResponses() async {
    try {
      await ApiService.submitResponses(_userResponses);
      // Handle successful submission or navigate to a different screen
      print('Responses submitted successfully');
    } catch (e) {
      // Handle error (e.g., show an error message)
      print('Error submitting responses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Assessment')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final questionIds = _questions.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Assessment')),
      body: QuestionPage(
        questions: _questions,
        questionIds: questionIds,
        onAnswerSelected: _saveResponse,
        onCompleted: _submitResponses,
      ),
    );
  }
}
