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
      return refineSavingsData(data);
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

  static Future<void> withdrawSavings(double amount) async {
    final token = await UserService.getToken();
    if (token == null) {
      throw Exception('Token is Null');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/savings/remove'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to withdraw Savings');
    }
  }

  static Map<String, dynamic> refineSavingsData(Map<String, dynamic> data) {
    final Map<String, dynamic> savingsData = data['data']['savings'] ?? {};
    final List<Map<String, dynamic>> savingsList = savingsData.entries.map((entry) {
      final item = entry.value;
      final transactionType = item['transactionType'];
      final amount = item['savings'] is Map<String, dynamic>
          ? item['savings']['amount']
          : item['savings'];
      final date = DateTime.fromMillisecondsSinceEpoch(item['setDate']['_seconds'] * 1000);

      return {
        'transactionType': transactionType,
        'amount': amount.toDouble(),
        'date': date,
      };
    }).toList();

    final double total = savingsList.fold(0.0, (sum, item) {
      final amount = item['amount'] ?? 0.0;
      return sum + amount;
    });

    return {
      'savings': savingsList,
      'total': total,
    };
  }
}
