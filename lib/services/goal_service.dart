import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_service.dart';
import '../models/goal_model.dart';

class GoalService {
  static const String baseUrl = 'https://bob-server.vercel.app';

  static Future<List<Goal>> fetchGoals() async {
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
      final responseJson = jsonDecode(response.body) as List<dynamic>;
      print('Goal fetched successfully');
      return responseJson.map((json) => Goal.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load goals: ${response.statusCode}');
    }
  }
}
