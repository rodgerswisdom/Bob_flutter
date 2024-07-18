import 'package:flutter/material.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({Key? key}) : super(key: key);

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
            SizedBox(height: 40), // Add some space at the top
            Text(
              'Income Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(height: 10, color: Colors.grey)),
                SizedBox(width: 8),
                Expanded(child: Container(height: 10, color: Colors.grey)),
                SizedBox(width: 8),
                Expanded(child: Container(height: 10, color: Colors.grey)),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'What is your primary source of Income?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                _buildChoiceButton('Employment'),
                _buildChoiceButton('Self Employed'),
                _buildChoiceButton('Investments'),
                _buildChoiceButton('Other'),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle next button press
                },
                child: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
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
        child: Text(title),
        style: OutlinedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.blue, backgroundColor: isSelected ? Colors.blue : Colors.white,
          side: BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
