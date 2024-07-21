// TODO Implement this library.

import 'package:flutter/material.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
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
    final userId = await UserService.getUserId();
    // Replace this with actual call to get user info
    // For demonstration purposes, let's assume display name is fetched from shared preferences
    setState(() {
      _displayName = userId ?? 'User';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $_displayName!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/assessment');
                    },
                    child: Text('Start Assessment'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to profile or settings screen
                      Navigator.pushNamed(context, '/profile'); // Assume a profile route exists
                    },
                    child: Text('Profile'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Logout action
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }
}
