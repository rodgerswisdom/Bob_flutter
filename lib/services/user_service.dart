import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl =
      'https://bob-server.vercel.app'; // Replace with your backend URL


  // Get Token from Shared Preferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-token');
    print('Retrieved Token: $token');
    return token;
  }

  // Store Token in Shared Preferences
  static Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    print('Token stored: $token');
    await prefs.setString('x-token', token);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-token');
    print('Token removed from SharedPreferences');
  }

  static Future<void> storeUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(user);
    print('User stored: $userJson');
    await prefs.setString('user', userJson);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return json.decode(userJson);
    }
    return null;
  }

  static Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    print('User removed from SharedPreferences');
  }

  // Print Token for debugging
  static void printToken() async {
    final token = await getToken();
    print('Retrieved Token: $token');
  }

  // Register User
  static Future<bool> register(
      String email, String password, String name) async {
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
        String errorMessage =
            responseBody['error'] ?? 'An unknown error occurred';
        print('Registration failed: $errorMessage');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // Login User and Store Token
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
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
        await storeToken(responseBody['token']);
        await storeUser(responseBody['user']);
        return responseBody;
      } else {
        final responseBody = json.decode(response.body);
        String errorMessage =
            responseBody['error'] ?? 'An unknown error occurred';
        print('Login failed: $errorMessage');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // Logout User
  static Future<bool> logout() async {
    try {
      final token = await getToken();
      print('Token in Logout: $token');
      if (token == null) {
        throw Exception('No token available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/users/logout'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Logout successful, remove token and userObject from shared preferences
        await deleteToken();
        await deleteUser();
        print('Logout successful');
        return true;
      } else {
        final responseBody = json.decode(response.body);
        String errorMessage =
            responseBody['error'] ?? 'An unknown error occurred';
        print('Logout failed: $errorMessage');
        return false;
      }
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  // Get User Data
  static Future<Map<String, dynamic>?> getMe() async {
    try {
      final token = await getToken();
      final userObj = await getUser();
      if (token == null) {
        throw Exception('No token available');
      }
      if (userObj == null) {
        throw Exception('No user Found');
      }

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
        String errorMessage =
            responseBody['error'] ?? 'An unknown error occurred';
        print('Failed to get user data: $errorMessage');
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}
