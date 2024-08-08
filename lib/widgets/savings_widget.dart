import 'package:flutter/material.dart';
import '../services/savings_service.dart';

class SavingsWidget extends StatefulWidget {
  const SavingsWidget({super.key});

  @override
  State<SavingsWidget> createState() => _SavingsWidgetState();
}

class _SavingsWidgetState extends State<SavingsWidget> {
  double _savings = 0.0;
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadSavings();
  }

  Future<void> _loadSavings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final savingsData = await SavingsService.fetchSavings();
      setState(() {
        _savings = savingsData['total'] ?? 0.0;
        _isSuccess = false;
      });
    } catch (e) {
      // Handle error
      print('Error loading savings: $e');
      setState(() {
        _isSuccess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitSavings() async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (amount > 0) {
      setState(() {
        _isLoading = true;
      });

      try {
        await SavingsService.submitSavings({'amount': amount});
        setState(() {
          _savings += amount;
          _isSuccess = true;
          _amountController.clear();
        });
      } catch (e) {
        // Handle error
        print('Error submitting savings: $e');
        setState(() {
          _isSuccess = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (_isSuccess)
              Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
              )
            else
              Column(
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter amount',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _submitSavings();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitSavings,
                    child: const Text('Update Savings'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
