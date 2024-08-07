import 'package:flutter/material.dart';
import '../services/goal_service.dart'; // Make sure this path is correct

class GoalWidget extends StatefulWidget {
  const GoalWidget({super.key});

  @override
  State<GoalWidget> createState() => _GoalWidgetState();

  
}

class _GoalWidgetState extends State<GoalWidget> {
  // State variables to hold goals and loading status
  late Future<Map<String, dynamic>> _goalsFuture;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch goals when the widget is created
    _goalsFuture = _fetchGoals();
  }

  Future<Map<String, dynamic>> _fetchGoals() async {
    try {
      final goals = await GoalService.fetchGoals();
      setState(() {
        _isLoading = false;
        _error = '';
      });
      return goals;
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load goals: $e';
      });
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : FutureBuilder<Map<String, dynamic>>(
                  future: _goalsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No goals available'));
                    } else {
                      final goals = snapshot.data!;
                      return ListView.builder(
                        itemCount: goals.length,
                        itemBuilder: (context, index) {
                          final goal = goals.entries.elementAt(index);
                          return ListTile(
                            title: Text(goal.key),
                            subtitle: Text(goal.value),
                          );
                        },
                      );
                    }
                  },
                ),
    );
  }
}
