import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/goal_widget.dart'; // Ensure the import path is correct
import '../widgets/savings_widget.dart';
import '../widgets/modules_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'Profile':
                  Navigator.pushNamed(context, '/me');
                  break;
                case 'Start Assessment':
                  Navigator.pushNamed(context, '/assessment');
                  break;
                case 'Logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Profile', 'Start Assessment', 'Logout'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $_displayName!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 255,
                            child:
                                GoalsCard(), // Ensure GoalsCard is properly implemented
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: SizedBox(
                            height: 255,
                            child: SavingsWidget(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const ModuleWidget(),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _logout() async {
    final success = await UserService.logout();
    print('Logout Success: $success');
    if (success) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
