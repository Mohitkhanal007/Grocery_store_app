import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/features/order/presentation/viewmodel/order_viewmodel.dart';
import 'package:grocerystore/features/order/presentation/widgets/order_card_widget.dart';
import 'package:grocerystore/app/shared_prefs/user_shared_prefs.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/order/data/data_source/local_datasource/order_local_datasource.dart';

class OrderListView extends StatefulWidget {
  final VoidCallback? onShopNowPressed;

  const OrderListView({super.key, this.onShopNowPressed});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  late final UserSharedPrefs _userSharedPrefs;
  List<OrderEntity> _orders = [];

  @override
  void initState() {
    super.initState();
    _userSharedPrefs = serviceLocator<UserSharedPrefs>();
    _loadOrdersFromStorage();
  }

  void _loadOrdersFromStorage() async {
    final userId = _userSharedPrefs.getCurrentUserId();
    print('🔍 OrderListView: Loading orders for user ID: $userId');

    if (userId != null && userId.isNotEmpty && userId != 'unknown_user') {
      try {
        final orderViewModel = serviceLocator<OrderViewModel>();
        orderViewModel.add(LoadAllOrdersEvent(userId: userId));
      } catch (e) {
        print('❌ OrderListView: Error loading orders: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Custom header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                const Text(
                  'My Orders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Debug button to check orders
                IconButton(
                  onPressed: () async {
                    final userId = _userSharedPrefs.getCurrentUserId();
                    print('🔍 DEBUG: Checking orders for user: $userId');

                    try {
                      final localDataSource =
                          serviceLocator<OrderLocalDataSource>();
                      final orders = await localDataSource.getAllOrders(userId);
                      print(
                        '🔍 DEBUG: Found ${orders.length} orders in storage',
                      );

                      for (var order in orders) {
                        print(
                          '🔍 DEBUG: Order ID: ${order.id}, Status: ${order.status}, Total: ${order.totalAmount}',
                        );
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Found ${orders.length} orders in storage',
                          ),
                          backgroundColor: Colors.blue,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    } catch (e) {
                      print('❌ DEBUG: Error checking orders: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.bug_report, color: Colors.white),
                ),
                // Refresh button
                IconButton(
                  onPressed: () {
                    _loadOrdersFromStorage();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Orders refreshed!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
          ),
          // Orders content
          Expanded(
            child: BlocListener<OrderViewModel, OrderState>(
              listener: (context, state) {
                if (state is OrdersLoaded) {
                  print(
                    '🔍 OrderListView: Orders loaded successfully. Count: ${state.orders.length}',
                  );
                  setState(() {
                    _orders = state.orders;
                  });
                } else if (state is OrderCreated) {
                  print('🔍 OrderListView: New order created, refreshing list');
                  _loadOrdersFromStorage();
                }
              },
              child: BlocBuilder<OrderViewModel, OrderState>(
                builder: (context, state) {
                  print(
                    '🔍 OrderListView: BlocBuilder state: ${state.runtimeType}',
                  );

                  if (state is OrderLoading) {
                    print('🔍 OrderListView: Loading state');
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrdersLoaded) {
                    print(
                      '🔍 OrderListView: OrdersLoaded state with ${state.orders.length} orders',
                    );
                    if (state.orders.isEmpty) {
                      print(
                        '🔍 OrderListView: No orders in state, showing empty',
                      );
                      return _buildEmptyOrders();
                    }
                    print(
                      '🔍 OrderListView: Showing ${state.orders.length} orders',
                    );
                    return _buildOrdersList(state.orders);
                  } else if (state is OrderCreated) {
                    print('🔍 OrderListView: OrderCreated state');
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrderError) {
                    print(
                      '🔍 OrderListView: OrderError state: ${state.message}',
                    );
                    return _buildErrorState(state.message);
                  }

                  // Fallback: show current orders or empty state
                  print(
                    '🔍 OrderListView: Fallback state, current orders: ${_orders.length}',
                  );
                  if (_orders.isEmpty) {
                    return _buildEmptyOrders();
                  }
                  return _buildOrdersList(_orders);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your order history will appear here after payment',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              widget.onShopNowPressed?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Shop Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<OrderEntity> orders) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadOrdersFromStorage();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OrderCardWidget(
              order: order,
              orderViewModel: context.read<OrderViewModel>(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error Loading Orders',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color:
                  Theme.of(context).textTheme.bodyLarge?.color ??
                  Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _loadOrdersFromStorage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
