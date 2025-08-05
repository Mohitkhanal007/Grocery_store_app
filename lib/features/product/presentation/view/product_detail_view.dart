import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';
import 'package:grocerystore/features/product/presentation/viewmodel/product_viewmodel.dart';

class ProductDetailView extends StatefulWidget {
  final String productId;
  final ProductEntity? initialProduct;
  final VoidCallback? onNavigateToCart;

  const ProductDetailView({
    super.key,
    required this.productId,
    this.initialProduct,
    this.onNavigateToCart,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  ProductEntity? _currentProduct;
  int _selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.initialProduct != null) {
      _currentProduct = widget.initialProduct;
    } else {
      context.read<ProductViewModel>().add(
        LoadProductByIdEvent(productId: widget.productId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _currentProduct != null
          ? _buildProductDetail(_currentProduct!)
          : BlocBuilder<ProductViewModel, ProductState>(
              builder: (context, state) {
                print(
                  'ProductDetailView: Current state is ${state.runtimeType}',
                );
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  print(
                    'ProductDetailView: Product loaded with size ${state.product.size}',
                  );
                  _currentProduct = state.product;
                  return _buildProductDetail(state.product);
                } else if (state is ProductUpdated) {
                  print(
                    'ProductDetailView: Product updated with size ${state.product.size}',
                  );
                  _currentProduct = state.product;
                  return _buildProductDetail(state.product);
                } else if (state is ProductError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductViewModel>().add(
                              LoadProductByIdEvent(productId: widget.productId),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('Product not found'));
              },
            ),
    );
  }

  Widget _buildProductDetail(ProductEntity product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
            ),
            child: _buildProductImage(product),
          ),
          const SizedBox(height: 24),

          // Product Info
          Text(
            product.team,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Type and Size
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getTypeColor(product.type),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  product.type,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: Text(
                  product.size,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Price
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Spacer(),
              if (product.quantity > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'In Stock (${product.quantity})',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Out of Stock',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Quantity Selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _selectedQuantity > 1
                          ? () => setState(() => _selectedQuantity--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: _selectedQuantity > 1
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      iconSize: 28,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        '$_selectedQuantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _selectedQuantity < product.quantity
                          ? () => setState(() => _selectedQuantity++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                      color: _selectedQuantity < product.quantity
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      iconSize: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Available: ${product.quantity} in stock',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: product.quantity > 0
                  ? () => _addToCart(context, product)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProductImage(ProductEntity product) {
    if (product.productImage.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          product.productImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderImage(),
        ),
      );
    } else if (product.productImage.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          product.productImage,
          fit: BoxFit.cover,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[300],
      ),
      child: const Center(
        child: Icon(Icons.shopping_basket, size: 64, color: Colors.grey),
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

  void _addToCart(BuildContext context, ProductEntity product) {
    final cartItem = CartItemEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      product: product,
      quantity: _selectedQuantity,
      selectedSize: product.size,
      addedAt: DateTime.now(),
    );

    // Add to cart using CartViewModel
    context.read<CartViewModel>().add(AddToCartEvent(item: cartItem));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedQuantity}x ${product.team} added to cart!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            // Close product detail and navigate to cart
            Navigator.pop(context);
            // Use the callback to switch to cart tab
            if (widget.onNavigateToCart != null) {
              widget.onNavigateToCart!();
            }
          },
        ),
      ),
    );
  }
}
