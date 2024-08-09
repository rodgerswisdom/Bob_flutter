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
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black),
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
                  'Gemini AI', // Removed icon
                  style: Theme.of(context).textTheme.titleLarge,
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
              ],
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color: _isHelpful ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  final newHelpfulStatus = !_isHelpful;
                  _updateHelpfulStatus(newHelpfulStatus);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
