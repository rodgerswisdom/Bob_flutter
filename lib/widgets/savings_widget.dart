import 'dart:async';
import 'package:flutter/material.dart';
import '../services/savings_service.dart';

class SavingsWidget extends StatefulWidget {
  const SavingsWidget({super.key});

  @override
  State<SavingsWidget> createState() => _SavingsWidgetState();
}

class _SavingsWidgetState extends State<SavingsWidget> {
  double _savings = 0.0;
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

  Future<void> _showAddSavingsDialog() async {
    double amount = 0.0;
    final TextEditingController amountController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Savings'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter amount',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              amount = double.tryParse(value) ?? 0.0;
            },
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
                if (amount > 0) {
                  Navigator.of(context).pop(); // Close the dialog
                  await _submitSavings(amount);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitSavings(double amount) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await SavingsService.submitSavings({'amount': amount});
      setState(() {
        _savings += amount;
        _isSuccess = true;
      });

      // Remove success icon after 2 seconds
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isSuccess = false;
          });
        }
      });
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
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
                'Savings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Ksh${_savings.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 16.0),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (_isSuccess)
                const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 40,
                  ),
                )
              else
                Column(
                  children: [
                    ElevatedButton(
  onPressed: _showAddSavingsDialog,
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Sets the button's text color to white
  ),
  child: const Text('Save'),
)

                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
