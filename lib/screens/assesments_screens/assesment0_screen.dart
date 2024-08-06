import 'package:flutter/material.dart';

class FinancialAssessmentOnboardingScreen extends StatelessWidget {
  const FinancialAssessmentOnboardingScreen({super.key});

  void _navigateToNextScreen(BuildContext context) {
    Navigator.pushNamed(
        context, '/getassesment'); // Replace with your route name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2259AB), // Your desired app bar color
        title: const Text('Financial Assessment'), // App bar title
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Assessment',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'One-time financial assessment required for personalized guidance. This quick assessment ensures a tailored experience for you.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _navigateToNextScreen(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2259AB), // Button color
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0), // Button height
              textStyle: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            child: const Text('Let\'s Get Started'),
          ),
        ),
      ),
    );
  }
}
