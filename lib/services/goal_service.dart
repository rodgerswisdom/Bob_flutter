import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class GoalService {
  static const String baseUrl = 'https://bob-server.vercel.app/';

  static Future<Map<String, dynamic>> fetchGoals() async {
    final response = await http.get(Uri.parse('$baseUrl/goals'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['Goals'];
    } else {
      throw Exception('Failed to load Goals');
    }
  }

  static Future<void> submitGoals(List<Map<String, String>> responses, String userId) async {
    final data = {'answers': responses, 'userId': userId};
    final response = await http.post(
      Uri.parse('$baseUrl/questions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to submit responses');
    }
  }
}