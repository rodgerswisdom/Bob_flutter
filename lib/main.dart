import 'package:bob/src/ui/assessment/assessment.dart';
import 'package:bob/src/ui/splash/launchscreen.dart';
import 'package:flutter/material.dart';


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
      '/g': (context) => const SplashScreen(),
      '/': (context) => const AssessmentScreen(),
     },
    );
  }
}
