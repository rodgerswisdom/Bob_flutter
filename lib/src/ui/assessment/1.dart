import 'package:flutter/material.dart';

class AssessmentScreen extends StatefulWidget {
  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  String _selectedIncomeSource;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40), // Adjust the height to your needs
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
              'What\'s your primary source of income?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildChoiceButton('Employment'),
                _buildChoiceButton('Self employed'),
                _buildChoiceButton('Investment'),
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
                child: Text('Next'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
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
    return ChoiceChip(
      label: Text(title),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedIncomeSource = selected ? title : null;
        });
      },
      selectedColor: Colors.blue,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.blue),
      ),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.blue,
        fontSize: 16,
      ),
    );
  }
}
