import 'dart:convert';
import 'package:http/http.dart' as http;
import './user_service.dart';

class SavingsService {
  static const String baseUrl = 'https://bob-server.vercel.app';

  static Future<Map<String, dynamic>> fetchSavings() async {
    final token = await UserService.getToken();
    if (token == null) {
      throw Exception('Token is Null');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/savings'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Savings Data: $data');

      final Map<String, dynamic> savingsData = data['data']['savings'] ?? {};
      final List savingsList = savingsData.values.map((e) {
        return e['savings'] is Map<String, dynamic> ? e['savings'] : {'amount': e['savings']};
      }).toList();

      final double total = savingsList.fold(0.0, (sum, item) {
        final amount = item['amount'] ?? 0.0;
        return sum + (amount is num ? amount.toDouble() : 0.0);
      });

      return {
        'savings': savingsList,
        'total': total,
      };
    } else {
      throw Exception('Failed to load Savings');
    }
  }

  static Future<Map<String, dynamic>> fetchSingleSavings(String savingsId) async {
    final token = await UserService.getToken();
    if (token == null) {
      throw Exception('Token is Null');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/savings/$savingsId'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['Savings'];
    } else {
      throw Exception('Failed to load Savings');
    }
  }

  static Future<void> submitSavings(Map<String, dynamic> savings) async {
    final data = {'savings': savings};
    final token = await UserService.getToken();

    if (token == null) {
      throw Exception('Token is null. Unable to submit savings.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/savings'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to submit Savings');
    }
  }
}
