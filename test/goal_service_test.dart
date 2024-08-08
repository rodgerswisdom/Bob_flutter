import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
// ignore: unused_import
import 'package:bob/models/goal_model.dart';
import 'package:bob/services/goal_service.dart';

// Mock class for http.Client
class MockClient extends Mock implements http.Client {}

// Stub UserService.getToken method
class MockUserService {
  Future<String?> getToken() async {
    return 'dummy-token'; // Adjust as needed
  }
}

void main() {
  group('GoalService', () {
    late MockClient mockClient;
    late MockUserService mockUserService;

    setUp(() {
      mockClient = MockClient();
      mockUserService = MockUserService();
      // Override the UserService.getToken method
      when(mockUserService.getToken()).thenAnswer((_) async => 'dummy-token');
      // Assuming you have a way to inject or set the mock service in GoalService
      // GoalService.setUserService(mockUserService);
    });

    test('fetchGoals returns a Goal if the HTTP call completes successfully', () async {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'title': 'Save for Emergency Fund',
        'description': 'Build an emergency fund of 1,000',
        'dueDate': '2024-12-31',
      };
      final response = http.Response(jsonEncode(jsonMap), 200);
      when(mockClient.get(
        Uri.parse('${GoalService.baseUrl}/goals'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': 'dummy-token',
        },
      )).thenAnswer((_) async => response);

      // Act
      final goal = await GoalService.fetchGoals();

      // Assert
      expect(goal.title, 'Save for Emergency Fund');
      expect(goal.description, 'Build an emergency fund of 1,000');
      expect(goal.dueDate, '2024-12-31');
    });

    test('fetchGoals throws an exception if the HTTP call fails', () async {
      // Arrange
      final response = http.Response('Not Found', 404);
      when(mockClient.get(
        Uri.parse('${GoalService.baseUrl}/goals'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': 'dummy-token',
        },
      )).thenAnswer((_) async => response);

      // Act & Assert
      expect(() async => await GoalService.fetchGoals(), throwsException);
    });

    test('fetchGoals throws an exception if there is no token', () async {
      // Arrange
      when(mockUserService.getToken()).thenAnswer((_) async => null);

      // Act & Assert
      expect(() async => await GoalService.fetchGoals(), throwsException);
    });
  });
}
