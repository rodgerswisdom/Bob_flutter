import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = 'https://bob-server.vercel.app'; // Replace with your backend URL

  // Get User ID from Shared Preferences
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<String?> getToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('x-token');
  }


  static Future<bool> register(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'displayName': name,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        // Registration successful
        return true;
      } else {
        // Handle different types of errors
        final responseBody = json.decode(response.body);
        String errorMessage = responseBody['error'] ?? 'An unknown error occurred';
        print('Registration failed: $errorMessage');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseBody['token']);
        return responseBody;
      } else {
        final responseBody = json.decode(response.body);
        String errorMessage = responseBody['error'] ?? 'An unknown error occurred';
        print('Login failed: $errorMessage');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  static Future<bool> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/logout'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Logout successful, remove token from shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        return true;
      } else {
        final responseBody = json.decode(response.body);
        String errorMessage = responseBody['error'] ?? 'An unknown error occurred';
        print('Logout failed: $errorMessage');
        return false;
      }
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getMe(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody;
      } else {
        final responseBody = json.decode(response.body);
        String errorMessage = responseBody['error'] ?? 'An unknown error occurred';
        print('Failed to get user data: $errorMessage');
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  
}
