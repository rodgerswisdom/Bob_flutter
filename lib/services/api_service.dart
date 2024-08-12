import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_service.dart';

class ApiService {
  static const String baseUrl = 'https://bob-server.vercel.app/assessments';

  // Fetch questions from the backend
  static Future<Map<String, dynamic>> fetchQuestions() async {
    final response = await http.get(Uri.parse('$baseUrl/questions'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['AssessmentQuestions'];
    } else {
      throw Exception('Failed to load questions');
    }
  }

  // Submit responses to the backend
  static Future<void> submitResponses(List<Map<String, String>> answers) async {
    final token = await UserService.getToken();
    if (token == null) {
      throw Exception('No token available');
    }

    final data = {
      'answers': answers,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/answers'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit responses: ${response.body}');
    }
  }

  // Fetch answers from the backend
  static Future<List<Map<String, dynamic>>> fetchAnswers() async {
    final token = await UserService.getToken();
    if (token == null) {
      throw Exception('No token available');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/answers'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // Ensure the JSON is a list
      if (jsonResponse is List) {
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else {
        throw Exception('Unexpected JSON structure for answers');
      }
    } else {
      throw Exception('Failed to load answers');
    }
  }

  // Get user answers by mapping questions to answers
  static Future<Map<String, List<Map<String, dynamic>>>> getUserAnswers() async {
    try {
      // Fetch questions and answers
      final questionsResponse = await fetchQuestions();
      final answersResponse = await fetchAnswers();

      // Create a map to store answers by question text
      final Map<String, List<Map<String, dynamic>>> questionToAnswers = {};

      // Initialize the map with empty lists for each question
      for (var entry in questionsResponse.entries) {
        final questionId = entry.key;
        final questionText = entry.value['question']; // Assuming the question text is under the 'question' key
        questionToAnswers[questionText] = [];
      }

      // Populate the map with answers
      for (var userAnswers in answersResponse) {
        final answers = List<Map<String, dynamic>>.from(userAnswers['answers']);
        for (var answer in answers) {
          final questionId = answer['questionId'];
          final questionText = questionsResponse[questionId]['question']; // Retrieve the question text
          if (questionToAnswers.containsKey(questionText)) {
            questionToAnswers[questionText]!.add(answer);
          }
        }
      }

      return questionToAnswers;
    } catch (e) {
      throw Exception('Failed to fetch user answers: $e');
    }
  }
}
