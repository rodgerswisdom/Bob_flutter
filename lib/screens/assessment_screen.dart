// ignore_for_file: duplicate_import
// This file will handle the main logic for fetching questions and navigation between question pages.

import 'package:flutter/material.dart';
import 'question_page.dart';
import '../services/user_service2.dart';
import '../screens/question_page.dart';
import '../services/api_service.dart';


class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
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
    final questions = await ApiService.fetchQuestions();
    setState(() {
      _questions = questions;
    });
  }

  void _saveResponse(String questionId, String answer) {
    _userResponses.add({'questionId': questionId, 'answer': answer});
  }

  void _submitResponses() async {
    final userId = await UserService.getUserId();
    await ApiService.submitResponses(_userResponses, userId!);
    // Handle successful submission or navigate to a different screen
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
