import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/features/category/domain/entity/category_entity.dart';
import 'package:grocerystore/features/category/presentation/view/category_list_view.dart';
import 'package:grocerystore/features/category/presentation/viewmodel/category_viewmodel.dart';
import 'package:grocerystore/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';
import 'package:grocerystore/features/product/presentation/view/product_detail_view.dart';
import 'package:grocerystore/features/product/presentation/viewmodel/product_viewmodel.dart';
import 'package:grocerystore/features/product/presentation/widgets/product_card.dart';

class ProductListView extends StatefulWidget {
  final VoidCallback? onNavigateToCart;

  const ProductListView({super.key, this.onNavigateToCart});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final TextEditingController _searchController = TextEditingController();
  CategoryEntity? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<ProductViewModel>().add(LoadAllProductsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      // If a category is selected, we should search within that category
      // For now, we'll use the general search and filter client-side
      // TODO: Implement server-side search within category
      context.read<ProductViewModel>().add(SearchProductsEvent(query: query));
    } else {
      // If no search query, show products based on current category selection
      if (_selectedCategory == null) {
        context.read<ProductViewModel>().add(LoadAllProductsEvent());
      } else {
        context.read<ProductViewModel>().add(
          LoadProductsByCategoryEvent(categoryId: _selectedCategory!.id),
        );
      }
    }
  }

  void _onCategorySelected(CategoryEntity? category) {
    setState(() {
      _selectedCategory = category;
    });

    if (category == null) {
      // Show All selected
      context.read<ProductViewModel>().add(LoadAllProductsEvent());
    } else {
      // Specific category selected
      context.read<ProductViewModel>().add(
        LoadProductsByCategoryEvent(categoryId: category.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search groceries...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _onSearch('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: _onSearch,
          ),
        ),
        // Categories
        SizedBox(
          height: 120,
          child: BlocProvider(
            create: (context) => serviceLocator<CategoryViewModel>(),
            child: CategoryListView(
              selectedCategoryId: _selectedCategory?.id,
              onCategorySelected: _onCategorySelected,
            ),
          ),
        ),
        // Products Grid
        Expanded(
          child: BlocBuilder<ProductViewModel, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductsLoaded) {
                if (state.products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_basket,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No groceries found',
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color ??
                                Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildProductsGrid(state.products);
              } else if (state is ProductError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              Theme.of(context).textTheme.bodyLarge?.color ??
                              Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProductViewModel>().add(
                            LoadAllProductsEvent(),
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: Text(
                  'No groceries available',
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        Theme.of(context).textTheme.bodyLarge?.color ??
                        Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductsGrid(List<ProductEntity> products) {
    List<ProductEntity> filteredProducts;

    if (_selectedCategory != null) {
      // If a category is selected, filter products by that category
      filteredProducts = products.where((product) {
        return _matchesSelectedCategory(product.team, _selectedCategory!.name);
      }).toList();
    } else {
      // If no category selected, show all products from supported categories
      filteredProducts = products.where((product) {
        return _hasValidCategory(product.team);
      }).toList();
    }

    if (filteredProducts.isEmpty) {
      String message = _selectedCategory != null
          ? 'No ${_selectedCategory!.name} items found'
          : 'No groceries from supported categories found';

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_basket, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color:
                    Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            if (_selectedCategory == null) ...[
              SizedBox(height: 8),
              Text(
                'Try adjusting your search or filters',
                style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ProductCard(
          product: product,
          onTap: () {
            // Navigate to product detail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => serviceLocator<ProductViewModel>(),
                    ),
                    BlocProvider(
                      create: (context) => serviceLocator<CartViewModel>(),
                    ),
                  ],
                  child: ProductDetailView(
                    productId: product.id,
                    initialProduct: product,
                    onNavigateToCart: widget.onNavigateToCart,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool _hasValidCategory(String productName) {
    String lowerName = productName.toLowerCase();

    // Check for dairy products
    if (lowerName.contains('milk') ||
        lowerName.contains('eggs') ||
        lowerName.contains('yogurt') ||
        lowerName.contains('cheese') ||
        lowerName.contains('butter') ||
        lowerName.contains('cream')) {
      return true;
    }

    // Check for vegetables
    if (lowerName.contains('potato') ||
        lowerName.contains('spinach') ||
        lowerName.contains('tomato') ||
        lowerName.contains('carrot') ||
        lowerName.contains('onion') ||
        lowerName.contains('cucumber') ||
        lowerName.contains('broccoli') ||
        lowerName.contains('pepper')) {
      return true;
    }

    // Check for fruits
    if (lowerName.contains('apple') ||
        lowerName.contains('banana') ||
        lowerName.contains('orange') ||
        lowerName.contains('strawberry') ||
        lowerName.contains('grape') ||
        lowerName.contains('pineapple') ||
        lowerName.contains('mango')) {
      return true;
    }

    // Check for pantry & snacks
    if (lowerName.contains('oil') ||
        lowerName.contains('noodle') ||
        lowerName.contains('ketchup') ||
        lowerName.contains('chip') ||
        lowerName.contains('rice') ||
        lowerName.contains('pasta') ||
        lowerName.contains('bread') ||
        lowerName.contains('honey') ||
        lowerName.contains('peanut')) {
      return true;
    }

    return false;
  }

  bool _matchesSelectedCategory(String productName, String categoryName) {
    String lowerProductName = productName.toLowerCase();
    String lowerSelectedCategory = categoryName.toLowerCase();

    // Map category names to product patterns
    switch (lowerSelectedCategory) {
      case 'fruits':
        return lowerProductName.contains('apple') ||
            lowerProductName.contains('banana') ||
            lowerProductName.contains('orange') ||
            lowerProductName.contains('strawberry') ||
            lowerProductName.contains('grape') ||
            lowerProductName.contains('pineapple') ||
            lowerProductName.contains('mango');
      case 'vegetables':
        return lowerProductName.contains('potato') ||
            lowerProductName.contains('spinach') ||
            lowerProductName.contains('tomato') ||
            lowerProductName.contains('carrot') ||
            lowerProductName.contains('onion') ||
            lowerProductName.contains('cucumber') ||
            lowerProductName.contains('broccoli') ||
            lowerProductName.contains('pepper');
      case 'dairy':
        return lowerProductName.contains('milk') ||
            lowerProductName.contains('eggs') ||
            lowerProductName.contains('yogurt') ||
            lowerProductName.contains('cheese') ||
            lowerProductName.contains('butter') ||
            lowerProductName.contains('cream');
      case 'pantry & snacks':
        return lowerProductName.contains('oil') ||
            lowerProductName.contains('noodle') ||
            lowerProductName.contains('ketchup') ||
            lowerProductName.contains('chip') ||
            lowerProductName.contains('rice') ||
            lowerProductName.contains('pasta') ||
            lowerProductName.contains('bread') ||
            lowerProductName.contains('honey') ||
            lowerProductName.contains('peanut');
      default:
        return false;
    }
  }
}
