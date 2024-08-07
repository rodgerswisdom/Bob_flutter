import 'package:flutter/material.dart';
import '../question_page.dart';
import '../../services/api_service.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  Map<String, dynamic> _questions = {};
  final List<Map<String, String>> _userResponses = [];
  bool _loading = true;
  String _errorMessage = '';

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
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load questions. Please try again later.';
        _loading = false;
      });
    }
  }

  void _saveResponse(String questionId, String answer) {
    setState(() {
      _userResponses
          .removeWhere((response) => response['questionId'] == questionId);
      _userResponses.add({'questionId': questionId, 'answer': answer});
    });
    print('questionId: $questionId, answer: $answer');
  }

  void _submitResponses() async {
    try {
      await ApiService.submitResponses(_userResponses);

      print('Responses submitted successfully');
      // Handle successful submission or navigate to a different screen
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Handle error (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to submit responses. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : QuestionPage(
                  questions: _questions,
                  questionIds: _questions.keys.toList(),
                  onAnswerSelected: _saveResponse,
                  onCompleted: _submitResponses,
                ),
    );
  }
}
