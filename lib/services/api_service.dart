import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_service.dart';

class ApiService {
  static const String baseUrl = 'https://bob-server.vercel.app/assessments';

  static Future<Map<String, dynamic>> fetchQuestions() async {
    final response = await http.get(Uri.parse('$baseUrl/questions'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['AssessmentQuestions'];
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<void> submitResponses(List<Map<String, String>> answers) async {
    final token = await UserService.getToken();
    if (token == null) {
      throw Exception('No token available');
    }

    final data = {
      'answers': answers,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/answers'), // Corrected endpoint
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit responses: ${response.body}');
    }
  }
}
