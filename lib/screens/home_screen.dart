// ignore_for_file: use_build_context_synchronously

// import 'package:bob/widgets/goal_widget.dart';
import 'package:bob/widgets/goal_widget.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/savings_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _displayName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await UserService.getUser();

    if (userData == null) {
      // Redirect to login if user data is not available
      Navigator.pushNamed(context, '/login');
      return;
    }

    setState(() {
      _displayName = userData['displayName'] ?? 'User';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $_displayName!',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const GoalsCard(),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, '/assessment');
                  //   },
                  //   child: const Text('Start Assessment'),
                  // ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/me'); // Navigate to profile
                    },
                    child: const Text('Profile'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final success = await UserService.logout();
                      print('Logout Success: $success');
                      if (success) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    child: const Text('Logout'),
                  ),
                  const SizedBox(height: 20), // Add spacing before SavingsWidget
                  const SavingsWidget(), // Display SavingsWidget
                ],
              ),
            ),
    );
  }
}
