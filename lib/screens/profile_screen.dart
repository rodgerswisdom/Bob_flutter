import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _userData = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final token = await UserService.getToken();
    if (token != null) {
      final userData = await UserService.getUser();
      if (userData != null) {
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      }
    }
  }

  void _showUpdateDialog(String field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newValue = _userData[field] ?? '';

        return AlertDialog(
          title: Text('Update $field'),
          content: TextField(
            onChanged: (value) {
              newValue = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter new $field',
              labelText: field,
            ),
            controller: TextEditingController(text: _userData[field]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                setState(() {
                  _userData[field] = newValue.isEmpty ? 'Not Set' : newValue;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(action),
          content: Text('Are you sure you want to $action?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                if (action == 'Logout') {
                  final success = await UserService.logout();
                  if (success) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                } else if (action == 'Delete Account') {
                  // Handle account deletion logic here
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const language = 'English'; // Default value for language
    const theme = 'Light'; // Default value for theme

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(_userData['email'] ?? 'Not Set'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showUpdateDialog('email'),
                    ),
                  ),
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(_userData['displayName'] ?? 'Not Set'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showUpdateDialog('displayName'),
                    ),
                  ),
                  ListTile(
                    title: const Text('Phone Number'),
                    subtitle: Text(_userData['phoneNumber'] ?? 'Not Set'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showUpdateDialog('phoneNumber'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Preferences',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: const Text('Language'),
                    subtitle: const Text(language),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle language change here if needed
                    },
                  ),
                  ListTile(
                    title: const Text('Theme'),
                    subtitle: const Text(theme),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle theme change here if needed
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Assessments',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: const Text('Questions'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle viewing questions here if needed
                    },
                  ),
                  ListTile(
                    title: const Text('Your Answers'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle viewing answers here if needed
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    textColor: Colors.red,
                    onTap: () => _showConfirmationDialog('Logout'),
                  ),
                  ListTile(
                    title: const Text('Delete Account'),
                    textColor: Colors.red,
                    onTap: () => _showConfirmationDialog('Delete Account'),
                  ),
                ],
              ),
            ),
    );
  }
}
