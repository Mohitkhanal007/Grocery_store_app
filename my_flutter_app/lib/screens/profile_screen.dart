import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 80, color: Colors.green),
          SizedBox(height: 16),
          Text('Mohit Khanal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('mohit@example.com'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implement logout or edit profile
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
