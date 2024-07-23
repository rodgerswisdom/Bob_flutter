import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://bob-server.vercel.app';

  static Future<Map<String, dynamic>> fetchQuestions() async {
    final response = await http.get(Uri.parse('$baseUrl/questions'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['AssessmentQuestions'];
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<void> submitResponses(List<Map<String, String>> responses, String userId) async {
    final data = {'answers': responses, 'userId': userId};
    final response = await http.post(
      Uri.parse('$baseUrl/submit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to submit responses');
    }
  }
}
