import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/savings_service.dart';
import 'package:intl/intl.dart'; // Ensure you have this package in your pubspec.yaml

class SavingsScreen extends StatefulWidget {
  @override
  _SavingsScreenState createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  late Future<Map<String, dynamic>> _savingsFuture;
  double _totalSavings = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSavings();
  }

  void _loadSavings() {
    setState(() {
      _savingsFuture = SavingsService.fetchSavings();
    });
  }

  void _showDialog(BuildContext context, String action) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$action Savings'),
          content: TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: 'Amount (KSh)'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null) {
                  if (action == 'Add') {
                    SavingsService.submitSavings({'amount': amount}).then((_) {
                      Fluttertoast.showToast(msg: 'Savings Added');
                      _loadSavings();
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      Fluttertoast.showToast(msg: 'Failed to Add Savings');
                      print('Error: $error');
                    });
                  } else if (action == 'Withdraw') {
                    SavingsService.withdrawSavings(amount).then((_) {
                      Fluttertoast.showToast(msg: 'Savings Withdrawn');
                      _loadSavings();
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      Fluttertoast.showToast(msg: 'Failed to Withdraw Savings');
                      print('Error: $error');
                    });
                  }
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Savings')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _savingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!['savings'].isEmpty) {
            return Center(child: Text('No Savings Data Available'));
          } else {
            final savingsList = snapshot.data!['savings'] as List<dynamic>;
            _totalSavings = snapshot.data!['total'];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.2),
                      //     spreadRadius: 2,
                      //     blurRadius: 5,
                      //     offset: const Offset(0, 3),
                      //   ),
                      // ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Total\n KSh ${_totalSavings.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                            height:
                                16.0), // Space between total savings and buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => _showDialog(context, 'Add'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green,
                                ),
                                child: Text('Add Savings'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    _showDialog(context, 'Withdraw'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                ),
                                child: Text('Withdraw Savings'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: savingsList.length,
                    itemBuilder: (context, index) {
                      final item = savingsList[index];
                      final isWithdrawal = item['transactionType'] == 'out';
                      final iconColor =
                          isWithdrawal ? Colors.red : Colors.green;
                      final icon = isWithdrawal
                          ? Icons.arrow_upward
                          : Icons.arrow_downward;

                      // Handle 'date' properly as DateTime
                      final date = item['date'];
                      String formattedDate;
                      if (date is DateTime) {
                        formattedDate =
                            DateFormat('yyyy-MM-dd').format(date.toLocal());
                      } else if (date is String) {
                        formattedDate = DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(date).toLocal());
                      } else {
                        formattedDate = 'N/A';
                      }

                      return ListTile(
                        leading: Icon(
                          icon,
                          color: iconColor,
                        ),
                        title: Text(
                          'KSh ${item['amount'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: iconColor,
                          ),
                        ),
                        subtitle: Text('Date: $formattedDate'),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 1, // Update this index based on the selected screen
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle navigation based on the selected index
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/savings');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/goals');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/me');
              break;
          }
        },
      ),
    );
  }
}
