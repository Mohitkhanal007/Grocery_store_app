import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:grocerystore/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:grocerystore/features/order/presentation/view/checkout_view.dart';
import 'package:grocerystore/features/order/presentation/viewmodel/order_viewmodel.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_entity.dart';

class CartView extends StatefulWidget {
  final VoidCallback? onShopNowPressed;

  const CartView({super.key, this.onShopNowPressed});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    context.read<CartViewModel>().add(LoadCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartViewModel, CartState>(
      listener: (context, state) {
        if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is CartLoaded) {
          print(
            '🛒 CartView: Cart updated with ${state.cart.items.length} items',
          );
          for (var item in state.cart.items) {
            print(
              '🛒 CartView: Item - ${item.product.team} (${item.selectedSize}) - रू${item.product.price}',
            );
          }
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            // Custom header with clear cart button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shopping Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BlocBuilder<CartViewModel, CartState>(
                    builder: (context, state) {
                      if (state is CartLoaded && state.cart.isNotEmpty) {
                        return Row(
                          children: [
                            IconButton(
                              onPressed: () => _showClearCartDialog(context),
                              icon: const Icon(
                                Icons.delete_sweep,
                                color: Colors.white,
                              ),
                              tooltip: 'Clear Cart',
                            ),
                            IconButton(
                              onPressed: () => _showRefreshCartDialog(context),
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              tooltip: 'Refresh Cart',
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            // Cart content
            Expanded(
              child: BlocBuilder<CartViewModel, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CartLoaded) {
                    if (state.cart.isEmpty) {
                      return _buildEmptyCart();
                    }
                    return _buildCartContent(state.cart);
                  } else if (state is CartError) {
                    return _buildErrorState(state.message);
                  }
                  return const Center(child: Text('No cart data'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some groceries to get started!',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Use callback if provided, otherwise fallback to pop
              if (widget.onShopNowPressed != null) {
                widget.onShopNowPressed!();
              } else {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Shop Now',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartEntity cart) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return CartItemWidget(cartItem: item);
            },
          ),
        ),
        _buildCartSummary(cart),
      ],
    );
  }

  Widget _buildCartSummary(CartEntity cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                Text(
                  'रू${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Shipping
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery:', style: TextStyle(fontSize: 16)),
                Text(
                  cart.shippingCost == 0
                      ? 'FREE'
                      : 'रू${cart.shippingCost.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: cart.shippingCost == 0 ? Colors.green : null,
                    fontWeight: cart.shippingCost == 0 ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
            if (cart.shippingCost > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Free delivery on orders above रू1000',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            const Divider(height: 24),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'रू${cart.finalTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => serviceLocator<OrderViewModel>(),
                        child: CheckoutView(cart: cart),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CartViewModel>().add(LoadCartEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CartViewModel>().add(ClearCartEvent());
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showRefreshCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Refresh Cart'),
          content: const Text(
            'This will clear your cart and reload with updated prices. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CartViewModel>().add(ClearCartEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Cart refreshed! Add items again to see updated prices.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Refresh'),
            ),
          ],
        );
      },
    );
  }
}
