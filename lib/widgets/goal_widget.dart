import 'package:flutter/material.dart';
import '../models/goal_model.dart';

class GoalsCard extends StatelessWidget {
  final List<Goal> goals;

  const GoalsCard({
    super.key,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165.0,
      height: 195.0,
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Goals',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return GoalItem(goal: goal);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditGoalsDialog(goals: goals),
                  );
                },
                child: const Text('Edit Goals'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalItem extends StatelessWidget {
  final Goal goal;

  const GoalItem({
    super.key,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal.title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4.0),
          Text(goal.description, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4.0),
          Text('Due Date: ${goal.dueDate}', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class EditGoalsDialog extends StatelessWidget {
  final List<Goal> goals;

  const EditGoalsDialog({
    super.key,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Goals'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Goal Title'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Due Date'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement save functionality here
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
