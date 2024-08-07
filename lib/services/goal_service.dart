import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_service.dart';

class GoalService {
  static const String baseUrl = 'https://bob-server.vercel.app';

  static Future<Map<String, dynamic>> fetchGoals() async {
    final token = await UserService.getToken();

    if (token == null) {
      throw Exception('No token available');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/goals'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return responseJson['Goals'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load goals: ${response.statusCode}');
    }
  }
}



