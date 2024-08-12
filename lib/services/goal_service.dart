import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_service.dart';
import '../models/goal_model.dart';

class GoalService {
  static const String baseUrl = 'https://bob-server.vercel.app';

  // Fetch all goals
  static Future<List<Goal>> fetchGoals() async {
    final token = await UserService.getToken();
    print('Token in fetchGoals: $token');

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

    print('Status code in fetchGoals: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      if (responseJson is Map<String, dynamic> &&
          responseJson.containsKey('goals')) {
        final goalsList = responseJson['goals'] as List<dynamic>;
        return goalsList
            .map((json) => Goal.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load goals: ${response.statusCode}');
    }
  }

  // Post a new goal
  static Future<void> postGoal(Goal goal) async {
    final token = await UserService.getToken();

    if (token == null) {
      throw Exception('No token available');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/goals'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(goal.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post goal: ${response.statusCode}');
    }
  }

  // Fetch goal statistics
  static Future<Map<String, int>> fetchGoalStatistics() async {
    final token = await UserService.getToken();
    print('Token in fetchGoalStatistics: $token');

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

    print('Status code in fetchGoalStatistics: ${response.statusCode}');
    print('Goals Data: ${response.body}');

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      if (responseJson is Map<String, dynamic> &&
          responseJson.containsKey('goals')) {
        final goalsList = responseJson['goals'] as List<dynamic>;

        final achievedCount = goalsList
            .where((goal) => goal['achieved'] == true)
            .length;
        final notAchievedCount = goalsList
            .where((goal) => goal['achieved'] == false)
            .length;
        final totalCount = goalsList.length;

        return {
          'achieved': achievedCount,
          'notAchieved': notAchievedCount,
          'total': totalCount,
        };
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load goal statistics: ${response.statusCode}');
    }
  }

  // Update an existing goal
  static Future<void> updateGoal(String goalId, bool achieved) async {
    final token = await UserService.getToken();

    if (token == null) {
      throw Exception('No token available');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/goals/$goalId'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode({'achieved': achieved}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update goal: ${response.statusCode}');
    }
  }
}
