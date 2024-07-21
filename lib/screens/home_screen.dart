import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final userData = await UserService.getMe(token);

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
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('token');
                      if (token != null) {
                        final success = await UserService.logout(token);
                        if (success) {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      }
                    },
                    child: Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }
}
