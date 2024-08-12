import 'package:flutter/material.dart';
import '../services/goal_service.dart';
import '../models/goal_model.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Goal> goals = []; // List to hold fetched goals
  String? dateErrorMessage; // Variable to hold the date format error message

  @override
  void initState() {
    super.initState();
    fetchGoals(); // Fetch goals when screen initializes
  }

  Future<void> fetchGoals() async {
    try {
      List<Goal> fetchedGoals = await GoalService.fetchGoals();
      setState(() {
        goals = fetchedGoals;
      });
    } catch (e) {
      // Handle error fetching goals
      print('Error fetching goals: $e');
    }
  }

  void _showGoalDetails(Goal goal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(goal.title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (goal.achieved)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.green[100],
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Achieved', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Text('Due Date: ${goal.dueDate}'),
              const SizedBox(height: 8),
              Text('Description: ${goal.description}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addNewGoalDialog() async {
    String title = '';
    String description = '';
    DateTime dueDate = DateTime.now();
    dateErrorMessage = null; // Reset the error message

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a New Goal'),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Due Date (YYYY-MM-DD)',
                      errorText: dateErrorMessage, // Show error message
                      filled: true,
                      fillColor: dateErrorMessage != null
                          ? Colors.red[50]
                          : Colors.transparent,
                    ),
                    onChanged: (value) {
                      try {
                        dueDate = DateTime.parse(value);
                        setState(() {
                          dateErrorMessage =
                              null; // Clear the error message if date is valid
                        });
                      } catch (_) {
                        setState(() {
                          dateErrorMessage =
                              'Follow the right date format YYYY-MM-DD';
                        });
                      }
                    },
                  ),
                  if (dateErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        dateErrorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
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
                if (title.isNotEmpty &&
                    description.isNotEmpty &&
                    dateErrorMessage == null) {
                  Navigator.of(context).pop(); // Close the dialog

                  final newGoal = Goal(
                    title: title,
                    description: description,
                    dueDate: dueDate.toIso8601String(),
                    achieved: false, // Default to false
                  );

                  try {
                    await GoalService.postGoal(newGoal);
                    fetchGoals(); // Refresh the list of goals
                  } catch (e) {
                    print('Error adding goal: $e');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleGoalAchievement(Goal goal) async {
    // Ensure that the goal has a non-null id before proceeding
    if (goal.id == null || goal.id!.isEmpty) {
      print('Error: Goal id is null or empty');
      return;
    }

    // Create a copy of the goal with updated achievement status
    final updatedGoal = Goal(
      id: goal.id, // Keep the existing id
      title: goal.title,
      description: goal.description,
      dueDate: goal.dueDate,
      achieved: !goal.achieved, // Toggle the achieved status
    );

    try {
      await GoalService.updateGoal(updatedGoal.id!,
          updatedGoal.achieved); // Send updated goal to the backend
      setState(() {
        goals = goals.map((g) => g.id == goal.id ? updatedGoal : g).toList();
      });
    } catch (e) {
      print('Error updating goal: $e');
    }
  }

  Widget _buildGoalsList() {
    if (goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Add your first goal! 🎉',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addNewGoalDialog();
              },
              child: const Text('Add a Goal'),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: goals.length,
        itemBuilder: (context, index) {
          Goal goal = goals[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Checkbox(
                value: goal.achieved,
                onChanged: (bool? value) {
                  _toggleGoalAchievement(goal);
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    goal.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold), // Bold title
                  ),
                  Text(goal.dueDate.split('T').first),
                ],
              ),
              subtitle: GestureDetector(
                onTap: () {
                  _showGoalDetails(goal);
                },
                child: Text(
                  goal.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
      ),
      body: _buildGoalsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewGoalDialog();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 2, // Update this index based on the selected screen
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle navigation based on the selected index
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/savings');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/goals');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/me');
              break;
          }
        },
      ),
    );
  }
}
