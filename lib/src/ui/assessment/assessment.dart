import 'package:flutter/material.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  String _selectedIncomeSource = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Add some space at the top
            const Text(
              'Income Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(height: 10, color: Colors.grey)),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 10, color: Colors.grey)),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 10, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'What is your primary source of Income?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                _buildChoiceButton('Employment'),
                _buildChoiceButton('Self Employed'),
                _buildChoiceButton('Investments'),
                _buildChoiceButton('Other'),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle next button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceButton(String title) {
    final bool isSelected = _selectedIncomeSource == title;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _selectedIncomeSource = title;
          });
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.blue, backgroundColor: isSelected ? Colors.blue : Colors.white,
          side: const BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
