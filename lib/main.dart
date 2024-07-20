import 'package:bob/src/ui/assessment/assessment.dart';
import 'package:bob/src/ui/splash/launchscreen.dart';
import 'package:flutter/material.dart';
import 'src/ui/splash/launchscreen.dart;
import 'src/ui/assessment/assessment.dart;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BoB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     initialRoute: '/',
     routes: {
      '/': (context) => const SplashScreen(),
      '/home': (context) => const AssessmentScreen(),
     },
    );
  }
}
