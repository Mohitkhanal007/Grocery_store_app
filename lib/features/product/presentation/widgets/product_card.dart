import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/app/shared_prefs/user_shared_prefs.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: _buildProductImage(),
              ),
            ),
            // Product Info
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Team Name
                    Text(
                      product.team,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Type and Size
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(product.type),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.type,
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            product.size,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Price
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: ElevatedButton(
                        onPressed: product.quantity > 0
                            ? () => _addToCart(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_shopping_cart, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    // Try to load from assets first, then fallback to network or placeholder
    if (product.productImage.startsWith('assets/')) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[200],
        child: Image.asset(
          product.productImage,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderImage(),
        ),
      );
    } else if (product.productImage.isNotEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[200],
        child: Image.network(
          product.productImage,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderImage(),
        ),
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.shopping_basket, size: 48, color: Colors.grey),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'dozen':
        return Colors.orange;
      case 'whole':
        return Colors.blue;
      case 'plain':
        return Colors.green;
      case 'fresh':
        return Colors.green;
      case 'organic':
        return Colors.purple;
      case 'classic':
        return Colors.red;
      case 'chicken':
        return Colors.amber;
      case 'olive':
        return Colors.teal;
      case 'sharp':
        return Colors.orange;
      case 'unsalted':
        return Colors.yellow;
      case 'regular':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'english':
        return Colors.green;
      case 'red seedless':
        return Colors.red;
      case 'alphonso':
        return Colors.orange;
      case 'long grain':
        return Colors.brown;
      case 'spaghetti':
        return Colors.amber;
      case 'whole wheat':
        return Colors.brown;
      case 'pure':
        return Colors.amber;
      case 'smooth':
        return Colors.orange;
      case 'mixed colors':
        return Colors.purple;
      case 'navel':
        return Colors.orange;
      case 'russet':
        return Colors.brown;
      case 'roma':
        return Colors.red;
      case 'gala':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _addToCart(BuildContext context) {
    try {
      // Get user ID
      final userSharedPrefs = serviceLocator<UserSharedPrefs>();
      final userId = userSharedPrefs.getCurrentUserId();

      if (userId == null || userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to add items to cart'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create cart item
      final cartItem = CartItemEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        quantity: 1,
        selectedSize: product.size,
        addedAt: DateTime.now(),
      );

      // Add to cart using CartViewModel
      final cartViewModel = serviceLocator<CartViewModel>();
      cartViewModel.add(AddToCartEvent(item: cartItem, userId: userId));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.team} added to cart!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'View Cart',
            textColor: Colors.white,
            onPressed: () {
              // Navigate to cart tab
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ),
      );
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSizeSelector(BuildContext context) {
    final List<String> availableSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                'Select Size for ${product.team}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Size grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                ),
                itemCount: availableSizes.length,
                itemBuilder: (context, index) {
                  final size = availableSizes[index];
                  final isCurrentSize = size == product.size;

                  return GestureDetector(
                    onTap: () {
                      // Here you can add logic to update the product size
                      // For now, we'll just show a snackbar
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Size $size selected for ${product.team}',
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCurrentSize
                            ? Theme.of(context).primaryColor
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCurrentSize
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300]!,
                          width: isCurrentSize ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          size,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCurrentSize
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
