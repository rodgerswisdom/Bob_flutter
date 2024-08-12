import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AnswersScreen extends StatefulWidget {
  @override
  _AnswersScreenState createState() => _AnswersScreenState();
}

class _AnswersScreenState extends State<AnswersScreen> {
  Future<Map<String, List<Map<String, dynamic>>>>? _answersFuture;
  Map<String, List<Map<String, dynamic>>>? _questionToAnswers;
  Set<String> _expandedQuestions = {}; // Keeps track of questions with expanded answers

  @override
  void initState() {
    super.initState();
    _answersFuture = ApiService.getUserAnswers();
  }

  void _toggleExpand(String questionId) {
    setState(() {
      if (_expandedQuestions.contains(questionId)) {
        _expandedQuestions.remove(questionId);
      } else {
        _expandedQuestions.add(questionId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Answers'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: _answersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No answers available'));
          }

          final questionToAnswers = snapshot.data!;
          _questionToAnswers = questionToAnswers;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: questionToAnswers.entries.map((entry) {
                final questionId = entry.key;
                final answers = entry.value;
                final isExpanded = _expandedQuestions.contains(questionId);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questionId, // Replace this with the actual question text retrieval if available
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      answers.isNotEmpty ? answers.first['answer'] ?? 'No answer provided' : 'No answer provided',
                      style: TextStyle(fontSize: 16),
                    ),
                    if (answers.length > 1) ...[
                      SizedBox(height: 8.0),
                      TextButton(
                        onPressed: () => _toggleExpand(questionId),
                        child: Text(isExpanded ? 'Show Less' : 'Show More'),
                      ),
                      if (isExpanded) ...[
                        SizedBox(height: 8.0),
                        ...answers.skip(1).map((answer) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              answer['answer'] ?? 'No answer provided',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ],
                    ],
                    SizedBox(height: 16.0),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
