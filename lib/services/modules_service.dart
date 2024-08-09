import 'dart:convert';
import 'package:http/http.dart' as http;
import './user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModulesService {
  static const String baseUrl = 'https://bob-server.vercel.app';

  static Future<Map<String, dynamic>> fetchModules() async {
    final token = await UserService.getToken();
    if (token == null) {
      throw Exception('Token is Null');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/modules'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['modules'] ?? {}; // Adjust to the correct field in response
    } else {
      throw Exception('Failed to load Modules');
    }
  }

  static Future<Map<String, dynamic>> fetchSingleModule() async {
    final token = await UserService.getToken();
    if (token == null) {
      throw Exception('Token is Null');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/modules'), // Update this endpoint if needed
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Module Data: $data');
      final module = data['data'] ?? {};
      if (module.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        final moduleJson = jsonEncode(module);
        await prefs.setString('cachedModule', moduleJson);
        return module;
      } else {
        throw Exception('No module found');
      }
    } else {
      throw Exception('Failed to load Module');
    }
  }

  static Future<void> createModule(Map<String, dynamic> module) async {
    final token = await UserService.getToken();

    if (token == null) {
      throw Exception('Token is null. Unable to create module.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/modules'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(module),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Module');
    }
  }

  static Future<void> updateHelpfulField(String moduleId, bool helpful) async {
    final token = await UserService.getToken();

    if (token == null) {
      throw Exception('Token is null. Unable to update helpful field.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/modules/$moduleId/helpful'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode({'helpful': helpful}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update helpful field');
    }
  }

  static Future<Map<String, dynamic>> fetchAllModulesForUser() async {
    final token = await UserService.getToken();
    if (token == null) {
      throw Exception('Token is Null');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/modules'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['modules'] ?? {}; // Adjust to the correct field in response
    } else {
      throw Exception('Failed to load user modules');
    }
  }
}
