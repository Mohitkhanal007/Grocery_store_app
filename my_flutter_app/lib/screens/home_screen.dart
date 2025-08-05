import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Vegetables', 'icon': Icons.eco},
    {'name': 'Fruits', 'icon': Icons.apple},
    {'name': 'Dairy', 'icon': Icons.local_drink},
    {'name': 'Snacks', 'icon': Icons.fastfood},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage('assets/images/vegetables.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "Fresh Deals!",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.black45,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: categories.map((cat) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icon'], size: 40, color: Colors.green),
                      SizedBox(height: 10),
                      Text(cat['name'], style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
