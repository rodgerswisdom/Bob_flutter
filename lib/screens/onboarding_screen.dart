import 'package:bob/screens/intro_screens/logo_screen.dart';
import 'package:bob/screens/intro_screens/onboard2_screen.dart';
import 'package:bob/screens/intro_screens/onboard3_screen.dart';
import 'package:bob/screens/intro_screens/onboard1_screen.dart';
import 'package:bob/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller to keep record of the page we are on
  final PageController _controller = PageController();

  // Keep track of the last page
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 3);
              });
              // Automatically navigate to the login screen when on the last page
              if (onLastPage) {
                Future.delayed(Duration(milliseconds: 500), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                });
              }
            },
            children: const [
              LogoScreen(),
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          // Page Indicators
          Container(
              alignment: const Alignment(0, 0.85),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: const SlideEffect(
                    dotColor: Color(0xFF91ACE5),
                    dotWidth: 4.0,
                    dotHeight: 4.0,
                    activeDotColor: Color(0xFF2259AB)),
              )),
        ],
      ),
    );
  }
}
