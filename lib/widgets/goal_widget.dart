import 'dart:async';
import 'package:flutter/material.dart';
import '../services/goal_service.dart';
import './progress_bar.dart';
import '../screens/goals_screen.dart'; // Import GoalsScreen

class GoalsCard extends StatefulWidget {
  const GoalsCard({super.key});

  @override
  State<GoalsCard> createState() => _GoalsCardState();
}

class _GoalsCardState extends State<GoalsCard> {
  int _achieved = 0;
  int _notAchieved = 0;
  int _total = 0;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadGoalStatistics();
  }

  Future<void> _loadGoalStatistics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await GoalService.fetchGoalStatistics();
      setState(() {
        _achieved = stats['achieved'] ?? 0;
        _notAchieved = stats['notAchieved'] ?? 0;
        _total = stats['total'] ?? 0;
        _hasError = false;
      });
    } catch (e) {
      print('Error loading goal statistics: $e');
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddGoalDialog() async {
    String title = '';
    String description = '';
    DateTime dueDate = DateTime.now();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  description = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Due Date (YYYY-MM-DD)',
                ),
                onChanged: (value) {
                  try {
                    dueDate = DateTime.parse(value);
                  } catch (_) {
                    // Handle invalid date format
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async {
                if (title.isNotEmpty && description.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  // Implement goal submission logic here
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _total > 0 ? _achieved / _total : 0.0;

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Goals Progress',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (_hasError)
                const Center(
                  child: Text('Failed to load goal statistics'),
                )
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProgressBar(
                      progress: progress,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Text(
                        'Achieved: $_achieved / $_total goals',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoalsScreen(),
                          ),
                        );
                      },
                      child: const Text('View Goals'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
