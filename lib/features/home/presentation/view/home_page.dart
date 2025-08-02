import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/app/service_locator/service_locator.dart';
import 'package:jerseyhub/app/shared_prefs/user_shared_prefs.dart';
import 'package:jerseyhub/features/cart/presentation/view/cart_view.dart';
import 'package:jerseyhub/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:jerseyhub/features/order/presentation/view/order_list_view.dart';
import 'package:jerseyhub/features/order/presentation/viewmodel/order_viewmodel.dart';
import 'package:jerseyhub/features/product/presentation/view/product_list_view.dart';
import 'package:jerseyhub/features/product/presentation/viewmodel/product_viewmodel.dart';
import 'package:jerseyhub/features/profile/presentation/view/profile_view.dart';
import 'package:jerseyhub/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:jerseyhub/features/notification/presentation/view/notification_list_view.dart';
import 'package:jerseyhub/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:jerseyhub/features/notification/presentation/widgets/notification_badge.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final CartViewModel _cartViewModel;

  final List<String> _titles = ['', '', '', '', 'Profile'];

  @override
  void initState() {
    super.initState();
    _cartViewModel = serviceLocator<CartViewModel>();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Refresh cart when cart tab is selected
    if (index == 1) {
      _cartViewModel.add(LoadCartEvent());
    }

    // Connect to notification socket when notifications tab is selected
    if (index == 3) {
      final userSharedPrefs = serviceLocator<UserSharedPrefs>();
      final userId = userSharedPrefs.getCurrentUserId() ?? 'unknown_user';
      final notificationBloc = serviceLocator<NotificationBloc>();
      notificationBloc.add(ConnectToSocket(userId));
      notificationBloc.add(LoadNotifications(userId));
    }
  }

  Widget _buildProfilePage() {
    final userSharedPrefs = serviceLocator<UserSharedPrefs>();
    final userId = userSharedPrefs.getCurrentUserId() ?? 'unknown_user';

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
        child: const ProductListView(),
      ),
      BlocProvider.value(value: _cartViewModel, child: const CartView()),
      BlocProvider(
        create: (context) => serviceLocator<OrderViewModel>(),
        child: const OrderListView(),
      ),
      BlocProvider.value(
        value: notificationBloc,
        child: const NotificationListView(),
      ),
      _buildProfilePage(),
    ];

    return BlocProvider.value(
      value: notificationBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedIndex]),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications),
                  BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      if (state is NotificationsLoaded &&
                          state.unreadCount > 0) {
                        return Positioned(
                          right: -8,
                          top: -8,
                          child: NotificationBadge(
                            count: state.unreadCount,
                            size: 16,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              label: 'Notifications',
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
