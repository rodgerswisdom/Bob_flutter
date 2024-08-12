import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/modules_service.dart';

class ModuleWidget extends StatefulWidget {
  const ModuleWidget({super.key});

  @override
  State<ModuleWidget> createState() => _ModuleWidgetState();
}

class _ModuleWidgetState extends State<ModuleWidget> {
  bool _isHelpful = false;
  bool _isLoading = false;
  bool _hasError = false;
  String _moduleText = '';

  @override
  void initState() {
    super.initState();
    _loadModule();
  }

  Future<void> _loadModule() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final moduleData = await ModulesService.fetchSingleModule();
      setState(() {
        _moduleText = moduleData['advice'] ?? 'No module content available';
        _isHelpful = moduleData['helpful'] ?? false;
      });

      // Cache the module data for updating the helpful status later
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cachedModule', jsonEncode(moduleData));
    } catch (e) {
      print('Error loading module: $e');
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateHelpfulStatus(bool helpful) async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final cachedModule = prefs.getString('cachedModule');

    if (cachedModule != null) {
      final cachedModuleJson = jsonDecode(cachedModule);

      try {
        await ModulesService.updateHelpfulField(cachedModuleJson['id'], helpful);
        setState(() {
          _isHelpful = helpful;
        });
      } catch (e) {
        print('Error updating module status: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('No modules available');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Module',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 8.0),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _hasError
                        ? const Center(
                            child: Text(
                              'Error loading module.',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : Text(
                            _moduleText,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                const SizedBox(height: 16.0),
                const SizedBox(height: 16.0),
              ],
            ),
            Positioned(
              bottom: 4.0,
              right: 16.0,
              child: Image.asset(
                'assets/images/google-gemini-icon.png',
                height: 50,
                width: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
