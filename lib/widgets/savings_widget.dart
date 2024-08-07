import 'package:flutter/material.dart';

class SavingsWidget extends StatefulWidget {
  const SavingsWidget({super.key});

  @override
  State<SavingsWidget> createState() => _SavingsWidgetState();
}

class _SavingsWidgetState extends State<SavingsWidget> {
  double _savings = 0.0;
  final TextEditingController _amountController = TextEditingController();

  void _updateSavings() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount > 0) {
      setState(() {
        _savings += amount;
        _amountController.clear(); // Clear the input field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Savings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Center(
              child: Text(
                'Total: \$${_savings.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _updateSavings();
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateSavings,
              child: const Text('Update Savings'),
            ),
          ],
        ),
      ),
    );
  }
}
