// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import '../services/goal_service.dart';

class GoalsCard extends StatefulWidget {
  const GoalsCard({super.key});

  @override
  State<GoalsCard> createState() => _GoalsCardState();
}

class _GoalsCardState extends State<GoalsCard> {
  late Future<List<Goal>> _goalsFuture;

  @override
  void initState() {
    super.initState();
    _goalsFuture = GoalService.fetchGoals(); // Fetch goals when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 195,
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: FutureBuilder<List<Goal>>(
          future: _goalsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No goals found.'));
            } else {
              final goals = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ' Goals',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...goals.map((goal) => GoalItem(
                    title: goal.title,
                    description: goal.description,
                    dueDate: goal.dueDate,
                  )).toList(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class GoalItem extends StatelessWidget {
  final String title;
  final String description;
  final String dueDate;

  const GoalItem({
    super.key,
    required this.title,
    required this.description,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4.0),
          Text(description),
          const SizedBox(height: 4.0),
          Text('Due Date: $dueDate', style: Theme.of(context).textTheme.bodySmall),
          const Divider(),
        ],
      ),
    );
  }
}
