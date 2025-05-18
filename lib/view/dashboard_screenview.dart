import 'package:flutter/material.dart';

class DashboardScreenview extends StatelessWidget {
  const DashboardScreenview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Container(
          child: Text("Welcome To Dashboard"),
        ),
      ),
    );
  }
}