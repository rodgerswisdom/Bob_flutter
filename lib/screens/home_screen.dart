// ignore_for_file: use_build_context_synchronously

// import 'package:bob/widgets/goal_widget.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final userData = await UserService.getMe();

      setState(() {
        if (userData != null) {
          _displayName = userData['displayName'] ?? 'User';
        } else {
          _displayName = 'User';
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _displayName = 'User';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Home')),
      body: _isLoading
          ?const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $_displayName!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // const GoalWidget(

                  // ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/assessment');
                    },
                    child: const Text('Start Assessment'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to profile or settings screen
                      Navigator.pushNamed(context, '/me'); // Assume a profile route exists
                    },
                    child: const Text('Profile'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('token');
                      if (token != null) {
                        final success = await UserService.logout();
                        if (success) {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      }
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }
}
