import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/app/shared_prefs/user_shared_prefs.dart';
import 'package:grocerystore/features/cart/presentation/view/cart_view.dart';
import 'package:grocerystore/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:grocerystore/features/order/presentation/view/order_list_view.dart';
import 'package:grocerystore/features/order/presentation/viewmodel/order_viewmodel.dart';
import 'package:grocerystore/features/product/presentation/view/product_list_view.dart';
import 'package:grocerystore/features/product/presentation/viewmodel/product_viewmodel.dart';
import 'package:grocerystore/features/profile/presentation/view/profile_view.dart';
import 'package:grocerystore/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:grocerystore/features/notification/presentation/view/notification_list_view.dart';
import 'package:grocerystore/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:grocerystore/core/theme/theme_manager.dart';
import 'package:grocerystore/features/auth/presentation/view/login_view.dart';
import 'package:grocerystore/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final CartViewModel _cartViewModel;
  late final ThemeManager _themeManager;

  final List<String> _titles = ['GroceryStore', 'Cart', 'Orders', 'Profile'];

  @override
  void initState() {
    super.initState();
    _cartViewModel = serviceLocator<CartViewModel>();
    _themeManager = ThemeManager();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildProfilePage() {
    final userSharedPrefs = serviceLocator<UserSharedPrefs>();
    final userId = userSharedPrefs.getCurrentUserId();

    print('🔍 HomePage: Building profile page with user ID: $userId');

    if (userId == null || userId.isEmpty || userId == 'unknown_user') {
      print('❌ HomePage: No valid user ID found, showing login prompt');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Please log in to view your profile',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => serviceLocator<LoginViewModel>(),
                      child: const LoginView(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      );
    }

    print('✅ HomePage: Valid user ID found, building profile view');
    return BlocProvider(
      create: (context) => serviceLocator<ProfileViewModel>(),
      child: ProfileView(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationBloc = serviceLocator<NotificationBloc>();

    final List<Widget> pages = [
      BlocProvider(
        create: (context) => serviceLocator<ProductViewModel>(),
        child: ProductListView(
          onNavigateToCart: () {
            setState(() {
              _selectedIndex = 1; // Switch to cart tab
            });
          },
        ),
      ),
      BlocProvider.value(
        value: _cartViewModel,
        child: CartView(
          onShopNowPressed: () {
            setState(() {
              _selectedIndex = 0; // Switch to home/products tab
            });
          },
        ),
      ),
      BlocProvider(
        create: (context) => serviceLocator<OrderViewModel>(),
        child: OrderListView(
          onShopNowPressed: () {
            setState(() {
              _selectedIndex = 0; // Switch to home/products tab
            });
          },
        ),
      ),
      _buildProfilePage(),
    ];

    return BlocProvider.value(
      value: notificationBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedIndex]),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            // Theme indicator in app bar
            ListenableBuilder(
              listenable: _themeManager,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Icon(
                    _themeManager.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
        body: pages[_selectedIndex],
        floatingActionButton: null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Store',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Orders',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
