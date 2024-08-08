import 'package:flutter/material.dart';

class GoalsCard extends StatelessWidget {
  const GoalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'User Goals',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const GoalItem(
              title: 'Save for Emergency Fund',
              description: 'Build an emergency fund of 1000',
              dueDate: '2024-12-31',
            ),
            const GoalItem(
              title: 'Pay off Credit Card Debt',
              description: 'Pay off 500 credit card debt',
              dueDate: '2024-11-30',
            ),
            const GoalItem(
              title: 'Increase Savings Rate',
              description: 'Increase savings rate to 20%',
              dueDate: '2024-10-31',
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implement editing functionality here
                  showDialog(
                    context: context,
                    builder: (context) => const EditGoalsDialog(),
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
  final String title;
  final String description;
  final String dueDate;

  const GoalItem({super.key, 
    required this.title,
    required this.description,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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

class EditGoalsDialog extends StatelessWidget {
  const EditGoalsDialog({super.key});

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
