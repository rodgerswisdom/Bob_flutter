import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set a background color if needed
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Colors
                  .indigo, // To see the difference between the image's original size and the frame
              height: 300,
              width: 300,
              child: Image.asset(
                'assets/images/Group1.jpg', // Use SvgPicture.asset for SVG files
                fit: BoxFit.cover,
              ),
            ),
            const Text(
              'Personalized Saving Insights',
              style: TextStyle(
                color: Color(0xFF2259AB),
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const Text(
              'Discover personalized saving insights tailored just for you.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}
