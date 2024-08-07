import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set a background color if needed
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            const Spacer(flex: 2), // Add spacer at the top
            SizedBox(
              // To see the difference between the image's original size and the frame
              height: 100,
              width: 100,
              child: Image.asset(
                'assets/images/Group2.png', // Use SvgPicture.asset for SVG files
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
                height: 100), // Adjust the space between the image and text
            const Text(
              'Achieve your Goals',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2259AB),
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(
                height: 10), // Adjust the space between the two texts
            Container(
              child: const Text(
                'Set your saving goals and watch AI do its magic.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            const Spacer(flex: 3), // Add spacer at the bottom
          ],
        ),
      ),
    );
  }
}
