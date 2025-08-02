import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/cart_provider.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const CartScreen({super.key, this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final items = cartProvider.items;
        final total = cartProvider.total;
        final itemCount = cartProvider.itemCount;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Shopping Cart'),
            actions: [
              if (items.isNotEmpty)
                TextButton(
                  onPressed: () => cartProvider.clearCart(),
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          body:
              items.isEmpty
                  ? _buildEmptyCart(context)
                  : _buildCartList(context, items),
          bottomNavigationBar:
              items.isEmpty ? null : _buildCheckoutBar(context, total),
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some products to get started!',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (onStartShopping != null) {
                onStartShopping!();
              } else {
                // Fallback: navigate to dashboard
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
            },
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(BuildContext context, List<CartItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      (item.product.image?.startsWith('http') ?? false)
                          ? CachedNetworkImage(
                            imageUrl: item.product.image!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.error),
                                ),
                          )
                          : Image.asset(
                            item.product.image ??
                                'assets/images/placeholder.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                ),
                const SizedBox(width: 12),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${item.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantity Controls
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            final cartProvider = context.read<CartProvider>();
                            cartProvider.updateQuantity(
                              item.product.id,
                              item.quantity - 1,
                            );
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          iconSize: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.quantity.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final cartProvider = context.read<CartProvider>();
                            cartProvider.updateQuantity(
                              item.product.id,
                              item.quantity + 1,
                            );
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          iconSize: 20,
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        final cartProvider = context.read<CartProvider>();
                        cartProvider.removeItem(item.product.id);
                      },
                      child: const Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckoutBar(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _checkout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkout(BuildContext context) {
    // TODO: Implement checkout functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Order placed successfully! Thank you for your purchase.',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
