import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/goal_widget.dart'; // Ensure the import path is correct
import '../widgets/savings_widget.dart';
import '../widgets/modules_widget.dart';

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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 240,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: const Color(0xFF2259AB), // Original AppBar color
        centerTitle: true, // Center the title content
        title: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(
                255, 71, 124, 203), // User info box color with 50% opacity
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300], // Placeholder avatar color
                child: const Icon(Icons.person, color: Colors.white),
                radius: 30, // Avatar size
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    _displayName,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
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
                    SizedBox(height: 20),
                    ModuleWidget(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Assessment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0, // Update this index based on the selected screen
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle navigation based on the selected index
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/getassesment');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/me');
              break;
          }
        },
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
