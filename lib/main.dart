import 'package:bob/screens/assesments_screens/assesment0_screen.dart';
import 'package:bob/screens/assesments_screens/assessment_screen.dart';
import 'package:bob/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/answers_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BoB Financial Literacy App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Nunito',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Nunito'),
          bodyMedium: TextStyle(fontFamily: 'Nunito'),
          displayLarge: TextStyle(fontFamily: 'Nunito'),
          displayMedium: TextStyle(fontFamily: 'Nunito'),
          displaySmall: TextStyle(fontFamily: 'Nunito'),
          headlineMedium: TextStyle(fontFamily: 'Nunito'),
          headlineSmall: TextStyle(fontFamily: 'Nunito'),
          titleLarge: TextStyle(fontFamily: 'Nunito'),
          titleMedium: TextStyle(fontFamily: 'Nunito'),
          titleSmall: TextStyle(fontFamily: 'Nunito'),
          bodySmall: TextStyle(fontFamily: 'Nunito'),
          labelLarge: TextStyle(fontFamily: 'Nunito'),
          labelSmall: TextStyle(fontFamily: 'Nunito'),
        ),
      ),
      initialRoute: '/onboard',
      routes: {
        '/onboard': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/me': (context) => const ProfileScreen(),
        '/assessment': (context) => const FinancialAssessmentOnboardingScreen(),
        '/getassesment': (context) => const AssessmentScreen(),
        '/goals': (context) => GoalsScreen(),
        '/answers': (context) => AnswersScreen(),
      },
    );
  }
}
