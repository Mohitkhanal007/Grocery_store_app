import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  Widget _dashboardUI() {
    final categories = [
      "Fruits",
      "Vegetables",
      "Dairy",
      "Bakery",
      "Meat",
      "Beverages",
    ];

    final featuredProducts = [
      {
        "name": "Apple",
        "image": "assets/images/apple.png",
        "price": "\$2.99",
      },
      {
        "name": "Milk",
        "image": "assets/images/milk.png",
        "price": "\$1.99",
      },
      {
        "name": "Bread",
        "image": "assets/images/bread.png",
        "price": "\$3.49",
      },
      {
        "name": "Orange Juice",
        "image": "assets/images/orange_juice.png",
        "price": "\$4.50",
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Chip(
                  label: Text(categories[index]),
                  backgroundColor: Colors.purple.shade100,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Featured Products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              itemCount: featuredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (context, index) {
                final product = featuredProducts[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(
                            product["image"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product["name"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          product["price"]!,
                          style: TextStyle(
                            color: Colors.purple.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  final List<Widget> _otherScreens = const [
    Center(child: Text('Your cart is empty.\nAdd items to see them here.')),
    Center(child: Text('Coming soon...')),
    Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      _dashboardUI(),
      _otherScreens[0],
      _otherScreens[1],
      _otherScreens[2],
    ];

    final List<String> _titles = [
      'Home',
      'Cart',
      'Orders',
      'Profile',
    ];

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'OpenSans',
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_currentIndex]),
          centerTitle: true,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
